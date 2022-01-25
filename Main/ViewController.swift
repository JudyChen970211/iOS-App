//  ViewController.swift
//  FinalProject

import UIKit
import SQLite

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    // 宣告database table
    var table_inTeamView:Table = Table( "Celebration" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let classification_db = Expression<String>( "classification" )
    let event_db = Expression<String>( "event" )
    let repeat_db = Expression<Bool>( "repeat" )
    let frequency_db = Expression<String>( "frequency" )
    let important_db = Expression<Bool>( "important" )
    
    // table view struct
    struct celebration {
        var classification = ""
        var event = ""
        var important = false
    }
    
    var celebrations = [celebration]()
    
    var tempDate = ""
    var tempDates = [String]()
    var cellList:[DateCollectionViewCell] = []
    
    @IBOutlet weak var CalendarTable: UITableView!
    @IBOutlet weak var add_diary: UIButton!
    @IBOutlet weak var add_money: UIButton!
    @IBOutlet weak var add_travel: UIButton!
    @IBOutlet weak var add_celebration: UIButton!

    @IBOutlet weak var MonthYearLabel: UILabel!
    
    @IBOutlet weak var CalendarCollection: UICollectionView!

    var lastTouch = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        add_diary.isHidden = true
        add_money.isHidden = true
        add_travel.isHidden = true
        add_celebration.isHidden = true
        celebrations.removeAll()
        findCelebration()
        CalendarTable.reloadData()
    }
    
    // 新增
    @IBAction func add(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        if ( tempDate == "" ) { tempDate = dateFormatter.string(from: Date())}
        
        if ( tempDate > dateFormatter.string(from: Date()) ){
            add_diary.isHidden = true
            add_money.isHidden = true
            add_travel.isHidden = true
            add_celebration.isHidden = false
        }
        else {
            add_diary.isHidden = false
            add_money.isHidden = false
            add_travel.isHidden = false
            add_celebration.isHidden = false
        }
    }

    // button & segue連接
    @IBAction func DiaryButton(_ sender: Any) {
        //print (tempDate)
        performSegue(withIdentifier: "segue_diary", sender: tempDate)
    }
    

    @IBAction func Money_Button(_ sender: UIButton) {
       performSegue(withIdentifier: "segue_money", sender: tempDate)
    }
    @IBAction func Travel_Button(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_travel", sender: tempDate)
    }
    @IBAction func Celebration_Button(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_celebration", sender: tempDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue_diary"){
            let date_sender = segue.destination as! AddDiaryVC
            date_sender.date = sender as! String
        }
        else if (segue.identifier == "segue_money"){
            let date_sender = segue.destination as! AddMoneyVC
            date_sender.date = sender as! String
        }
        else if (segue.identifier == "segue_travel"){
            let date_sender = segue.destination as! AddTravelVC
            date_sender.date = sender as! String
        }
        else if (segue.identifier == "segue_celebration"){
            let date_sender = segue.destination as! AddCelebrationVC
            date_sender.date = sender as! String
        }
    }

    // 月曆部分
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "Octorber", "November", "December"]
    let DaysOfMonth = [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]
    var DaysInMonths = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
    var currentMonth = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CalendarTable.delegate = self
        CalendarTable.dataSource = self
        do {
            // 連結database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            let database = try Connection( fileUrl.path )
            
            self.database = database
        }catch{
            print( "error when connect to the database in viewdid" )
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        tempDate = dateFormatter.string(from: Date())
        findCelebration()
        currentMonth = Months[month]
        MonthYearLabel.text = "\(currentMonth) \(year)"
        transfer()
    }
    
    var NumberOfEmptyBox = Int() // the number of empty boxes at the start of the current month
    var NextNumberOfEmptyBox = Int() // the number of empty boxes at the start of the next month
    var PreviousNumberOfEmptyBox = 0 // the number of empty boxes at the start of the previous month
    var Direction = 0 // 0<- in current month, 1<- in future month, -1<- in past month
    var PositionIndex = 0
    var LeapYearCounter = 3 // 閏年
    
    
    // 按下一個月
    @IBAction func NextButton(_ sender: Any) {
        cellList = []
        add_diary.isHidden = true
        add_money.isHidden = true
        add_travel.isHidden = true
        add_celebration.isHidden = true
        // print(NumberOfEmptyBox)
        // print(NextNumberOfEmptyBox)
        // print(PreviousNumberOfEmptyBox)
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            Direction = 1
            if ( LeapYearCounter < 5 ) {
                LeapYearCounter += 1
            }
            if ( LeapYearCounter == 4 ) {
                DaysInMonths[1] = 29
            }
            if ( LeapYearCounter == 5 ) {
                LeapYearCounter = 1
                DaysInMonths[1] = 28
            }
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthYearLabel.text = "\(currentMonth) \(year)"
            tempDates.removeAll()
            transfer()
            CalendarCollection.reloadData()
        default:
            Direction = 1
            GetStartDateDayPosition()
            month += 1
            currentMonth = Months[month]
            MonthYearLabel.text = "\(currentMonth) \(year)"
            tempDates.removeAll()
            transfer()
            CalendarCollection.reloadData()
        }
        celebrations.removeAll()
        CalendarTable.reloadData()
    }
    
    // 按前一個月
    @IBAction func PreviousButton(_ sender: Any) {
        cellList = []
        add_diary.isHidden = true
        add_money.isHidden = true
        add_travel.isHidden = true
        add_celebration.isHidden = true
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
            if ( LeapYearCounter > 0 ) {
                LeapYearCounter -= 1
            } // if
            if ( LeapYearCounter == 0 ) {
                DaysInMonths[1] = 29
                LeapYearCounter = 4
            } // if
            else { DaysInMonths[1] = 28 }
            
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthYearLabel.text = "\(currentMonth) \(year)"
            tempDates.removeAll()
            transfer()
            CalendarCollection.reloadData()
        default:
            month -= 1
            Direction = -1
            GetStartDateDayPosition()
            currentMonth = Months[month]
            MonthYearLabel.text = "\(currentMonth) \(year)"
            tempDates.removeAll()
            transfer()
            CalendarCollection.reloadData()
        }
        celebrations.removeAll()
        CalendarTable.reloadData()
    }
    
    // 算每個月的第一天是禮拜幾
    func GetStartDateDayPosition() {
        
        switch Direction {
        case 0 :
            switch day {
            case 1...7 : NumberOfEmptyBox = weekday - day
            case 8...14 : NumberOfEmptyBox = weekday - day - 7
            case 15...21 : NumberOfEmptyBox = weekday - day - 14
            case 22...28 : NumberOfEmptyBox = weekday - day - 21
            case 29...31 : NumberOfEmptyBox = weekday - day - 28
            default : break
            }
            PositionIndex = NumberOfEmptyBox
        case 1... :
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
        case -1 :
            PreviousNumberOfEmptyBox = ( 7 - (DaysInMonths[month]-PositionIndex)%7)
            if ( PreviousNumberOfEmptyBox == 7 ) { PreviousNumberOfEmptyBox = 0 }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    func initcolor() -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let today = dateFormatter.string(from: Date())
        add_diary.isHidden = true
        add_money.isHidden = true
        add_travel.isHidden = true
        add_celebration.isHidden = true
        for i in 0...cellList.count-1{
            if(tempDates[i] != today){ // 今天以外的日期顯示透明
                cellList[i].backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            }
            else{ // 今天顯示灰色
                cellList[i].backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(lastTouch != tempDates[indexPath.item]){ // 按日期 日期變紅色
            initcolor()
            cellList[indexPath.item].backgroundColor  = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
            tempDate = tempDates[indexPath.item]
        }
        else { // 再按一次日期 取消 // 若按的是今天 則變回灰色
            cellList[indexPath.item].backgroundColor  = UIColor.clear
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            tempDate = dateFormatter.string(from: Date())
            if(tempDates[indexPath.item] == tempDate){
                cellList[indexPath.item].backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
            }
        }
        
        // 重整calendar
        celebrations.removeAll()
        findCelebration()
        CalendarTable.reloadData()
        
        print (cellList[indexPath.item].DateLabel.text!)
        
        lastTouch = tempDate // 暫存最後一次按的
    }
    
    // calendar collection view 要顯示的數量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction {
        case 0 : return DaysInMonths[month] + NumberOfEmptyBox + 2 
        case 1 : return DaysInMonths[month] + NextNumberOfEmptyBox + 2
        case -1 : return DaysInMonths[month] + PreviousNumberOfEmptyBox + 2
        default : fatalError()
        }
    }
    
    // calendar collection view 要顯示的內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calender", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        //cell.DateButton.backgroundColor = UIColor.clear
        
        if (cell.isHidden) { cell.isHidden = false } // 換其他月時會先將所有cell顯示
        if (cell.DateLabel.textColor == UIColor.lightGray ) { cell.DateLabel.textColor = UIColor.black }
        
        switch Direction { // 日期顯示
        case 0 : cell.DateLabel.text = "\(indexPath.row - 1 - NumberOfEmptyBox)"
        case 1 : cell.DateLabel.text = "\(indexPath.row - 1 - NextNumberOfEmptyBox)"
        case -1 : cell.DateLabel.text = "\(indexPath.row - 1 - PreviousNumberOfEmptyBox)"
        default : fatalError()
        }
        
        if (Int( (cell.DateLabel.text)! )! < 1 ) { cell.isHidden = true } // 當月1號以前的cell隱藏
        
        switch indexPath.row { // 六日變灰色
        case 0, 6, 7, 13, 14, 20, 21, 27, 28 , 34, 35, 41, 42, 48, 49 :
            if (Int((cell.DateLabel.text)! )! > 0 ) { cell.DateLabel.textColor = UIColor.lightGray }
        default : break
        }
        
        cellList.append(cell)
        return cell
        
    }
    
    
    // 年月的切換顯示
    func transfer() -> Void {
        var day = 0
        var date = ""
        switch Direction {
        case 0 : day = DaysInMonths[month] + NumberOfEmptyBox + 2 // 目前月份第一天星期六開始所以+6
        case 1 : day = DaysInMonths[month] + NextNumberOfEmptyBox + 2
        case -1 : day = DaysInMonths[month] + PreviousNumberOfEmptyBox + 2
        default : fatalError()
        }
        for i in DaysInMonths[month]-day+1...DaysInMonths[month]{
            if ( month >= 9 && i > 9) { date = String(year) + " " + String(month+1) + " " + String(i) }
            else if ( month < 9 && i <= 9) { date = String(year) + " 0" + String(month+1) + " 0" + String(i) }
            else if ( month >= 9 && i <= 9 ) { date = String(year) + " " + String(month+1) + " 0" + String(i) }
            else { date = String(year) + " 0" + String(month+1) + " " + String(i)}
            tempDates.append(date)
        }
        
    }
    
    
    // celebration table view 要顯示的數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrations.count
    }
    
    // celebration table view 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CalendarTableViewCell = CalendarTable.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarTableViewCell
        cell.ClassificationLable?.text = celebrations[indexPath.row].classification
        cell.EventLabel?.text = celebrations[indexPath.row].event
        if(celebrations[indexPath.row].important == true){
            cell.ClassificationLable.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
            cell.EventLabel.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
        }
        else{
            cell.ClassificationLable.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
            cell.EventLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
            
        }
        return cell
    }
    
    // 連結資料庫 拿當日的celebration的資料
    func findCelebration() -> Void {
        let dateFormatter = DateFormatter()
        var historyDate: Date
        var nowDate: Date
        var celebrationExsist: Bool = false
        do {
            let celebration_table = try self.database.prepare(self.table_inTeamView)
            
            for celebration_tables in celebration_table {
                dateFormatter.dateFormat = "yyyy MM dd"
                historyDate = dateFormatter.date(from: celebration_tables[self.date_db])!
                nowDate = dateFormatter.date(from: tempDate)!
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: historyDate, to: nowDate)
                let day = components.day
                if(celebration_tables[self.date_db] < tempDate && celebration_tables[self.repeat_db] == true){
                    if(celebration_tables[self.frequency_db] == "weekly" && day! % 7 == 0 ){ celebrationExsist = true }
                    else{
                        dateFormatter.dateFormat = "dd"
                        if(celebration_tables[self.frequency_db] == "month" && dateFormatter.string(from: historyDate) == dateFormatter.string(from: nowDate)) { celebrationExsist = true }
                        dateFormatter.dateFormat = "MM dd"
                        if(celebration_tables[self.frequency_db] == "year" && dateFormatter.string(from: historyDate) == dateFormatter.string(from: nowDate)) { celebrationExsist = true }
                    }
                }
                else if( celebration_tables[self.date_db] == tempDate ){ celebrationExsist = true }
                if(celebrationExsist){
                    celebrations.append(celebration(classification: celebration_tables[self.classification_db], event: celebration_tables[self.event_db], important: celebration_tables[self.important_db]))
                    celebrationExsist = false
                }
            } // for
        }
        catch {
            print("error")
        } // catch
        
        // 固定節日寫入struct一併顯示
        dateFormatter.dateFormat = "yyyy MM dd"
        nowDate = dateFormatter.date(from: tempDate)!
        dateFormatter.dateFormat = "MM dd"
        if(dateFormatter.string(from: nowDate) == "01 01"){ celebrations.append(celebration(classification: "celebration", event: "元旦", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "02 14"){ celebrations.append(celebration(classification: "celebration", event: "情人節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "02 28"){ celebrations.append(celebration(classification: "celebration", event: "二二八紀念日", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "04 01"){ celebrations.append(celebration(classification: "celebration", event: "愚人節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "04 04"){ celebrations.append(celebration(classification: "celebration", event: "兒童節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "04 05"){ celebrations.append(celebration(classification: "celebration", event: "清明節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "05 01"){ celebrations.append(celebration(classification: "celebration", event: "勞動節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "08 08"){ celebrations.append(celebration(classification: "celebration", event: "父親節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "10 10"){ celebrations.append(celebration(classification: "celebration", event: "國慶日", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "10 31"){ celebrations.append(celebration(classification: "celebration", event: "萬聖節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "11 11"){ celebrations.append(celebration(classification: "celebration", event: "光棍節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "12 25"){ celebrations.append(celebration(classification: "celebration", event: "聖誕節", important: false)) }
        else if(dateFormatter.string(from: nowDate) == "12 31"){ celebrations.append(celebration(classification: "celebration", event: "跨年", important: false)) }
    }
}

