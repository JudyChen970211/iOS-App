//  CelebrationVC.swift
//  FinalProject

import UIKit
import SQLite
class CelebrationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Count: UITextField!
    @IBOutlet weak var Celebration: UITableView!
    var table_inTeamView:Table = Table( "Celebration" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let classification_db = Expression<String>( "classification" )
    let event_db = Expression<String>( "event" )
    let repeat_db = Expression<Bool>( "repeat" )
    let frequency_db = Expression<String>( "frequency" )
    let important_db = Expression<Bool>( "important" )
    
    struct celebration {
        var date: String = ""
        var classification = ""
        var event = ""
        var count = 0
        var important = false
    }
    
    var celebrations = [celebration]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGestur()
        Celebration.delegate = self
        Celebration.dataSource = self
        do {
            // 此處建立連線，若無已存在之database則建立
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            let database = try Connection( fileUrl.path )
            
            self.database = database
        }catch{
            print( "error when connect to the database in viewdid" )
        }
        
        var currentdate = Date()
        let count = Int(Count.text ?? "60")
        for i in 0...count!{
            findCelebration(date: currentdate, count: i)
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: currentdate)!
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let date = dateFormatter.date(from: celebrations[indexPath.row].date)
        dateFormatter.dateFormat = "MM/dd"
        let cell: CelebrationTableViewCell = Celebration.dequeueReusableCell(withIdentifier: "CelebrationCell", for: indexPath) as! CelebrationTableViewCell
        cell.DateLabel?.text = dateFormatter.string(from: date!)
        cell.EventLabel?.text = celebrations[indexPath.row].event
        if(celebrations[indexPath.row].count == 0){cell.CountLabel?.text = "Today"}
        else {cell.CountLabel?.text = String(celebrations[indexPath.row].count) + "天"}
        if(celebrations[indexPath.row].important == true){
            cell.DateLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
            cell.EventLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
            cell.CountLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
        }
        else{
            cell.DateLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
            cell.EventLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
            cell.CountLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let deleteDiary  = self.table_inTeamView.filter(self.date_db == celebrations[indexPath.row].date && self.classification_db == celebrations[indexPath.row].classification && self.event_db == celebrations[indexPath.row].event)
            let deleteDiarys = deleteDiary.delete()
            
            do {
                try self.database?.run( deleteDiarys )
            }
            catch {
                print( "error happen when delet Table" )
            }
            celebrations.remove(at: indexPath.row)
            
            Celebration.beginUpdates()
            Celebration.deleteRows(at: [indexPath], with: .fade)
            Celebration.endUpdates()
            
        }
    }
    
    
    func findCelebration(date: Date, count: Int) -> Void {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        var historyDate: Date
        var nowDate: String
        var celebrationExsist: Bool = false
        do {
            let celebration_table = try self.database.prepare(self.table_inTeamView)
            
            for celebration_tables in celebration_table {
                dateFormatter.dateFormat = "yyyy MM dd"
                historyDate = dateFormatter.date(from: celebration_tables[self.date_db])!
                nowDate = dateFormatter.string(from: date)
                let components = calendar.dateComponents([.day], from: historyDate, to: date)
                let day = components.day
                print(day!)
                print(celebration_tables[self.date_db])
                print(nowDate)
                if(celebration_tables[self.date_db] < nowDate){
                    if(celebration_tables[self.repeat_db] == true){
                        if(celebration_tables[self.frequency_db] == "weekly" && day! % 7 == 0 ){ celebrationExsist = true }
                        else{
                            dateFormatter.dateFormat = "dd"
                            if(celebration_tables[self.frequency_db] == "month" && dateFormatter.string(from: historyDate) == dateFormatter.string(from: date)) { celebrationExsist = true }
                            dateFormatter.dateFormat = "MM dd"
                            if(celebration_tables[self.frequency_db] == "year" && dateFormatter.string(from: historyDate) == dateFormatter.string(from: date)) { celebrationExsist = true }
                        }
                        if(celebrationExsist){
                            celebrations.append(celebration(date: nowDate, classification: celebration_tables[self.classification_db], event: celebration_tables[self.event_db], count: count, important: celebration_tables[self.important_db]))
                            celebrationExsist = false
                        }
                    }
                }
                else{
                    if(celebration_tables[self.date_db] == nowDate){
                        celebrations.append(celebration(date: nowDate, classification: celebration_tables[self.classification_db], event: celebration_tables[self.event_db], count: count, important: celebration_tables[self.important_db]))
                    }
                    
                }
            } // for
        }
        catch {
            print("error")
        } // catch
        dateFormatter.dateFormat = "yyyy MM dd"
        nowDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM dd"
        if(dateFormatter.string(from: date) == "01 01"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "元旦", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "02 14"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "情人節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "02 28"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "二二八紀念日", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "04 01"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "愚人節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "04 04"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "兒童節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "04 05"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "清明節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "05 01"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "勞動節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "08 08"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "父親節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "10 10"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "國慶日", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "10 31"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "萬聖節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "11 11"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "光棍節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "12 25"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "聖誕節", count: count, important: false))
        }
        else if(dateFormatter.string(from: date) == "12 31"){
            celebrations.append(celebration(date: nowDate, classification: "celebration", event: "跨年", count: count, important: false))
        }
    }
    
    
    @IBAction func ChangeCount(_ sender: Any) {
        celebrations.removeAll()
        var currentdate = Date()
        let count = Int(Count.text ?? "60")
        for i in 0...count!{
            findCelebration(date: currentdate, count: i)
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: currentdate)!
            
        }
        Celebration.reloadData()
    }
    
    private func configureTapGestur() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector( CelebrationVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
