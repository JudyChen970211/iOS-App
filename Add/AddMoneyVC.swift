//  AddMoneyVC.swift
//  FinalProject

import UIKit
import SQLite
class AddMoneyVC: UIViewController {
    var date: String = ""
    var second: String = ""
    @IBOutlet weak var Food: UIButton!
    @IBOutlet weak var Clothing: UIButton!
    @IBOutlet weak var Housing: UIButton!
    @IBOutlet weak var Transpotation: UIButton!
    @IBOutlet weak var Education: UIButton!
    @IBOutlet weak var Fun: UIButton!
    @IBOutlet weak var DailyNecessities: UIButton!
    @IBOutlet weak var Medical: UIButton!
    @IBOutlet weak var Treatment: UIButton!
    @IBOutlet weak var InvestOut: UIButton!
    @IBOutlet weak var OtherOut: UIButton!
    
    @IBOutlet weak var Salary: UIButton!
    @IBOutlet weak var InvestIn: UIButton!
    @IBOutlet weak var Bonus: UIButton!
    @IBOutlet weak var OtherIn: UIButton!
    
    @IBOutlet weak var Detail: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var Div: UIButton!
    @IBOutlet weak var Mul: UIButton!
    @IBOutlet weak var Sub: UIButton!
    @IBOutlet weak var Sum: UIButton!
    var classification = ""
    var state = ""
    
    // 宣告database table
    var table_inTeamView:Table = Table( "Money" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let classfication_db = Expression<String>( "classfication" )
    let money_db = Expression<String>( "money" )
    let state_db = Expression<String>( "state" )
    let detail_db = Expression<String>( "detail" )
    let second_db = Expression<String>( "second" )
 
    @IBOutlet weak var save: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGestur()
        if(second == ""){dateLabel.text = date}
        classificationChoose()
        // Do any additional setup after loading the view.
        do {
            // 連結database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            self.database = try Connection( fileUrl.path )
        }
        catch{
            print( "error when connect to the database in viewdid" )
        }
        let tableName_uerToCreate = "Money"
        
        // 創建table
        self.table_inTeamView = Table( tableName_uerToCreate )
        
        
        let createTable = table_inTeamView.create { (table_useToCreate) in
            table_useToCreate.column(self.date_db)
            table_useToCreate.column(self.classfication_db)
            table_useToCreate.column(self.money_db)
            table_useToCreate.column(self.state_db)
            table_useToCreate.column(self.detail_db)
            table_useToCreate.column(self.second_db)
        }
 
        do {
            try self.database?.run( createTable )
            print( "Create table success " + tableName_uerToCreate )
        } catch {
            print( "error when run in create Table" )
        } // catch
        
        init_money(endDate: second)
    }
    
