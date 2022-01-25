//  DiaryVC.swift
//  FinalProject

import UIKit
import SQLite


class DiaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var table_inTeamView:Table = Table( "Diary" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let wheather_db = Expression<String>( "wheather" )
    let mood_db = Expression<String>( "mood" )
    let data_db = Expression<String>( "data" )
    
    struct diary {
        var date: String = ""
        var data: String = ""
        var wheather: String = ""
        var mood: String = ""
    }
    

    var diarys = [diary]()
    
    @IBOutlet weak var Diary: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DiaryTableViewCell = Diary.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryTableViewCell
        cell.DateLabel?.text = diarys[indexPath.row].date
        cell.DataLabel?.text = diarys[indexPath.row].data
        cell.mood?.image = UIImage(named:diarys[indexPath.row].mood)
        cell.wheather?.image = UIImage(named:diarys[indexPath.row].wheather)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let deleteDiary  = self.table_inTeamView.filter(self.date_db == diarys[indexPath.row].date)
            let deleteDiarys = deleteDiary.delete()
            
            do {
                try self.database?.run( deleteDiarys )
            }
            catch {
                print( "error happen when delet Table" )
            }
            diarys.remove(at: indexPath.row)
            
            Diary.beginUpdates()
            Diary.deleteRows(at: [indexPath], with: .fade)
            Diary.endUpdates()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date_send = diarys[indexPath.row].date
        performSegue(withIdentifier: "Diary_detail", sender: date_send)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let date_sender = segue.destination as! AddDiaryVC
        date_sender.date = sender as! String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let count = -1
        var currentdate = Date()
        var endDate = ""
        diarys.removeAll()
        for _ in 1...countDays(){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            endDate = dateFormatter.string(from: currentdate)
            diaryExsist(endDate: endDate)
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
        }
        Diary.reloadData()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Diary.delegate = self
        Diary.dataSource = self
        let count = -1
        var currentdate = Date()
        var endDate = ""
        do {
            // 此處建立連線，若無已存在之database則建立
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
            diaryExsist(endDate: endDate)
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
        }
        
    }
    
    func diaryExsist(endDate: String) -> Void {
        do {
            let diary_table = try self.database.prepare(self.table_inTeamView)
            
            for diary_tables in diary_table {
                if(endDate == diary_tables[self.date_db]){
                    diarys.append(diary(date: diary_tables[self.date_db] , data: diary_tables[self.data_db], wheather: diary_tables[self.wheather_db], mood: diary_tables[self.mood_db]))
                }
            } // for
        }
        catch {
        } // catch
    }
    
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
}
