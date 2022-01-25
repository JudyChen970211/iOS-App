//  TodayVC.swift
//  FinalProject

import UIKit
import SQLite

class TodayVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var table_inTeamView:Table = Table( "Money" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let classfication_db = Expression<String>( "classfication" )
    let money_db = Expression<String>( "money" )
    let state_db = Expression<String>( "state" )
    let detail_db = Expression<String>( "detail" )
    let second_db = Expression<String>( "second" )
    var pickDate = ""
    //var isTapped = false
    @IBOutlet weak var incomeshow: UILabel!
    @IBOutlet weak var costshow: UILabel!
    
    @IBOutlet weak var Today: UITableView!
    
    struct money {
        var date: String = ""
        var classfication: String = ""
        var money: String = ""
        var static_money: String = ""
        var detail: String = ""
        var second: String = ""
        var detailshow = false
    }
    
    var moneys = [money]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeshow.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
        costshow.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0)
        Today.delegate = self
        Today.dataSource = self
        do {
            // 此處建立連線，若無已存在之database則建立
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            let database = try Connection( fileUrl.path )
            
            self.database = database
        }catch{
            print( "error when connect to the database in viewdid" )
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        pickDate = dateFormatter.string(from: Date())
        moneyExsist(pickedDate: pickDate, indexPath: -1)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodayTableViewCell = Today.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath) as! TodayTableViewCell
        
        cell.classificationLabel?.text = moneys[indexPath.row].classfication
        cell.moneyLabel?.text = moneys[indexPath.row].money
        if(moneys[indexPath.row].detail != ""){cell.detailLabel?.text = moneys[indexPath.row].detail}
        else{ cell.detailLabel?.text = "No Data"}
        if(moneys[indexPath.row].detailshow == true) {
            cell.detailLabel?.isHidden = false
            cell.moneyLabel?.isHidden = true
            cell.classificationLabel?.isHidden = true
        }
        else{
            cell.detailLabel?.isHidden = true
            cell.moneyLabel?.isHidden = false
            cell.classificationLabel?.isHidden = false
        }
        if( moneys[indexPath.row].static_money == "cost"){
            cell.classificationLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
            cell.moneyLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
        }
        else {
            cell.classificationLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
            cell.moneyLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteMoney = self.table_inTeamView.filter(self.date_db == moneys[indexPath.row].date && self.classfication_db == moneys[indexPath.row].classfication && self.money_db == moneys[indexPath.row].money && self.detail_db == moneys[indexPath.row].detail && self.state_db == moneys[indexPath.row].static_money && self.second_db == moneys[indexPath.row].second )
            
            let deleteMoneys = deleteMoney.delete()
            
            do { try self.database?.run( deleteMoneys )}
            catch {print( "error when delete Table" )}
            
            
            moneys.removeAll()
            moneyExsist(pickedDate: pickDate, indexPath: -1)
            
            Today.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(moneys[indexPath.row].detailshow)
        if(moneys[indexPath.row].detailshow == false) {
            moneys.removeAll()
            moneyExsist(pickedDate: pickDate, indexPath: indexPath.row )
        }
        else {
            moneys.removeAll()
            moneyExsist(pickedDate: pickDate, indexPath: -1 )
        }
        
        print(moneys[indexPath.row].detailshow)
        Today.reloadData()
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue_today", sender: moneys[indexPath.row].second)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let date_sender = segue.destination as! AddMoneyVC
        date_sender.second = sender as! String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moneys.removeAll()
        moneyExsist(pickedDate: pickDate, indexPath: -1)
        Today.reloadData()
        
    }
    
    func moneyExsist(pickedDate: String, indexPath: Int) -> Void {
        var cout = 0
        do {
            let money_table = try self.database.prepare(self.table_inTeamView)
            
            for money_tables in money_table {
                if(pickedDate == money_tables[self.date_db]){
                    if( indexPath == cout ){
                        moneys.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: true))
                    }
                    else{
                        moneys.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: false))
                    }
                    cout += 1
                }
                
            } // for
        }
        catch {
        } // catch
    }

    
    @IBAction func DateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        pickDate = dateFormatter.string(from: datePicker.date)
        moneys.removeAll()
        moneyExsist(pickedDate: pickDate, indexPath: -1 )
        Today.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
