//  TravelVC.swift
//  FinalProject

import UIKit
import SQLite

class TravelVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var Travel: UITableView!
    var table_inTeamView:Table = Table( "Travel" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let state_db = Expression<String>( "state" )
    let country_db = Expression<String>( "country" )
    let place_db = Expression<String>( "place" )
    let like_db = Expression<Int>( "like" )
    let data_db = Expression<String>( "data" )
    let photo_db = Expression<String>( "photo" )
    let second_db = Expression<String>( "second" )
    
    struct travel {
        var date: String = ""
        var state: String = ""
        var country: String = ""
        var place: String = ""
        var like: Int = 0
        var data: String = ""
        var photo: String = ""
        var second: String = ""
    }
    
    var travels = [travel]()
    override func viewDidLoad() {
        configureTapGestur()
        super.viewDidLoad()
        Travel.delegate = self
        Travel.dataSource = self
        let count = -1
        var currentdate = Date()
        var endDate = ""
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            let database = try Connection( fileUrl.path )
            
            self.database = database
        }catch{
            print( "error when connect to the database in viewdid" )
        }
        for _ in 1...countDays(){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            endDate = dateFormatter.string(from: currentdate)
            travelExsist(endDate: endDate)
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    // 顯示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TravelTableViewCell = Travel.dequeueReusableCell(withIdentifier: "TravelCell", for: indexPath) as! TravelTableViewCell
        cell.DateLabel?.text = travels[indexPath.row].date
        cell.CountryLabel?.text = travels[indexPath.row].country
        if(travels[indexPath.row].like == 1){cell.LikeLabel?.text = "♥"}
        else if(travels[indexPath.row].like == 2){cell.LikeLabel?.text = "♥ ♥"}
        else if(travels[indexPath.row].like == 3){cell.LikeLabel?.text = "♥ ♥ ♥"}
        else if(travels[indexPath.row].like == 4){cell.LikeLabel?.text = "♥ ♥ ♥ ♥"}
        else if(travels[indexPath.row].like == 5){cell.LikeLabel?.text = "♥ ♥ ♥ ♥ ♥"}
        cell.PlaceLabel?.text = travels[indexPath.row].place
        print(travels[indexPath.row].photo)
        if(travels[indexPath.row].photo == ""){
            cell.PhotoImage.image = UIImage(named: "NoDataInput")
            cell.PhotoImage.contentMode = UIViewContentMode.scaleAspectFit
        }
        else{
            let imageUrlString = travels[indexPath.row].photo
            let imageUrl:URL = URL(string: imageUrlString)!
            
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    cell.PhotoImage.image = image
                    cell.PhotoImage.contentMode = UIViewContentMode.scaleAspectFit
                }
            }
        }
        return cell
    }
    
    // 刪除並更新
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let deleteDiary  = self.table_inTeamView.filter(self.second_db == travels[indexPath.row].second)
            let deleteDiarys = deleteDiary.delete()
            
            do {
                try self.database?.run( deleteDiarys )
            }
            catch {
                print( "error happen when delet Table" )
            }
            travels.remove(at: indexPath.row)
            
            Travel.beginUpdates()
            Travel.deleteRows(at: [indexPath], with: .fade)
            Travel.endUpdates()
            
        }
    }
    
    // 以喜愛程度排序
    @IBAction func SortLike(_ sender: Any) {
        travels.removeAll()
        if(searchDate == ""){
            for i in 1...5{ travelExsist_Like(endLike: 6-i) }
        }
        else{
            for i in searchLike...5{ travelExsist_Like(endLike: 6-i) }
        }
        Travel.reloadData()
        LikeSort.isHidden = true
        DateSort.isHidden = false
    }
    
    // 以日期排序
    @IBAction func SortDate(_ sender: Any) {
        let count = -1
        var currentdate = Date()
        var endDate = ""
        travels.removeAll()
        if(searchDate == ""){
            for _ in 1...countDays(){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
                endDate = dateFormatter.string(from: currentdate)
                travelExsist(endDate: endDate)
                currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
            }
        }
        else{travelExsist(endDate: searchDate)}
        Travel.reloadData()
        LikeSort.isHidden = false
        DateSort.isHidden = true
    }
    
    // 找此日期的旅遊是否存在
    // 有的話 存入struct
    func travelExsist(endDate: String) ->Void {
        var state_temp: String = ""
        var country_temp: String = ""
        var place_temp: String = ""
        var like_temp: Int = 0
        var data_temp: String = ""
        do {
            let travel_table = try self.database.prepare(self.table_inTeamView)
            
            for travel_tables in travel_table {
                if(searchState == ""){state_temp = ""}
                else{state_temp = travel_tables[self.state_db]}
                if(searchCountry == ""){country_temp = ""}
                else{country_temp = travel_tables[self.country_db]}
                if(searchPlace == ""){place_temp = ""}
                else{place_temp = travel_tables[self.place_db]}
                if(searchLike == 0){like_temp = 0}
                else{like_temp = travel_tables[self.like_db]}
                if(searchKeyword == ""){data_temp = ""}
                else{data_temp = travel_tables[self.data_db]}
                if(endDate == travel_tables[self.date_db] && state_temp == searchState && country_temp == searchCountry && findString(data: place_temp, search: searchPlace) && like_temp >= searchLike && findString(data: data_temp, search: searchKeyword) ){
                    travels.append(travel(date: travel_tables[self.date_db] , state: travel_tables[self.state_db], country: travel_tables[self.country_db], place: travel_tables[self.place_db], like: travel_tables[self.like_db] , data: travel_tables[self.data_db], photo: travel_tables[self.photo_db], second: travel_tables[self.second_db]))
                }
            } // for
        }
        catch {
        } // catch
    
    }
    
    // 找喜好程度是否存在
    // 有的話 存入struct
    func travelExsist_Like(endLike: Int) ->Void {
        var date_temp: String = ""
        var state_temp: String = ""
        var country_temp: String = ""
        var place_temp: String = ""
        var data_temp: String = ""
        do {
            let travel_table = try self.database.prepare(self.table_inTeamView)
            
            for travel_tables in travel_table {
                if(searchState == ""){state_temp = ""}
                else{state_temp = travel_tables[self.state_db]}
                if(searchCountry == ""){country_temp = ""}
                else{country_temp = travel_tables[self.country_db]}
                if(searchPlace == ""){place_temp = ""}
                else{place_temp = travel_tables[self.place_db]}
                if(searchDate == ""){date_temp = ""}
                else{date_temp = travel_tables[self.date_db]}
                if(searchKeyword == ""){data_temp = ""}
                else{data_temp = travel_tables[self.data_db]}
                if(endLike == travel_tables[self.like_db] && state_temp == searchState && country_temp == searchCountry && findString(data: place_temp, search: searchPlace) && date_temp == searchDate && findString(data: data_temp, search: searchKeyword)){
                    travels.append(travel(date: travel_tables[self.date_db] , state: travel_tables[self.state_db], country: travel_tables[self.country_db], place: travel_tables[self.place_db], like: travel_tables[self.like_db] , data: travel_tables[self.data_db], photo: travel_tables[self.photo_db], second: travel_tables[self.second_db]))
                }
            } // for
        }
        catch {
        } // catch
        
    }
    
    // 找關鍵字 ＆ 地點
    func findString(data: String, search: String) -> Bool {
        var check = false
        if(data == ""){return true}
        for searchs in search{
            check = data.contains(searchs)
        }
        return check
    }
    
    // 找今天到database有存在的資料的日期 有幾天
    func countDays() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        var endDate = Date()
        var startDate = Date()
        do {
            let date_table = try self.database.prepare(self.table_inTeamView)
            for date_tables in date_table {
                startDate = dateFormatter.date(from: date_tables[self.date_db])!
                if (endDate.compare(startDate) == .orderedDescending ){
                    endDate = startDate
                }
                
            } // for
            
        } // do
        catch {
        } // catch
        
        let components = calendar.dateComponents([.day], from: endDate, to: Date())
        
        let day = components.day
        print(components)
        return day!+1
        
    }
    
    var searchDate :String = ""
    var searchState: String = ""
    var searchCountry: String = ""
    var searchPlace: String = ""
    var searchLike: Int = 0
    var searchKeyword: String = ""
    
    @IBOutlet weak var LikeSort: UIButton!
    @IBOutlet weak var DateSort: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var eyesearch: UIButton!
    
    // 按搜尋先初始化 並顯示搜尋的view
    @IBAction func Search(_ sender: Any) {
        searchDate = ""
        searchState = ""
        searchCountry = ""
        searchPlace = ""
        searchLike = 0
        searchKeyword = ""
        tempButtonNum = 0
        SearchDatePicker.date = Date()
        SearchKeyword.text = ""
        SearchPlace.text = ""
        ChangePosition()
        SearchNorthAmerica.backgroundColor = UIColor.clear
        SearchSouthAmerica.backgroundColor = UIColor.clear
        SearchEurope.backgroundColor = UIColor.clear
        SearchAfrica.backgroundColor = UIColor.clear
        SearchAsia.backgroundColor = UIColor.clear
        SearchAustralia.backgroundColor = UIColor.clear
        SearchOneLike.backgroundColor = UIColor.clear
        SearchTwoLike.backgroundColor = UIColor.clear
        SearchThreeLike.backgroundColor = UIColor.clear
        SearchFourLike.backgroundColor = UIColor.clear
        SearchFiveLike.backgroundColor = UIColor.clear
        
        SearchButtonOne.setTitle( "", for: .normal)
        SearchButtonTwo.setTitle( "", for: .normal)
        SearchButtonThree.setTitle( "", for: .normal)
        SearchButtonFour.setTitle( "", for: .normal)
        SearchButtonFive.setTitle( "", for: .normal)
        SearchButtonSix.setTitle( "", for: .normal)
        
        SearchButtonOne.isHidden = true
        SearchButtonTwo.isHidden = true
        SearchButtonThree.isHidden = true
        SearchButtonFour.isHidden = true
        SearchButtonFive.isHidden = true
        SearchButtonSix.isHidden = true
        
        SearchButtonOne.isEnabled = true
        SearchButtonTwo.isEnabled = true
        SearchButtonThree.isEnabled = true
        SearchButtonFour.isEnabled = true
        SearchButtonFive.isEnabled = true
        SearchButtonSix.isEnabled = true
        
        SearchView.isHidden = false
        search.isHidden = true
        eyesearch.setImage(UIImage(named: "all"), for: .normal)
        eyesearch.isHidden = false
    }
    
    
    @IBOutlet weak var SearchDatePicker: UIDatePicker!
    
    @IBOutlet weak var SearchNorthAmerica: UIButton!
    @IBOutlet weak var SearchSouthAmerica: UIButton!
    @IBOutlet weak var SearchAustralia: UIButton!
    @IBOutlet weak var SearchAsia: UIButton!
    @IBOutlet weak var SearchAfrica: UIButton!
    @IBOutlet weak var SearchEurope: UIButton!
    
    @IBOutlet weak var SearchCountry: UISearchBar!
    @IBOutlet weak var SearchPlace: UITextField!
    
    @IBOutlet weak var SearchOneLike: UIButton!
    @IBOutlet weak var SearchTwoLike: UIButton!
    @IBOutlet weak var SearchThreeLike: UIButton!
    @IBOutlet weak var SearchFourLike: UIButton!
    @IBOutlet weak var SearchFiveLike: UIButton!
    
    @IBOutlet weak var SearchKeyword: UITextField!
    
    
    @IBOutlet weak var ButtonDate: UIButton!
    @IBOutlet weak var ButtonState: UIButton!
    @IBOutlet weak var ButtonCountry: UIButton!
    @IBOutlet weak var ButtonPlace: UIButton!
    @IBOutlet weak var ButtonLike: UIButton!
    @IBOutlet weak var ButtonKeyword: UIButton!
    
    var tempstate = ""
    var tempButtonNum = 0
    // 按要搜尋的button 呼叫changemood
    @IBAction func DateSearch(_ sender: UIButton) {
        if(tempstate == "Date"){ ChangeMood(state:"") }
        else{ ChangeMood(state:"Date") }
    }
    
    @IBAction func StateSearch(_ sender: UIButton) {
        if(tempstate == "State"){ ChangeMood(state:"") }
        else{ ChangeMood(state:"State") }
    }
    
    @IBAction func CountrySearch(_ sender: UIButton) {
        if(tempstate == "Country"){ ChangeMood(state:"") }
        else{ ChangeMood(state:"Country") }
    }
    
    @IBAction func PlaceSearch(_ sender: Any) {
        if(tempstate == "Place"){ ChangeMood(state:"") }
        else{ ChangeMood(state:"Place") }
    }
    
    @IBAction func LikeSearch(_ sender: UIButton) {
        if(tempstate == "Like"){ ChangeMood(state:"") }
        else{ ChangeMood(state:"Like") }
    }
    
    @IBAction func KeywordSearch(_ sender: Any) {
        if(tempstate == "Keyword"){ ChangeMood(state:"") }
        else{ ChangeMood(state:"Keyword") }
    }
    
    // 顯示選擇的搜尋的內容
    func ChangeMood(state:String) -> Void {
        SearchDatePicker.isHidden = true
        SearchAsia.isHidden = true
        SearchAfrica.isHidden = true
        SearchAustralia.isHidden = true
        SearchEurope.isHidden = true
        SearchNorthAmerica.isHidden = true
        SearchSouthAmerica.isHidden = true
        SearchCountry.isHidden = true
        SearchPlace.isHidden = true
        SearchOneLike.isHidden = true
        SearchTwoLike.isHidden = true
        SearchThreeLike.isHidden = true
        SearchFourLike.isHidden = true
        SearchFiveLike.isHidden = true
        SearchKeyword.isHidden = true
        tempstate = state
        if(state == ""){SearchView.frame.size.height = 47}
        else{
            SearchView.frame.size.height = 105
            if(state == "Date"){
                SearchDatePicker.isHidden = false
            }
            else if(state == "State"){
                SearchAsia.isHidden = false
                SearchAfrica.isHidden = false
                SearchAustralia.isHidden = false
                SearchEurope.isHidden = false
                SearchNorthAmerica.isHidden = false
                SearchSouthAmerica.isHidden = false
                SearchView.frame.size.height = 245
            }
            else if(state == "Country"){ SearchCountry.isHidden = false }
            else if(state == "Place"){ SearchPlace.isHidden = false }
            else if(state == "Like"){
                SearchOneLike.isHidden = false
                SearchTwoLike.isHidden = false
                SearchThreeLike.isHidden = false
                SearchFourLike.isHidden = false
                SearchFiveLike.isHidden = false
            }
            else if(state == "Keyword"){ SearchKeyword.isHidden = false }
        }
    }
    
    // //////////////////////////////////////////////////////////// //
    
    // 按搜尋的內容 並增加搜尋的button
    @IBAction func DatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        searchDate = dateFormatter.string(from: SearchDatePicker.date)
        AddOrChange(state: "Date", condition: searchDate)
    }
    
    @IBAction func NorthAmerica(_ sender: Any) {
        searchState = "NorthAmerica"
        SearchNorthAmerica.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        SearchSouthAmerica.backgroundColor = UIColor.clear
        SearchEurope.backgroundColor = UIColor.clear
        SearchAfrica.backgroundColor = UIColor.clear
        SearchAsia.backgroundColor = UIColor.clear
        SearchAustralia.backgroundColor = UIColor.clear
        AddOrChange(state: "State", condition: searchState)
    }
    
    @IBAction func SouthAmerica(_ sender: Any) {
        searchState = "SouthAmerica"
        SearchNorthAmerica.backgroundColor = UIColor.clear
        SearchSouthAmerica.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        SearchEurope.backgroundColor = UIColor.clear
        SearchAfrica.backgroundColor = UIColor.clear
        SearchAsia.backgroundColor = UIColor.clear
        SearchAustralia.backgroundColor = UIColor.clear
        AddOrChange(state: "State", condition: searchState)
    }
    
    @IBAction func Ausralia(_ sender: Any) {
        searchState = "Australia"
        SearchNorthAmerica.backgroundColor = UIColor.clear
        SearchSouthAmerica.backgroundColor = UIColor.clear
        SearchEurope.backgroundColor = UIColor.clear
        SearchAfrica.backgroundColor = UIColor.clear
        SearchAsia.backgroundColor = UIColor.clear
        SearchAustralia.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        AddOrChange(state: "State", condition: searchState)
    }
    
    @IBAction func Africa(_ sender: Any) {
        searchState = "Africa"
        SearchNorthAmerica.backgroundColor = UIColor.clear
        SearchSouthAmerica.backgroundColor = UIColor.clear
        SearchEurope.backgroundColor = UIColor.clear
        SearchAfrica.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        SearchAsia.backgroundColor = UIColor.clear
        SearchAustralia.backgroundColor = UIColor.clear
        AddOrChange(state: "State", condition: searchState)
    }
    
    @IBAction func Asia(_ sender: Any) {
        searchState = "Asia"
        SearchNorthAmerica.backgroundColor = UIColor.clear
        SearchSouthAmerica.backgroundColor = UIColor.clear
        SearchEurope.backgroundColor = UIColor.clear
        SearchAfrica.backgroundColor = UIColor.clear
        SearchAsia.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        SearchAustralia.backgroundColor = UIColor.clear
        AddOrChange(state: "State", condition: searchState)
    }
    
    @IBAction func Europe(_ sender: Any) {
        searchState = "Europe"
        SearchNorthAmerica.backgroundColor = UIColor.clear
        SearchSouthAmerica.backgroundColor = UIColor.clear
        SearchEurope.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        SearchAfrica.backgroundColor = UIColor.clear
        SearchAsia.backgroundColor = UIColor.clear
        SearchAustralia.backgroundColor = UIColor.clear
        AddOrChange(state: "State", condition: searchState)
    }
    
    @IBAction func placeText(_ sender: Any) {
        searchPlace = SearchPlace.text!
        if(searchPlace != ""){
            AddOrChange(state: "Place", condition: searchPlace)
        }
        ButtonDate.isEnabled = true
        ButtonLike.isEnabled = true
        ButtonPlace.isEnabled = true
        ButtonState.isEnabled = true
        ButtonCountry.isEnabled = true
        ButtonKeyword.isEnabled = true
        search.isEnabled = true
        eyesearch.isEnabled = true
        DateSort.isEnabled = true
        LikeSort.isEnabled = true
    }
    
    @IBAction func EditPlace(_ sender: Any) {
        ButtonDate.isEnabled = false
        ButtonLike.isEnabled = false
        ButtonPlace.isEnabled = false
        ButtonState.isEnabled = false
        ButtonCountry.isEnabled = false
        ButtonKeyword.isEnabled = false
        search.isEnabled = false
        eyesearch.isEnabled = false
        DateSort.isEnabled = false
        LikeSort.isEnabled = false
    }
    @IBAction func OneLike(_ sender: Any) {
        searchLike = 1
        self.SearchOneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchTwoLike.backgroundColor = UIColor.clear
        self.SearchThreeLike.backgroundColor = UIColor.clear
        self.SearchFourLike.backgroundColor = UIColor.clear
        self.SearchFiveLike.backgroundColor = UIColor.clear
        AddOrChange(state: "Like", condition: String(searchLike))
    }
    
    @IBAction func TwoLike(_ sender: Any) {
        searchLike = 2
        self.SearchOneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchTwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchThreeLike.backgroundColor = UIColor.clear
        self.SearchFourLike.backgroundColor = UIColor.clear
        self.SearchFiveLike.backgroundColor = UIColor.clear
        AddOrChange(state: "Like", condition: String(searchLike))
    }
    
    @IBAction func ThreeLike(_ sender: Any) {
        searchLike = 3
        self.SearchOneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchTwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchThreeLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchFourLike.backgroundColor = UIColor.clear
        self.SearchFiveLike.backgroundColor = UIColor.clear
        AddOrChange(state: "Like", condition: String(searchLike))
    }
    
    @IBAction func FourLike(_ sender: Any) {
        searchLike = 4
        self.SearchOneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchTwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchThreeLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchFourLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchFiveLike.backgroundColor = UIColor.clear
        AddOrChange(state: "Like", condition: String(searchLike))
    }
    
    @IBAction func FiveLike(_ sender: Any) {
        searchLike = 5
        self.SearchOneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchTwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchThreeLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchFourLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        self.SearchFiveLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        AddOrChange(state: "Like", condition: String(searchLike))
    }
    
    @IBAction func KeywordText(_ sender: Any) {
        searchKeyword = SearchKeyword.text!
        if(searchKeyword != ""){
            AddOrChange(state: "Keyword", condition: String(searchKeyword))
        }
        ButtonDate.isEnabled = true
        ButtonLike.isEnabled = true
        ButtonPlace.isEnabled = true
        ButtonState.isEnabled = true
        ButtonCountry.isEnabled = true
        ButtonKeyword.isEnabled = true
        search.isEnabled = true
        eyesearch.isEnabled = true
        DateSort.isEnabled = true
        LikeSort.isEnabled = true
    }
    
 
    @IBAction func EditKeyword(_ sender: Any) {
        ButtonDate.isEnabled = false
        ButtonLike.isEnabled = false
        ButtonPlace.isEnabled = false
        ButtonState.isEnabled = false
        ButtonCountry.isEnabled = false
        ButtonKeyword.isEnabled = false
        search.isEnabled = false
        eyesearch.isEnabled = false
        DateSort.isEnabled = false
        LikeSort.isEnabled = false
    }
    
     // 儲存要搜尋的條件 並更新struct 且更新tableview
    @IBAction func SearchSave(_ sender: Any) {
        let count = -1
        var currentdate = Date()
        var endDate = ""
        print(searchDate)
        print(searchState)
        print(searchCountry)
        print(searchPlace)
        print(searchLike)
        print(searchKeyword)
        travels.removeAll()
        if(searchDate == ""){
            for _ in 1...countDays(){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
                endDate = dateFormatter.string(from: currentdate)
                travelExsist(endDate: endDate)
                currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
            }
        }
        else{travelExsist(endDate: searchDate)}
        Travel.reloadData()
        
        ChangeMood(state: "")
        eyesearch.isHidden = true
        search.isHidden = false
        SearchView.isHidden = true
        LikeSort.isHidden = false
        DateSort.isHidden = true
        
        SearchButtonOne.isEnabled = false
        SearchButtonTwo.isEnabled = false
        SearchButtonThree.isEnabled = false
        SearchButtonFour.isEnabled = false
        SearchButtonFive.isEnabled = false
        SearchButtonSix.isEnabled = false
    }
    
    
    @IBOutlet weak var SearchButtonOne: UIButton!
    @IBOutlet weak var SearchButtonTwo: UIButton!
    @IBOutlet weak var SearchButtonThree: UIButton!
    @IBOutlet weak var SearchButtonFour: UIButton!
    @IBOutlet weak var SearchButtonFive: UIButton!
    @IBOutlet weak var SearchButtonSix: UIButton!
    
    // 刪除曾經增加過的條件
    @IBAction func ButtonOneDelete(_ sender: Any) {
        DeleteInfo(button: SearchButtonOne)
        SearchButtonOne.setTitle(SearchButtonTwo.titleLabel!.text!, for: .normal)
        SearchButtonTwo.setTitle(SearchButtonThree.titleLabel!.text!, for: .normal)
        SearchButtonThree.setTitle(SearchButtonFour.titleLabel!.text!, for: .normal)
        SearchButtonFour.setTitle(SearchButtonFive.titleLabel!.text!, for: .normal)
        SearchButtonFive.setTitle(SearchButtonSix.titleLabel!.text!, for: .normal)
        DeleteWhere(num: tempButtonNum).isHidden = true
        tempButtonNum -= 1
        ChangePosition()
    }
    
    @IBAction func ButtonTwoDelete(_ sender: Any) {
        DeleteInfo(button: SearchButtonTwo)
        SearchButtonTwo.setTitle(SearchButtonThree.titleLabel!.text!, for: .normal)
        SearchButtonThree.setTitle(SearchButtonFour.titleLabel!.text!, for: .normal)
        SearchButtonFour.setTitle(SearchButtonFive.titleLabel!.text!, for: .normal)
        SearchButtonFive.setTitle(SearchButtonSix.titleLabel!.text!, for: .normal)
        DeleteWhere(num: tempButtonNum).isHidden = true
        tempButtonNum -= 1
        ChangePosition()
    }
    
    @IBAction func ButtonThreeDelete(_ sender: Any) {
        DeleteInfo(button: SearchButtonThree)
        SearchButtonThree.setTitle(SearchButtonFour.titleLabel!.text!, for: .normal)
        SearchButtonFour.setTitle(SearchButtonFive.titleLabel!.text!, for: .normal)
        SearchButtonFive.setTitle(SearchButtonSix.titleLabel!.text!, for: .normal)
        DeleteWhere(num: tempButtonNum).isHidden = true
        tempButtonNum -= 1
        ChangePosition()
    }
    
    @IBAction func ButtonFourDelete(_ sender: Any) {
        DeleteInfo(button: SearchButtonFour)
        SearchButtonFour.setTitle(SearchButtonFive.titleLabel!.text!, for: .normal)
        SearchButtonFive.setTitle(SearchButtonSix.titleLabel!.text!, for: .normal)
        DeleteWhere(num: tempButtonNum).isHidden = true
        tempButtonNum -= 1
        ChangePosition()
    }
    
    @IBAction func ButtonFiveDelete(_ sender: Any) {
        DeleteInfo(button: SearchButtonFive)
        SearchButtonFive.setTitle(SearchButtonSix.titleLabel!.text!, for: .normal)
        DeleteWhere(num: tempButtonNum).isHidden = true
        tempButtonNum -= 1
        ChangePosition()
    }
    
    @IBAction func ButtonSixDelete(_ sender: Any) {
        DeleteInfo(button: SearchButtonSix)
        SearchButtonFive.setTitle("", for: .normal)
        DeleteWhere(num: tempButtonNum).isHidden = true
        tempButtonNum -= 1
        ChangePosition()
    }
    
    // 刪除曾經新增過的button字串的label
    func DeleteInfo( button: UIButton ) -> Void{
        if(tempButtonNum == 1) {eyesearch.setImage(UIImage(named: "all"), for: .normal)}
        if (button.titleLabel!.text!.hasPrefix("Date")){searchDate = ""}
        else if(button.titleLabel!.text!.hasPrefix("State")){searchState = ""}
        else if(button.titleLabel!.text!.hasPrefix("Country")){searchCountry = ""}
        else if(button.titleLabel!.text!.hasPrefix("Place")){searchPlace = ""}
        else if(button.titleLabel!.text!.hasPrefix("Like")){searchLike = 0}
        else if(button.titleLabel!.text!.hasPrefix("Keyword")){searchKeyword = ""}
    }
    
    // 刪除哪一個button？
    func DeleteWhere(num: Int) -> UIButton {
        if(num == 1){return SearchButtonOne}
        else if(num == 2){return SearchButtonTwo}
        else if(num == 3){return SearchButtonThree}
        else if(num == 4){return SearchButtonFour}
        else if(num == 5){return SearchButtonFive}
        else{return SearchButtonSix}
    }
    
    // 新增search button或更改
    func AddOrChange(state: String, condition: String) -> Void {
        if (SearchButtonOne.titleLabel!.text!.hasPrefix(state)){
            SearchButtonOne.setTitle( state + " : " + condition, for: .normal)
            SearchButtonOne.isHidden = false
            eyesearch.setImage(UIImage(named: "eyesearch"), for: .normal)
            ChangePosition()
        }
        else if (SearchButtonTwo.titleLabel!.text!.hasPrefix(state)){
            SearchButtonTwo.setTitle( state + " : " + condition, for: .normal)
            SearchButtonTwo.isHidden = false
            ChangePosition()
        }
        else if (SearchButtonThree.titleLabel!.text!.hasPrefix(state)){
            SearchButtonThree.setTitle( state + " : " + condition, for: .normal)
            SearchButtonThree.isHidden = false
            ChangePosition()
        }
        else if (SearchButtonFour.titleLabel!.text!.hasPrefix(state)){
            SearchButtonFour.setTitle( state + " : " + condition, for: .normal)
            SearchButtonFour.isHidden = false
            ChangePosition()
        }
        else if (SearchButtonFive.titleLabel!.text!.hasPrefix(state)){
            SearchButtonFive.setTitle( state + " : " + condition, for: .normal)
            SearchButtonFive.isHidden = false
            ChangePosition()
        }
        else if (SearchButtonSix.titleLabel!.text!.hasPrefix(state)){
            SearchButtonSix.setTitle( state + " : " + condition, for: .normal)
            SearchButtonSix.isHidden = false
            ChangePosition()
        }
        else{
            tempButtonNum += 1
            if(tempButtonNum == 1){
                SearchButtonOne.setTitle( state + " : " + condition, for: .normal)
                SearchButtonOne.isHidden = false
                eyesearch.setImage(UIImage(named: "eyesearch"), for: .normal)
                ChangePosition()
            }
            else if(tempButtonNum == 2){
                SearchButtonTwo.setTitle( state + " : " + condition, for: .normal)
                SearchButtonTwo.isHidden = false
                ChangePosition()
            }
            else if(tempButtonNum == 3){
                SearchButtonThree.setTitle( state + " : " + condition, for: .normal)
                SearchButtonThree.isHidden = false
                ChangePosition()
            }
            else if(tempButtonNum == 4){
                SearchButtonFour.setTitle( state + " : " + condition, for: .normal)
                SearchButtonFour.isHidden = false
                ChangePosition()
            }
            else if(tempButtonNum == 5){
                SearchButtonFive.setTitle( state + " : " + condition, for: .normal)
                SearchButtonFive.isHidden = false
                ChangePosition()
            }
            else if(tempButtonNum == 6){
                SearchButtonSix.setTitle( state + " : " + condition, for: .normal)
                SearchButtonSix.isHidden = false
                ChangePosition()
                
            }
        }
    }
    
    // 搜尋view隨搜尋條件數量 向下或向上移動
    func ChangePosition() {
        SearchViewgodown(num: tempButtonNum)
        ButtonGoDown(button: SearchNorthAmerica,num: 252 )
        ButtonGoDown(button: SearchSouthAmerica,num: 315 )
        ButtonGoDown(button: SearchEurope,num: 252 )
        ButtonGoDown(button: SearchAfrica,num: 294 )
        ButtonGoDown(button: SearchAsia,num: 221 )
        ButtonGoDown(button: SearchAustralia,num: 335 )
        ButtonGoDown(button: SearchOneLike,num: 219 )
        ButtonGoDown(button: SearchTwoLike,num: 219 )
        ButtonGoDown(button: SearchThreeLike,num: 219 )
        ButtonGoDown(button: SearchFourLike,num: 219 )
        ButtonGoDown(button: SearchFiveLike,num: 219 )
        TextFieldGoDown(textfield: SearchKeyword, num: 226)
        TextFieldGoDown(textfield: SearchPlace, num: 226)
        
        var xPosition = SearchDatePicker.frame.origin.x
        var width = SearchDatePicker.frame.width
        var height = SearchDatePicker.frame.height
        if ( tempButtonNum == 0 ) { SearchDatePicker.frame = CGRect(x: xPosition, y: 219, width: width, height: height) }
        else if ( tempButtonNum == 1 || tempButtonNum == 2 ) { SearchDatePicker.frame = CGRect(x: xPosition, y: 219+25, width: width, height: height) }
        else if ( tempButtonNum == 3 || tempButtonNum == 4 ) { SearchDatePicker.frame = CGRect(x: xPosition, y: 219+50, width: width, height: height) }
        else if ( tempButtonNum == 5 || tempButtonNum == 6 ) {SearchDatePicker.frame = CGRect(x: xPosition, y: 219+75, width: width, height: height) }
        
        xPosition = SearchCountry.frame.origin.x
        width = SearchCountry.frame.width
        height = SearchCountry.frame.height
        if ( tempButtonNum == 0 ) { SearchCountry.frame = CGRect(x: xPosition, y: 214, width: width, height: height) }
        else if ( tempButtonNum == 1 || tempButtonNum == 2 ) { SearchCountry.frame = CGRect(x: xPosition, y: 214+25, width: width, height: height) }
        else if ( tempButtonNum == 3 || tempButtonNum == 4 ) { SearchCountry.frame = CGRect(x: xPosition, y: 214+50, width: width, height: height) }
        else if ( tempButtonNum == 5 || tempButtonNum == 6 ) {SearchCountry.frame = CGRect(x: xPosition, y: 214+75, width: width, height: height) }
    }
    
    func SearchViewgodown(num: Int) -> Void {
        let xPosition = SearchView.frame.origin.x
        let width = SearchView.frame.width
        let height = SearchView.frame.height
        if ( num == 0 ) { SearchView.frame = CGRect(x: xPosition, y: 174, width: width, height: height) }
        else if ( num == 1 || num == 2 ) { SearchView.frame = CGRect(x: xPosition, y: 199, width: width, height: height) }
        else if ( num == 3 || num == 4 ) { SearchView.frame = CGRect(x: xPosition, y: 224, width: width, height: height) }
        else if ( num == 5 || num == 6 ) { SearchView.frame = CGRect(x: xPosition, y: 249, width: width, height: height) }
    }
    
    func ButtonGoDown( button: UIButton, num : Int) {
        let xPosition = button.frame.origin.x
        let width = button.frame.width
        let height = button.frame.height
        if ( tempButtonNum == 0 ) { button.frame = CGRect(x: xPosition, y: CGFloat(num), width: width, height: height) }
        else if ( tempButtonNum == 1 || tempButtonNum == 2 ) { button.frame = CGRect(x: xPosition, y: CGFloat(num+25), width: width, height: height) }
        else if ( tempButtonNum == 3 || tempButtonNum == 4 ) { button.frame = CGRect(x: xPosition, y: CGFloat(num+50), width: width, height: height) }
        else if ( tempButtonNum == 5 || tempButtonNum == 6 ) {button.frame = CGRect(x: xPosition, y: CGFloat(num+75), width: width, height: height) }
    }
    
    func TextFieldGoDown( textfield: UITextField, num : Int) {
        let xPosition = textfield.frame.origin.x
        let width = textfield.frame.width
        let height = textfield.frame.height
        if ( tempButtonNum == 0 ) { textfield.frame = CGRect(x: xPosition, y: CGFloat(num), width: width, height: height) }
        else if ( tempButtonNum == 1 || tempButtonNum == 2 ) { textfield.frame = CGRect(x: xPosition, y: CGFloat(num+25), width: width, height: height) }
        else if ( tempButtonNum == 3 || tempButtonNum == 4 ) { textfield.frame = CGRect(x: xPosition, y: CGFloat(num+50), width: width, height: height) }
        else if ( tempButtonNum == 5 || tempButtonNum == 6 ) {textfield.frame = CGRect(x: xPosition, y: CGFloat(num+75), width: width, height: height) }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func configureTapGestur() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector( AddCelebrationVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}
