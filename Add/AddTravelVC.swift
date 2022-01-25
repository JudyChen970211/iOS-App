//  AddTravelVC.swift
//  FinalProject

import UIKit
import MobileCoreServices
import SQLite

class AddTravelVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var NorthAmerica: UIButton!
    @IBOutlet weak var SouthAmerica: UIButton!
    @IBOutlet weak var Europe: UIButton!
    @IBOutlet weak var Africa: UIButton!
    @IBOutlet weak var Asia: UIButton!
    @IBOutlet weak var Australia: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: String = ""
    
    // 宣告database table
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
    
    
    var photoURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGestur()
        dateLabel.text = date
        Countrypicker.delegate = self
        Countrypicker.dataSource = self
        CountryName.inputView = Countrypicker
        OneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        // Do any additional setup after loading the view.
        do {
            // 連結database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            self.database = try Connection( fileUrl.path )
        }catch{
            print( "error when connect to the database in viewdid" )
        }
        
        let createTable = table_inTeamView.create { (table_useToCreate) in
            table_useToCreate.column(self.date_db)
            table_useToCreate.column(self.state_db)
            table_useToCreate.column(self.country_db)
            table_useToCreate.column(self.place_db)
            table_useToCreate.column(self.like_db)
            table_useToCreate.column(self.data_db)
            table_useToCreate.column(self.photo_db)
            table_useToCreate.column(self.second_db)
        }
        
        // 執行->創立
        do {
            try self.database?.run( createTable )
            print( "Create table success Travel" )
        } catch {
            print( "error when run in create Table" )
        } // catch
    }
    
    // textfield 打字時按空白處結束打字
    private func configureTapGestur() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector( AddTravelVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var IsNorthA = false, IsSouthA = false, IsEurope = false, IsAfrica = false, IsAsia = false, IsAustralia = false
    var state = ""
    
    // 五大洲顏色、選擇初始化
    func Choose() -> Void {
        NorthAmerica.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        SouthAmerica.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Europe.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Africa.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Asia.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Australia.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        IsNorthA = false
        IsSouthA = false
        IsEurope = false
        IsAfrica = false
        IsAsia = false
        IsAustralia = false
    }
    
    // 按下五大洲button 選擇的洲變綠色 洲暫存
    @IBAction func NorthAmericaButton(_ sender: UIButton) {
        Choose()
        NorthAmerica.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        state = "NorthAmerica"
        IsNorthA = true
    }
    
    @IBAction func SouthAmericaButton(_ sender: UIButton) {
        Choose()
        SouthAmerica.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        state = "SouthAmerica"
        IsSouthA = true
    }
    
    @IBAction func Europe(_ sender: UIButton) {
        Choose()
        Europe.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        state = "Europe"
        IsEurope = true
    }
    
    @IBAction func Africa(_ sender: UIButton) {
        Choose()
        Africa.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        state = "Africa"
        IsAfrica = true
    }
    
    @IBAction func Asia(_ sender: UIButton) {
        Choose()
        Asia.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        state = "Asia"
        IsAsia = true
    }
    
    @IBAction func Australia(_ sender: UIButton) {
        Choose()
        Australia.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
        state = "Australia"
        IsAustralia = true
    }
    
    // 內建五大洲國家
    @IBOutlet weak var CountryName: UITextField!
    var SelectCountry = ""
    var NorthACountry = [ "美國", "加拿大", "格陵蘭", "聖皮埃爾和密克隆群島", "百慕達" ]
    var SouthACountry = [ "巴西", "哥倫比亞", "阿根廷", "秘魯", "委內瑞拉", "智利", "厄瓜多", "玻利維雅", "巴拉圭", "烏拉圭", "蓋亞那", "蘇利南", "法屬圭亞那", "福克蘭群島", "南喬治亞和南桑威奇群島" ]
    var EuropeCountry = [ "英國", "法國", "愛爾蘭", "荷蘭", "比利時","盧森堡", "摩納哥", "澤西", "耿西", "曼島", "波蘭", "瑞士", "列支敦斯登", "奧地利", "匈牙利", "捷克", "斯洛伐克", "斯洛維尼亞", "德國", "葡萄牙", "西班牙", "安道爾", "希臘", "義大利", "聖馬利諾", "馬爾他", "梵蒂岡", "保加利亞", "羅馬尼亞", "塞爾維亞", "克羅埃西亞", "波士尼亞與赫賽哥維納", "蒙特內哥羅", "科索沃", "阿爾巴尼亞", "馬其頓", "直布羅陀", "丹麥", "挪威", "冰島", "芬蘭", "瑞典", "法羅群島", "布韋島", "烏克蘭", "白俄羅斯", "立陶宛", "拉脫維亞", "愛沙尼亞", "摩爾多瓦", "俄羅斯", "土耳其", "哈薩克", "亞塞拜然", "喬治亞", "賽普勒斯", "北賽普勒斯", "亞美尼亞"]
    var AfricaCountry = [ "阿爾及利亞", "安哥拉", "貝南", "波扎那", "布吉納法索", "蒲隆地", "維德角", "喀麥隆", "中非", "查德", "葛摩", "象牙海岸", "民主剛果", "吉布地",  "埃及", "赤道幾內亞", "厄利垂亞", "衣索比亞", "加彭", "甘比亞", "加納", "幾內亞", "幾內亞比索", "肯亞", "賴索托", "賴比瑞亞", "利比亞", "馬達加斯加", "馬拉威", "馬利", "茅利塔尼亞", "模里西斯", "莫三比克", "摩洛哥", "納米比亞", "尼日", "奈及利亞", "剛果", "盧安達", "聖多美普林西比", "塞內加爾", "塞席爾", "獅子山", "索馬利亞", "南非", "南蘇丹", "蘇丹", "史瓦帝尼", "坦尚尼亞", "多哥", "竹突尼西亞", "烏干達", "尚比亞", "辛巴威", "撒拉威阿拉伯民主共和國", "索馬利蘭"]
    var AsiaCountry = ["中華人民共和國", "日本", "台灣",  "韓國", "北韓", "蒙古", "越南", "寮國", "柬埔寨", "緬甸", "馬來西亞", "新加坡", "泰國", "菲律賓", "印尼", "東帝汶", "巴基斯坦", "印度", "不丹", "尼泊爾",  "孟加拉國", "馬爾地夫", "斯里蘭卡", "伊朗", "伊拉克", "科威特", "約旦", "沙烏地阿拉伯", "卡達", "巴林", "阿聯", "葉門", "阿曼", "以色列", "巴勒斯坦", "亞塞拜然", "亞美尼亞", "土耳其", "阿富汗", "黎巴嫩", "吉爾吉斯", "土庫曼", "塔吉克", "烏茲別克", "汶萊", "賽普勒斯", "敘利亞", "哈薩克", "俄羅斯西伯利亞", "埃及西奈半島", "阿布哈茲", "南奧塞梯", "阿爾扎赫", "北賽普勒斯"]
    var AustraliaCountry = [ "澳大利亞", "紐西蘭", "巴布亞紐幾內亞", "諾魯", "帛琉", "馬紹爾群島", "密克羅尼西亞聯", "吉里巴斯", "萬那杜", "薩摩亞", "庫克群島", "紐埃", "東加", "斐濟", "吐瓦魯", "索羅門群島", "東帝汶" ]
    
    var Countrypicker = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 已選擇的洲回傳array裡國家的數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ( IsNorthA ) { return NorthACountry.count }
        else if ( IsSouthA ) { return SouthACountry.count }
        else if ( IsEurope ) { return EuropeCountry.count }
        else if ( IsAfrica ) { return AfricaCountry.count }
        else if ( IsAsia ) { return AsiaCountry.count }
        else if ( IsAustralia ) { return AustraliaCountry.count }
        
        return 1
    }
    
    // 回傳選擇的洲的國家
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ( IsNorthA ) { return NorthACountry[row] }
        else if ( IsSouthA ) { return SouthACountry[row] }
        else if ( IsEurope ) { return EuropeCountry[row] }
        else if ( IsAfrica ) { return AfricaCountry[row] }
        else if ( IsAsia ) { return AsiaCountry[row] }
        else if ( IsAustralia ) {return AustraliaCountry[row] }
        return ""
    }
    
    // 將選擇的國家丟回textfield
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ( IsNorthA ) { self.CountryName.text = self.NorthACountry[row] }
        else if ( IsSouthA ) { self.CountryName.text = self.SouthACountry[row] }
        else if ( IsEurope ) { self.CountryName.text = self.EuropeCountry[row] }
        else if ( IsAfrica ) { self.CountryName.text = self.AfricaCountry[row] }
        else if ( IsAsia ) { self.CountryName.text = self.AsiaCountry[row] }
        else if ( IsAustralia ) { self.CountryName.text = self.AustraliaCountry[row] }
        SelectCountry = self.CountryName.text!
        // print(SelectCountry)
        self.view.endEditing(false)
    }

    var place = ""
    @IBOutlet weak var WhereYouGO: UITextField!
    @IBOutlet weak var OneLike: UIButton!
    @IBOutlet weak var TwoLike: UIButton!
    @IBOutlet weak var ThreeLike: UIButton!
    @IBOutlet weak var FourLike: UIButton!
    @IBOutlet weak var FiveLike: UIButton!
    
    var like = 1
    
    // 喜好顏色初始
    func likeChoose() -> Void {
        OneLike.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        TwoLike.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        ThreeLike.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        FourLike.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        FiveLike.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    }
    
    // 按各個喜好將愛心背景顏色變紅色 並暫存喜好
    // ex. 5顆心 五顆心皆顯示紅色
    // ex. 3顆心 左邊三顆心顯示紅色
    @IBAction func oneButton(_ sender: UIButton) {
        likeChoose()
        OneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        like = 1
    }
    
    @IBAction func twoButton(_ sender: UIButton) {
        likeChoose()
        OneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        TwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        like = 2
    }
    
    @IBAction func threeLike(_ sender: UIButton) {
        likeChoose()
        OneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        TwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        ThreeLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        like = 3
    }
    
    @IBAction func fourLike(_ sender: UIButton) {
        likeChoose()
        OneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        TwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        ThreeLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        FourLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        like = 4
    }
    
    @IBAction func fiveButton(_ sender: UIButton) {
        likeChoose()
        OneLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        TwoLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        ThreeLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        FourLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        FiveLike.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        like = 5
    }
    
    // 選擇相簿的照片 先將照片轉為路徑 再轉成字串暫存
    @IBOutlet weak var Text: UITextView!
    @IBOutlet weak var FirstPhoto: UIImageView!
    @IBAction func FromLibrary(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending("/"+imgName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoURL)
            self.photoURL = photoURL.absoluteString
            
        }
        
        
        self.dismiss(animated: true, completion: nil)
        print(self.photoURL)
        let imageUrlString = self.photoURL
        let imageUrl:URL = URL(string: imageUrlString)!

        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {

            let imageData:NSData = NSData(contentsOf: imageUrl)!

            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                self.FirstPhoto.image = image
                self.FirstPhoto.contentMode = UIViewContentMode.scaleAspectFit
                self.view.addSubview(self.FirstPhoto)
            }
        }
    }

    
    // 按下儲存
    var count = 0
    @IBAction func DoneButton(_ sender: UIButton) {
        
        // 沒有輸入地點 跳出提醒
        place = WhereYouGO.text!
        if (  place == "" ) {
            let alert = UIAlertController(title: "提醒", message: "地點不可以空白唷", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(state == ""){ // 沒有選擇洲 跳出提醒
            let alert = UIAlertController(title: "提醒", message: "沒有選擇洲唷", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{ // 沒有選擇國家 跳出提醒並預設
            if (  SelectCountry == "" ) {
                if ( state == "SouthAmerica" ) {
                    let alert = UIAlertController(title: "提醒", message: "哪個國家？\n不選擇預設國家是巴西唷", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    SelectCountry = "巴西"
                }
                else if ( state == "NorthAmerica" ) {
                    let alert = UIAlertController(title: "提醒", message: "哪個國家？\n不選擇預設國家是美國唷", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    SelectCountry = "美國"
                }
                else if ( state == "Europe" ) {
                    let alert = UIAlertController(title: "提醒", message: "哪個國家？\n不選擇預設國家是英國唷", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    SelectCountry = "美國"
                }
                else if ( state == "Africa" ) {
                    let alert = UIAlertController(title: "提醒", message: "哪個國家？\n不選擇預設國家是阿爾及利亞唷", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    SelectCountry = "阿爾及利亞"
                }
                else if ( state == "Asia" ) {
                    let alert = UIAlertController(title: "提醒", message: "哪個國家？\n不選擇預設國家是中國唷", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    SelectCountry = "中國"
                }
                else if ( state == "Australia" ) { SelectCountry = "澳洲" }
                else {
                    let alert = UIAlertController(title: "提醒", message: "是在哪個洲？哪個國家？\n不選擇預設為Asia, 台灣", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    state = "Asia"
                    SelectCountry = "台灣"
                } // esle
            }
            // 存入database
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd hh mm ss"
            print(self.date)
            print(self.state)
            print(self.SelectCountry)
            print(self.place)
            print(self.like)
            print(self.Text.text)
            print(self.photoURL)
            print(dateFormatter.string(from: Date()))
            
            let insertDate = self.table_inTeamView.insert(self.date_db <- self.date, self.state_db <- self.state, self.country_db <- self.SelectCountry, self.place_db <- self.place, self.like_db <- self.like, self.data_db <- self.Text.text, self.photo_db <- self.photoURL, self.second_db <- dateFormatter.string(from: Date()))
            
            do{
                try self.database?.run(insertDate)
                print("insert user")
            }
            catch {
                print("error")
            }
            
            // 返回上一頁
            navigationController?.popViewController(animated: true)
        }
    }
    
}
