//  AddCelebrationVC.swift
//  FinalProject

import UIKit
import SQLite

class AddCelebrationVC: UIViewController {
    var date: String = ""
    
    // 宣告database table
    var table_inTeamView:Table = Table( "Celebration" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let classification_db = Expression<String>( "classification" )
    let event_db = Expression<String>( "event" )
    let repeat_db = Expression<Bool>( "repeat" )
    let frequency_db = Expression<String>( "frequency" )
    let important_db = Expression<Bool>( "important" )

    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        configureTapGestur()
        dateLabel.text = date
        super.viewDidLoad()
        weekly.isHidden = false
        month.isHidden = false
        year.isHidden = false
        lifeLabel.isHidden = true
        celebrationLabel.isHidden = true
        remindLabel.isHidden = true
        workLabel.isHidden = true
        anniversaryLabel.isHidden = true
        birthdayLabel.isHidden = true
        
        do {
            // 連結database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            self.database = try Connection( fileUrl.path )
        }
        catch{
            print( "error when connect to the database in viewdid" )
        }
    }
    
    // textfield 打字時按空白處結束打字
    private func configureTapGestur() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector( AddCelebrationVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var life: UIButton!
    @IBOutlet weak var celebration: UIButton!
    @IBOutlet weak var reminding: UIButton!
    @IBOutlet weak var work: UIButton!
    @IBOutlet weak var anniversary: UIButton!
    @IBOutlet weak var birthday: UIButton!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var celebrationLabel: UILabel!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var anniversaryLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    var classification = ""
    
    // 全部類別旁邊label隱藏
    func classificationChoose() -> Void {
        lifeLabel.isHidden = true
        celebrationLabel.isHidden = true
        remindLabel.isHidden = true
        workLabel.isHidden = true
        anniversaryLabel.isHidden = true
        birthdayLabel.isHidden = true
    }
    
    // 按各個類別將類別旁邊的label顯示並將類別暫存
    @IBAction func lifeButton(_ sender: UIButton) {
        classificationChoose()
        lifeLabel.isHidden = false
        classification = "life"
    }
    
    @IBAction func celebrationButton(_ sender: UIButton) {
        classificationChoose()
        celebrationLabel.isHidden = false
        classification = "celebration"
    }
    
    @IBAction func remindButton(_ sender: UIButton) {
        classificationChoose()
        remindLabel.isHidden = false
        classification = "remind"
    }
    
    @IBAction func workButton(_ sender: UIButton) {
        classificationChoose()
        workLabel.isHidden = false
        classification = "work"
    }
    
    @IBAction func anniversaryButton(_ sender: UIButton) {
        classificationChoose()
        anniversaryLabel.isHidden = false
        classification = "anniversary"
    }
    
    @IBAction func birthdayButton(_ sender: UIButton) {
        classificationChoose()
        birthdayLabel.isHidden = false
        classification = "work"
    }
    
    @IBOutlet weak var eventTextField: UITextField!
    var WantRepeat = true
    var important = false
    
    // 開啟或關閉重要
    @IBAction func switchIfImportant(_ sender: UISwitch) {
        if(sender.isOn == true){important = true}
        else{important = false}
    }
    
    //開啟或關閉重複
    @IBAction func switchIfRepeat(_ sender: UISwitch) {
        if ( sender.isOn == true )
        {
            WantRepeat = true
            weekly.isHidden = false
            month.isHidden = false
            year.isHidden = false
        }
        else
        {
            WantRepeat = false
            weekly.isHidden = true
            month.isHidden = true
            year.isHidden = true
            howoftenChoose()
        }
    }
    @IBOutlet weak var weekly: UIButton!
    @IBOutlet weak var month: UIButton!
    @IBOutlet weak var year: UIButton!
    var howoffen = ""
    var day = ""
    
    // 將重複的三個button顏色變回預設
    func howoftenChoose() -> Void {
        weekly.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        month.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        year.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    // 按重複的頻率 頻率顏色變成灰色 並將頻率暫存
    @IBAction func repeatWeeklyButton(_ sender: UIButton) {
        howoffen = "weekly"
        howoftenChoose()
        weekly.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    }
    
    @IBAction func repeatMonthButton(_ sender: UIButton) {
        howoffen = "month"
        howoftenChoose()
        month.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    }
    
    @IBAction func repeatYearButton(_ sender: UIButton) {
        howoffen = "year"
        howoftenChoose()
        year.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    }
    
    // 按下儲存
    @IBAction func saveButton(_ sender: UIButton) {
        // 若沒選擇項目 跳出提醒
        if ( classification == "" ) {
            let alert = UIAlertController(title: "Alert", message: "請選擇類別", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } // else if
        // 若沒輸入事件 跳出提醒
        else if ( eventTextField.text == "" ) {
            let alert = UIAlertController(title: "Alert", message: "請輸入事件", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } // else if
        // 若沒選擇頻率 跳出提醒
        else if ( WantRepeat && howoffen == "" ) {
            let alert = UIAlertController(title: "Alert", message: "請選擇頻率", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } // else if
        else  {
            print(date)
            let tableName_uerToCreate = "Celebration"
            // 創建table
            table_inTeamView = Table( tableName_uerToCreate )
            
            let createTable = table_inTeamView.create { (table_useToCreate) in
                table_useToCreate.column(self.date_db)
                table_useToCreate.column(self.classification_db)
                table_useToCreate.column(self.event_db)
                table_useToCreate.column(self.repeat_db)
                table_useToCreate.column(self.frequency_db)
                table_useToCreate.column(self.important_db)
            }
            
            do {
                try self.database?.run( createTable )
                print( "Create table success " + tableName_uerToCreate )
            } catch {
                print( "error when run in create Table" )
            }
            
            // 將資料存進database
            let insertDate = self.table_inTeamView.insert(self.date_db <- self.date, self.classification_db <- self.classification, self.event_db <- self.eventTextField.text!, self.repeat_db <- self.WantRepeat, self.frequency_db <- self.howoffen, self.important_db <- self.important)
            
            do{
                try self.database?.run(insertDate)
                print("insert user")
            }
            catch {
                print("error")
            }
            
            // 跳回上一頁
            navigationController?.popViewController(animated: true)
        }
    }
    
}
