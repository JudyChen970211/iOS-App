//  AddDiaryVC.swift
//  FinalProject

import UIKit
import SQLite
class AddDiaryVC: UIViewController {
    var date: String = ""
    @IBOutlet weak var sunny: UIButton!
    @IBOutlet weak var cloud: UIButton!
    @IBOutlet weak var rainy: UIButton!
    @IBOutlet weak var rain_in_sun: UIButton!
    @IBOutlet weak var snow: UIButton!
    @IBOutlet weak var storm: UIButton!
    @IBOutlet weak var wind: UIButton!
    @IBOutlet weak var excelent: UIButton!
    @IBOutlet weak var happy: UIButton!
    @IBOutlet weak var laugh_tears: UIButton!
    @IBOutlet weak var shy: UIButton!
    @IBOutlet weak var embarrassed: UIButton!
    @IBOutlet weak var love: UIButton!
    @IBOutlet weak var regular: UIButton!
    @IBOutlet weak var angry: UIButton!
    @IBOutlet weak var sick: UIButton!
    @IBOutlet weak var sad: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 預設天氣、心情
    var wheather = "sunny"
    var mood = "excelent"
    
    // 宣告database table
    var table_inTeamView:Table = Table( "Diary" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let wheather_db = Expression<String>( "wheather" )
    let mood_db = Expression<String>( "mood" )
    let data_db = Expression<String>( "data" )
    

    override func viewDidLoad() {
        dateLabel.text = date
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTapGestur()

        do {
            // 連結database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            let database = try Connection( fileUrl.path )
            
            self.database = database
        }catch{
            print( "error when connect to the database in viewdid" )
        }
        init_diary(endDate: date)
        
    }
    
    func init_diary(endDate:String) -> Void {
        diaryTextField.text = ""
        weatherChoose()
        moodChoose()
        sunny.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        excelent.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        do {
            let diary_table = try self.database.prepare(self.table_inTeamView)
            for diary_tables in diary_table {
                if(diary_tables[self.date_db] == endDate) {
                    print( diary_tables[self.data_db])
                    diaryTextField.text = diary_tables[self.data_db]
                    weatherChoose()
                    moodChoose()
                    self.mood = diary_tables[self.mood_db]
                    self.wheather = diary_tables[self.wheather_db]
                    if(diary_tables[self.mood_db] == "happy"){happy.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "laugh_tears"){laugh_tears.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "shy"){shy.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "embarrassed"){embarrassed.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "love"){love.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "regular"){regular.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "angry"){angry.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "sick"){sick.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.mood_db] == "sad"){sad.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else {excelent.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    
                    if(diary_tables[self.wheather_db] == "cloud"){cloud.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.wheather_db] == "rainy"){rainy.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.wheather_db] == "rain_in_sun"){rain_in_sun.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.wheather_db] == "snow"){snow.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.wheather_db] == "storm"){storm.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else if(diary_tables[self.wheather_db] == "wind"){wind.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    else {sunny.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)}
                    
                }
            } // for
            
        } // do
        catch {
            print("error to connect")
        } // catch
        
    }
    
    // textfield 打字時按空白處結束打字
    private func configureTapGestur() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector( AddDiaryVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func weatherChoose() -> Void{
        sunny.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cloud.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        rainy.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        rain_in_sun.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        snow.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        storm.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        wind.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    }
    
    @IBAction func sunnyButton(_ sender: UIButton) {
        weatherChoose()
        sunny.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        wheather = "sunny"
    }
    
    @IBAction func cloudButton(_ sender: UIButton) {
        weatherChoose()
        cloud.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        wheather = "cloud"
    }
    
    @IBAction func rainyButton(_ sender: UIButton) {
        weatherChoose()
        rainy.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        wheather = "rainy"
    }
    
    @IBAction func rain_in_sunButton(_ sender: UIButton) {
        weatherChoose()
        rain_in_sun.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        wheather = "rain_in_sun"
    }
    
    @IBAction func snowButton(_ sender: UIButton) {
        weatherChoose()
        snow.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        wheather = "snow"
    }
    
    @IBAction func stormButton(_ sender: UIButton) {
        weatherChoose()
        storm.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        wheather = "storm"
    }
    
    @IBAction func windButton(_ sender: UIButton) {
        weatherChoose()
        wind.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        wheather = "wind"
    }
    
    func moodChoose() -> Void{
        excelent.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        happy.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        laugh_tears.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        shy.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        embarrassed.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        love.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        regular.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        angry.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        sick.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        sad.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    }
    
    @IBAction func excelentButton(_ sender: UIButton) {
        moodChoose()
        excelent.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "excelent"
    }
    
    @IBAction func happyButton(_ sender: UIButton) {
        moodChoose()
        happy.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "happy"
    }
    
    @IBAction func laugh_tearsButton(_ sender: UIButton) {
        moodChoose()
        laugh_tears.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "laugh_tears"
    }
    
    @IBAction func shyButton(_ sender: UIButton) {
        moodChoose()
        shy.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "shy"
    }
    
    @IBAction func embarrassedButton(_ sender: UIButton) {
        moodChoose()
        embarrassed.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "embarrassed"
    }
    
    @IBAction func loveButton(_ sender: UIButton) {
        moodChoose()
        love.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "love"
    }
    
    @IBAction func regularButton(_ sender: UIButton) {
        moodChoose()
        regular.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "regular"
    }
    
    @IBAction func angryButton(_ sender: UIButton) {
        moodChoose()
        angry.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "angry"
    }
    
    @IBAction func sickButton(_ sender: UIButton) {
        moodChoose()
        sick.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "sick"
    }
    
    @IBAction func sadButton(_ sender: UIButton) {
        moodChoose()
        sad.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        mood = "sad"
    }
    
    @IBOutlet weak var diaryTextField: UITextView!
    
    
    @IBAction func DoneButton(_ sender: UIButton) {

        let tableName_uerToCreate = "Diary"
        // 創立table
        self.table_inTeamView = Table( tableName_uerToCreate )

        let createTable = table_inTeamView.create { (table_useToCreate) in
            table_useToCreate.column(self.date_db, primaryKey: true)
            table_useToCreate.column(self.wheather_db)
            table_useToCreate.column(self.mood_db)
            table_useToCreate.column(self.data_db)
        }
        
        // 執行->創立
        do {
            try self.database?.run(createTable)
            print( "Create table success " + tableName_uerToCreate )
        } catch {
            print( "error when run in create Table" )
        } // catch
        
        print(date)
            // svae into DB
            // date: date, type:string
            // wheather: wheather, type:string
            // mood: mood, type:string
            // data: diaryTextField.text, type:string
        var exsist = false
        do {
            let diary_table = try self.database.prepare(self.table_inTeamView)
            for diary_tables in diary_table {
                if(diary_tables[self.date_db] == date) {
                    exsist = true
                }
            } // for
            
        } // do
        catch {
            print("error to connect")
        } // catch
        
        if(exsist){
            let update_diary_day = self.table_inTeamView.filter(self.date_db == date)
            let update_diary = update_diary_day.update(self.date_db <- self.date, self.wheather_db <- self.wheather, self.mood_db <- self.mood, self.data_db <- self.diaryTextField.text! )
            
            do{
                try self.database?.run(update_diary)
                print("update user")
            }
            catch {
                print("error update user")
            }
        }
        else {
            let insertDate = self.table_inTeamView.insert(self.date_db <- self.date, self.wheather_db <- self.wheather, self.mood_db <- self.mood, self.data_db <- self.diaryTextField.text! )
            do{
                try self.database?.run(insertDate)
                print("insert user")
            }
            catch {
                print("error insert user")
            }
        }
        navigationController?.popViewController(animated: true)
        
        
    }
}