    // 若是編輯模式 將頁面資料顯示編輯前資料
    func init_money(endDate:String) -> Void {
        do {
            let money_table = try self.database.prepare(self.table_inTeamView)
            for moneys_tables in money_table {
                if(moneys_tables[self.second_db] == endDate) {
                    dateLabel.text = moneys_tables[self.date_db]
                    date = moneys_tables[self.date_db]
                    Detail.text = moneys_tables[self.detail_db]
                    moneyresult.text = moneys_tables[self.money_db]
                    if(moneys_tables[self.classfication_db] == "伙食"){
                        Food.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Food.setTitleColor(UIColor.white, for: .normal)
                        classification = "伙食"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "治裝"){
                        Clothing.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Clothing.setTitleColor(UIColor.white, for: .normal)
                        classification = "治裝"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "房租"){
                        Housing.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Housing.setTitleColor(UIColor.white, for: .normal)
                        classification = "房租"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "交通"){
                        Transpotation.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Transpotation.setTitleColor(UIColor.white, for: .normal)
                        classification = "交通"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "教育"){
                        Education.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Education.setTitleColor(UIColor.white, for: .normal)
                        classification = "教育"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "娛樂"){
                        Fun.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Fun.setTitleColor(UIColor.white, for: .normal)
                        classification = "娛樂"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "日用"){
                        DailyNecessities.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        DailyNecessities.setTitleColor(UIColor.white, for: .normal)
                        classification = "日用"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "醫療"){
                        Medical.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Medical.setTitleColor(UIColor.white, for: .normal)
                        classification = "醫療"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "美妝"){
                        Treatment.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Treatment.setTitleColor(UIColor.white, for: .normal)
                        classification = "美妝"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "投資" && moneys_tables[self.state_db] == "cost"){
                        InvestOut.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        InvestOut.setTitleColor(UIColor.white, for: .normal)
                        classification = "投資"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "其他" && moneys_tables[self.state_db] == "cost"){
                        OtherOut.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        OtherOut.setTitleColor(UIColor.white, for: .normal)
                        classification = "其他"
                        state = "cost"
                    }
                    else if(moneys_tables[self.classfication_db] == "其他" && moneys_tables[self.state_db] == "income"){
                        OtherIn.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        OtherIn.setTitleColor(UIColor.white, for: .normal)
                        classification = "其他"
                        state = "income"
                    }
                    else if(moneys_tables[self.classfication_db] == "投資" && moneys_tables[self.state_db] == "income"){
                        InvestIn.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        InvestIn.setTitleColor(UIColor.white, for: .normal)
                        classification = "投資"
                        state = "income"
                    }
                    else if(moneys_tables[self.classfication_db] == "薪水"){
                        Salary.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Salary.setTitleColor(UIColor.white, for: .normal)
                        classification = "薪水"
                        state = "income"
                    }
                    else if(moneys_tables[self.classfication_db] == "獎金"){
                        Bonus.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
                        Bonus.setTitleColor(UIColor.white, for: .normal)
                        classification = "獎金"
                        state = "income"
                    }
                }
            } // for
            
        } // do
        catch {
            print("error to connect")
        } // catch
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 種類底色及字的顏色初始化
    func classificationChoose() -> Void{
        Food.setTitleColor(UIColor.black, for: .normal)
        Clothing.setTitleColor(UIColor.black, for: .normal)
        Housing.setTitleColor(UIColor.black, for: .normal)
        Transpotation.setTitleColor(UIColor.black, for: .normal)
        Education.setTitleColor(UIColor.black, for: .normal)
        Fun.setTitleColor(UIColor.black, for: .normal)
        DailyNecessities.setTitleColor(UIColor.black, for: .normal)
        Medical.setTitleColor(UIColor.black, for: .normal)
        Treatment.setTitleColor(UIColor.black, for: .normal)
        InvestOut.setTitleColor(UIColor.black, for: .normal)
        OtherOut.setTitleColor(UIColor.black, for: .normal)
        
        Salary.setTitleColor(UIColor.black, for: .normal)
        InvestIn.setTitleColor(UIColor.black, for: .normal)
        Bonus.setTitleColor(UIColor.black, for: .normal)
        OtherIn.setTitleColor(UIColor.black, for: .normal)
        
        Food.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Clothing.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Housing.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Transpotation.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Education.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Fun.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        DailyNecessities.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Medical.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Treatment.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        InvestOut.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        OtherOut.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        Salary.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        InvestIn.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        Bonus.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        OtherIn.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    }
    
    // 選擇類別 類別底色變化 並暫存是收入或支出和類別
    @IBAction func FoodButton(_ sender: UIButton) {
        classificationChoose()
        Food.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Food.setTitleColor(UIColor.white, for: .normal)
        classification = "伙食"
        state = "cost"
    }
    
    @IBAction func ClothingButton(_ sender: UIButton) {
        classificationChoose()
        Clothing.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Clothing.setTitleColor(UIColor.white, for: .normal)
        classification = "治裝"
        state = "cost"
    }
    
    @IBAction func HousingButton(_ sender: UIButton) {
        classificationChoose()
        Housing.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Housing.setTitleColor(UIColor.white, for: .normal)
        classification = "房租"
        state = "cost"
    }
    
    @IBAction func TransportationButton(_ sender: UIButton) {
        classificationChoose()
        Transpotation.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Transpotation.setTitleColor(UIColor.white, for: .normal)
        classification = "交通"
        state = "cost"
    }
    
    @IBAction func EducationButton(_ sender: UIButton) {
        classificationChoose()
        Education.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Education.setTitleColor(UIColor.white, for: .normal)
        classification = "教育"
        state = "cost"
    }
    
    @IBAction func FunButton(_ sender: UIButton) {
        classificationChoose()
        Fun.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Fun.setTitleColor(UIColor.white, for: .normal)
        classification = "娛樂"
        state = "cost"
    }
    
    @IBAction func DailyNecessitiesButton(_ sender: UIButton) {
        classificationChoose()
        DailyNecessities.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        DailyNecessities.setTitleColor(UIColor.white, for: .normal)
        classification = "日用"
        state = "cost"
    }
    
    @IBAction func MedicalButton(_ sender: UIButton) {
        classificationChoose()
        Medical.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Medical.setTitleColor(UIColor.white, for: .normal)
        classification = "醫療"
        state = "cost"
    }
    
    @IBAction func TreatmentButton(_ sender: UIButton) {
        classificationChoose()
        Treatment.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Treatment.setTitleColor(UIColor.white, for: .normal)
        classification = "美妝"
        state = "cost"
    }
    
    @IBAction func InvestOutButton(_ sender: UIButton) {
        classificationChoose()
        InvestOut.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        InvestOut.setTitleColor(UIColor.white, for: .normal)
        classification = "投資"
        state = "cost"
    }
    
    @IBAction func OtherOutButton(_ sender: UIButton) {
        classificationChoose()
        OtherOut.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        OtherOut.setTitleColor(UIColor.white, for: .normal)
        classification = "其他"
        state = "cost"
    }
    
    
    @IBAction func SalaryButton(_ sender: UIButton) {
        classificationChoose()
        Salary.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Salary.setTitleColor(UIColor.white, for: .normal)
        classification = "薪水"
        state = "income"
    }
    
    @IBAction func InvestInButton(_ sender: UIButton) {
        classificationChoose()
        InvestIn.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        InvestIn.setTitleColor(UIColor.white, for: .normal)
        classification = "投資"
        state = "income"
    }
    
    @IBAction func BonusButton(_ sender: UIButton) {
        classificationChoose()
        Bonus.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        Bonus.setTitleColor(UIColor.white, for: .normal)
        classification = "獎金"
        state = "income"
    }
    
    @IBAction func OtherInButton(_ sender: UIButton) {
        classificationChoose()
        OtherIn.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        OtherIn.setTitleColor(UIColor.white, for: .normal)
        classification = "其他"
        state = "income"
    }
    
    // 顯示小數點以下兩位數
    func change(string: String) -> Void {
        var temp = 0.0
        temp = Double( money )!
        moneyresult.text = String( format: "%.2f",temp )
    }
    
    // 每加一個數字就加在字串後面
    func add(string: String, num: String) -> Void {
        if( money != "0" ){ money += num }
        else{ money = num }
        change( string: string )
    }
    
    
    @IBOutlet weak var moneyresult: UILabel!
    var money = "0"
    var num1 = 0.0
    var num2 = -1.0
    var temp = 0.0
    var Operator = ""
    // 若按數字呼叫add 將數字加到字串後
    @IBAction func zeroButton(_ sender: UIButton) { add( string: money, num: "0" ) }
    @IBAction func oneButton(_ sender: UIButton) { add( string: money, num: "1" ) }
    @IBAction func twoButton(_ sender: UIButton) { add( string: money, num: "2" ) }
    @IBAction func threeButton(_ sender: UIButton) { add( string: money, num: "3" ) }
    @IBAction func fourButton(_ sender: UIButton) { add( string: money, num: "4" ) }
    @IBAction func fiveButton(_ sender: UIButton) { add( string: money, num: "5" ) }
    @IBAction func sixButton(_ sender: UIButton) { add( string: money, num: "6" ) }
    @IBAction func sevenButton(_ sender: UIButton) { add( string: money, num: "7" ) }
    @IBAction func eightButton(_ sender: UIButton) { add( string: money, num: "8" ) }
    @IBAction func nineButton(_ sender: UIButton) { add( string: money, num: "9" ) }
    
    // 可以按小數點
    @IBAction func dotButton(_ sender: UIButton) {
        if( !checkIfDot(string: money) ){
            if( money == "0" ){ money = "0." }
            else{ money += "." }
        }
        else {
            // 已有小數點 重複按所以跳出提醒
            let alert = UIAlertController(title: "運算式錯誤", message: "已有小數點", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        change( string: money )
    }
    
    // 計算
    func calculate(op: String) -> Void {
        Sub.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Sum.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Div.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Mul.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        if ( Operator == "" ) { num1 = Double(money)! }
        else {
            num2 = Double(money)!
            // 加減乘除
            if ( Operator == "+" ) { num1 += num2 }
            else if ( Operator == "-" ) { num1 -= num2 }
            else if ( Operator == "*" ) { num1 = num1 * num2 }
            else if ( Operator == "/" ) {
                if( num2 == 0.0 ){
                    // 數字除以0 跳出提醒
                    let alert = UIAlertController(title: "運算式錯誤", message: "不能除以０", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else { num1 = num1 / num2 }
            }
            num2 = -1.0
        }
        Operator = op
        if(op != ""){ money = "0" }
        else{
            if((num1 - Double(String(format: "%.0f", num1))!) != 0 ) { money = String(format: "%.2f", num1) }
            else { money = String(format: "%.0f", num1) }
        }
        
        if( num1 < 0 ){ // 計算後金額小於0 跳出提醒 並將金額歸零
            let alert = UIAlertController(title: "運算式錯誤", message: "金額小於0", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            num1 = 0.0
            money = "0"
        }
        moneyresult.text = String(format: "%.2f", num1)
    }
    
    // 按加減乘除的時候 底色變白色 並呼叫calculate計算
    // 按等於 直接顯示金額
    @IBAction func equalButton(_ sender: UIButton) { calculate(op: "") }
    @IBAction func plusButton(_ sender: UIButton) {
        calculate( op: "+" )
        Sum.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @IBAction func minusButton(_ sender: UIButton) {
        calculate( op: "-" )
        Sub.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @IBAction func multButton(_ sender: UIButton) {
        calculate( op: "*" )
        Mul.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @IBAction func divButton(_ sender: UIButton) {
        calculate( op: "/" )
        Div.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    // 檢查是否有小數點
    // 若計算後多了小數點 也會判斷
    func checkIfDot(string:String) -> Bool {
        for character in string {
            if( character == ".") {return true}
        }
        return false
    }
    
    // 擦掉
    // 若擦到最後 將金額變成0
    @IBAction func backButton(_ sender: UIButton) {
        if ( money.count == 1 ) {
            moneyresult.text = "0.00"
            money = "0"
        }
        else {
            money.remove(at: money.index(before: money.endIndex))
            temp = Double(money)!
            moneyresult.text = String(format: "%.2f",temp)
        }
    }
    
    // textfield 打字時按空白處結束打字
    private func configureTapGestur() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector( AddMoneyVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    // 儲存
    @IBAction func SvaeMessage(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd HH mm ss"
        calculate(op: "")
        // 未選擇類別 跳出提醒
        if ( classification == "" ) {
            let alert = UIAlertController(title: "提醒", message: "請選擇類別", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } // if
        else {
            // update
            self.table_inTeamView = Table( "Money" )
            print(self.date)
            if(second != ""){
                print(self.date)
                let update_diary_day = self.table_inTeamView.filter(self.second_db == second)
                let update_diary = update_diary_day.update(self.date_db <- self.date, self.classfication_db <- self.classification, self.money_db <- self.moneyresult.text!, self.state_db <- self.state, self.detail_db <- self.Detail.text!, self.second_db <- dateFormatter.string(from: Date()))
                
                do{
                    try self.database?.run(update_diary)
                    print("update user")
                    navigationController?.popViewController(animated: true)
                }
                catch {
                    print("error update user")
                }
            }
            else {
                // insert
                let insertDate = self.table_inTeamView.insert(self.date_db <- self.date, self.classfication_db <- self.classification, self.money_db <- self.moneyresult.text!, self.state_db <- self.state, self.detail_db <- self.Detail.text!, self.second_db <- dateFormatter.string(from: Date()))
                
                do{
                    try self.database?.run(insertDate)
                    print("insert user")
                }
                catch {
                    print("error")
                }
            }
            
            
        } // else
        
        classification = ""
        Detail.text = ""
        classificationChoose()
        moneyresult.text = "0.00"
        money = "0"
        num1 = 0.0
    }
    
}
