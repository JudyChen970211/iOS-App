//  CostIncomeVC.swift
//  FinalProject

import UIKit
import SQLite

class CostIncomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var table_inTeamView:Table = Table( "Money" )
    var database:Connection!
    
    let date_db = Expression<String>( "date" )
    let classfication_db = Expression<String>( "classfication" )
    let money_db = Expression<String>( "money" )
    let state_db = Expression<String>( "state" )
    let detail_db = Expression<String>( "detail" )
    let second_db = Expression<String>( "second" )
    
    @IBOutlet weak var Money: UITableView!
    
    @IBOutlet weak var incomeshow: UILabel!
    @IBOutlet weak var costshow: UILabel!
    
    struct money {
        var date: String = ""
        var classfication: String = ""
        var money: String = ""
        var static_money: String = ""
        var detail: String = ""
        var second: String = ""
        var detailshow :Bool = false
    }
    
    var money_all = [money]()
    var money_cost = [money]()
    var money_income = [money]()
    var state = "all"
    var ChangeState = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(state == "all"){ return money_all.count }
        else if(state == "cost"){ return money_cost.count }
        else { return money_income.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MoneyTableViewCell = Money.dequeueReusableCell(withIdentifier: "MoneyCell", for: indexPath) as! MoneyTableViewCell
        print(ChangeState)
        if(state == "all"){
            if(money_all[indexPath.row].detailshow == true && ChangeState == false) {
                cell.DetailLabel?.isHidden = false
                cell.DateLabel?.isHidden = true
                cell.MoneyLabel?.isHidden = true
                cell.ClassificationLabel?.isHidden = true
            }
            else{
                cell.DetailLabel?.isHidden = true
                cell.DateLabel?.isHidden = false
                cell.MoneyLabel?.isHidden = false
                cell.ClassificationLabel?.isHidden = false
                if(money_all[indexPath.row].detailshow == true || indexPath.row == money_all.count-2 ) {ChangeState = false}
            }
            cell.DateLabel?.text = money_all[indexPath.row].date
            cell.ClassificationLabel?.text = money_all[indexPath.row].classfication
            cell.MoneyLabel?.text = money_all[indexPath.row].money
            if(money_all[indexPath.row].detail != ""){cell.DetailLabel?.text = money_all[indexPath.row].detail}
            else{ cell.DetailLabel?.text = "No Data"}
            if( money_all[indexPath.row].static_money == "cost"){
                cell.DateLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
                cell.ClassificationLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
                cell.MoneyLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
            }
            else {
                cell.DateLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
                cell.ClassificationLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
                cell.MoneyLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
            }
        }
        else if(state == "cost"){
            if(money_cost[indexPath.row].detailshow == true && ChangeState == false) {
                cell.DetailLabel?.isHidden = false
                cell.DateLabel?.isHidden = true
                cell.MoneyLabel?.isHidden = true
                cell.ClassificationLabel?.isHidden = true
            }
            else{
                cell.DetailLabel?.isHidden = true
                cell.DateLabel?.isHidden = false
                cell.MoneyLabel?.isHidden = false
                cell.ClassificationLabel?.isHidden = false
                if(money_cost[indexPath.row].detailshow == true || indexPath.row == money_cost.count-2 ) {ChangeState = false}
            }
            cell.DateLabel?.text = money_cost[indexPath.row].date
            cell.ClassificationLabel?.text = money_cost[indexPath.row].classfication
            cell.MoneyLabel?.text = money_cost[indexPath.row].money
            if(money_cost[indexPath.row].detail != ""){cell.DetailLabel?.text = money_cost[indexPath.row].detail}
            else{ cell.DetailLabel?.text = "No Data"}
            cell.DateLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
            cell.ClassificationLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
            cell.MoneyLabel?.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1)
        }
        else if(state == "income"){
            if(money_income[indexPath.row].detailshow == true && ChangeState == false) {
                cell.DetailLabel?.isHidden = false
                cell.DateLabel?.isHidden = true
                cell.MoneyLabel?.isHidden = true
                cell.ClassificationLabel?.isHidden = true
            }
            else{
                cell.DetailLabel?.isHidden = true
                cell.DateLabel?.isHidden = false
                cell.MoneyLabel?.isHidden = false
                cell.ClassificationLabel?.isHidden = false
                if(money_income[indexPath.row].detailshow == true || indexPath.row == money_income.count-2 ) {ChangeState = false}
            }
            cell.DateLabel?.text = money_income[indexPath.row].date
            cell.ClassificationLabel?.text = money_income[indexPath.row].classfication
            cell.MoneyLabel?.text = money_income[indexPath.row].money
            if(money_income[indexPath.row].detail != ""){cell.DetailLabel?.text = money_income[indexPath.row].detail}
            else{ cell.DetailLabel?.text = "No Data"}
            cell.DateLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
            cell.ClassificationLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
            cell.MoneyLabel?.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var table_trans = money_all[indexPath.row].second
        if(state == "cost"){ table_trans = money_cost[indexPath.row].second }
        else if( state == "income" ){ table_trans = money_income[indexPath.row].second }
        performSegue(withIdentifier: "segue_history", sender: table_trans)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let date_sender = segue.destination as! AddMoneyVC
        date_sender.second = sender as! String
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var deleteMoney = self.table_inTeamView.filter(self.date_db == money_all[indexPath.row].date && self.classfication_db == money_all[indexPath.row].classfication && self.money_db == money_all[indexPath.row].money && self.detail_db == money_all[indexPath.row].detail && self.state_db == money_all[indexPath.row].static_money && self.second_db == money_all[indexPath.row].second )
            if(state == "cost"){
                deleteMoney = self.table_inTeamView.filter(self.date_db == money_cost[indexPath.row].date && self.classfication_db == money_cost[indexPath.row].classfication && self.money_db == money_cost[indexPath.row].money && self.detail_db == money_cost[indexPath.row].detail && self.state_db == money_cost[indexPath.row].static_money && self.second_db == money_cost[indexPath.row].second  )
            }
            else if(state == "income"){
                deleteMoney = self.table_inTeamView.filter(self.date_db == money_income[indexPath.row].date && self.classfication_db == money_income[indexPath.row].classfication && self.money_db == money_income[indexPath.row].money && self.detail_db == money_income[indexPath.row].detail && self.state_db == money_income[indexPath.row].static_money && self.second_db == money_income[indexPath.row].second )
            }
            let deleteMoneys = deleteMoney.delete()
            
            do { try self.database?.run( deleteMoneys )}
            catch {print( "error when delete Table" )}
            
            let count = -1
            var currentdate = Date()
            var endDate = ""
            money_income.removeAll()
            money_cost.removeAll()
            money_all.removeAll()
            
            for _ in 1...countDays(){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
                endDate = dateFormatter.string(from: currentdate)
                moneyExsist(endDate: endDate, indexPathDate: "")
                currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
            }
            Money.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let count = -1
        var currentdate = Date()
        var endDate = ""
        var indexPathDate = ""
        if(state == "all" && money_all[indexPath.row].detailshow == false) {indexPathDate = money_all[indexPath.row].second}
        else if(state == "cost" && money_cost[indexPath.row].detailshow == false) {indexPathDate = money_cost[indexPath.row].second}
        else if(state == "income" && money_income[indexPath.row].detailshow == false) {indexPathDate = money_income[indexPath.row].second}
        
        money_all.removeAll()
        money_cost.removeAll()
        money_income.removeAll()
        
        for _ in 1...countDays(){
            endDate = dateFormatter.string(from: currentdate)
            if(indexPathDate != ""){ moneyExsist(endDate: endDate, indexPathDate: indexPathDate) }
            else {moneyExsist(endDate: endDate, indexPathDate: "")}
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
        }
        
        
        Money.reloadData()
    }
    
    @IBAction func SelectdCostOrIncome(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){ state = "all" }
        else if(sender.selectedSegmentIndex == 1){ state = "cost" }
        else { state = "income" }
        
        ChangeState = true
        Money.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeshow.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
        costshow.textColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0)
        state = "all"
        let count = -1
        var currentdate = Date()
        var endDate = ""
        Money.delegate = self
        Money.dataSource = self
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
            moneyExsist(endDate: endDate, indexPathDate: "")
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let count = -1
        var currentdate = Date()
        var endDate = ""
        money_all.removeAll()
        money_income.removeAll()
        money_cost.removeAll()
        for _ in 1...countDays(){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            endDate = dateFormatter.string(from: currentdate)
            moneyExsist(endDate: endDate, indexPathDate: "")
            currentdate = Calendar.current.date(byAdding: Calendar.Component.day, value: count, to: currentdate)!
        }
        Money.reloadData()
        
    }
 
    func moneyExsist(endDate: String, indexPathDate: String) -> Void {
        do {
            let money_table = try self.database.prepare(self.table_inTeamView)
            
            for money_tables in money_table {
                if(endDate == money_tables[self.date_db]){
                    if(indexPathDate == money_tables[self.second_db] && ChangeState == false){
                        money_all.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: true))
                    }
                    else{money_all.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: false))}
                    if(money_tables[self.state_db] == "cost"){
                        if(indexPathDate == money_tables[self.second_db] && ChangeState == false){
                            money_cost.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: true))
                        }
                        else{
                            money_cost.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: false))
                        }
                    }
                    else{
                        if(indexPathDate == money_tables[self.second_db] && ChangeState == false){
                            money_income.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: true))
                        }
                        else{
                            money_income.append(money(date: money_tables[self.date_db] , classfication: money_tables[self.classfication_db], money: money_tables[self.money_db], static_money: money_tables[self.state_db], detail: money_tables[self.detail_db], second: money_tables[self.second_db], detailshow: false))
                        }
                    }
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
        return day!+1
        
    }
}
