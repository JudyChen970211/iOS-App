//  StatisticsVC.swift
//  FinalProject

import UIKit
import Charts
import SQLite

class StatisticsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var table:Table = Table( "Money" )
    var database:Connection!

    let date_db = Expression<String>( "date" )
    let classfication_db = Expression<String>( "classfication" )
    let money_db = Expression<String>( "money" )
    let state_db = Expression<String>( "state" )
    let detail_db = Expression<String>( "detail" )
    let second_db = Expression<String>( "second" )
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var statistic: UITableView!
    var currentDate = ""
    var currentMonth = ""
    var currentYear = ""
    var start_currentMonth = ""
    var start_currentYear = ""
    var end_currentMonth = ""
    var end_currentYear = ""
    var start_currentDate = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statistic.delegate = self
        statistic.dataSource = self
        checkNowDate(date: Date())
        do {
            // 此處建立連線，若無已存在之database則建立
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Calendar_database").appendingPathExtension("sqlite3")
            
            self.database = try Connection( fileUrl.path )
        }
        catch{
            print( "error when connect to the database in viewdid" )
        }
        
        // Do any additional setup after loading the view.
    }

    func checkNowDate(date:Date) -> Void{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        currentDate =  dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy年MM月"
        currentMonth = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy年"
        currentYear = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy MM dd"
        start_currentDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy MM"
        start_currentMonth = dateFormatter.string(from: date) + " 00"
        end_currentMonth = dateFormatter.string(from: date) + " 32"
        dateFormatter.dateFormat = "yyyy"
        start_currentYear = dateFormatter.string(from: date) + " 01 00"
        end_currentYear = dateFormatter.string(from: date) + " 12 32"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = PieChartDataEntry() // 食
        let clothing = PieChartDataEntry(value: 1) // 衣
        let housing = PieChartDataEntry(value: 1) // 住
        let transpotation = PieChartDataEntry(value: 1) // 行
        let education = PieChartDataEntry(value: 1) // 育
        let fun = PieChartDataEntry(value: 1) // 樂
        let daily = PieChartDataEntry(value: 1) // 日常
        let medical = PieChartDataEntry(value: 1) // 醫療
        let treatment = PieChartDataEntry(value: 1) // 美妝
        let invest = PieChartDataEntry(value: 1) // 投資
        let other = PieChartDataEntry(value: 1) // 其他
        var numberOfDownloadsDataEntries = [PieChartDataEntry]()
        let cell: StatisticTableViewCell = statistic.dequeueReusableCell(withIdentifier: "StatisticCell", for: indexPath) as! StatisticTableViewCell
        cell.pieChart.chartDescription?.text = ""
        numberOfDownloadsDataEntries = [food, clothing, housing, transpotation, education, fun, daily, medical, treatment, invest, other]

        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        chartDataSet.sliceSpace = 3
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        formatter.zeroSymbol = ""
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))


        if(indexPath.row == 0){
            cell.statisticLabel.text = currentDate + " 記帳分析"
            food.value = calculate(classification: "伙食")[0]
            clothing.value = calculate(classification: "治裝")[0]
            housing.value = calculate(classification: "房租")[0]
            transpotation.value = calculate(classification: "交通")[0]
            education.value = calculate(classification: "教育")[0]
            fun.value = calculate(classification: "娛樂")[0]
            daily.value = calculate(classification: "日用")[0]
            medical.value = calculate(classification: "醫療")[0]
            treatment.value = calculate(classification: "美妝")[0]
            invest.value = calculate(classification: "投資")[0]
            other.value = calculate(classification: "其他")[0]
        }
        else if( indexPath.row == 1){
            cell.statisticLabel.text = currentMonth + " 記帳分析"
            food.value = calculate(classification: "伙食")[1]
            clothing.value = calculate(classification: "治裝")[1]
            housing.value = calculate(classification: "房租")[1]
            transpotation.value = calculate(classification: "交通")[1]
            education.value = calculate(classification: "教育")[1]
            fun.value = calculate(classification: "娛樂")[1]
            daily.value = calculate(classification: "日用")[1]
            medical.value = calculate(classification: "醫療")[1]
            treatment.value = calculate(classification: "美妝")[1]
            invest.value = calculate(classification: "投資")[1]
            other.value = calculate(classification: "其他")[1]
        }
        else if( indexPath.row == 2){
            cell.statisticLabel.text = currentYear + " 記帳分析"
            food.value = calculate(classification: "伙食")[2]
            clothing.value = calculate(classification: "治裝")[2]
            housing.value = calculate(classification: "房租")[2]
            transpotation.value = calculate(classification: "交通")[2]
            education.value = calculate(classification: "教育")[2]
            fun.value = calculate(classification: "娛樂")[2]
            daily.value = calculate(classification: "日用")[2]
            medical.value = calculate(classification: "醫療")[2]
            treatment.value = calculate(classification: "美妝")[2]
            invest.value = calculate(classification: "投資")[2]
            other.value = calculate(classification: "其他")[2]
        }
        else {
            cell.statisticLabel.text = "歷史紀錄分析"
            food.value = calculate(classification: "伙食")[3]
            clothing.value = calculate(classification: "治裝")[3]
            housing.value = calculate(classification: "房租")[3]
            transpotation.value = calculate(classification: "交通")[3]
            education.value = calculate(classification: "教育")[3]
            fun.value = calculate(classification: "娛樂")[3]
            daily.value = calculate(classification: "日用")[3]
            medical.value = calculate(classification: "醫療")[3]
            treatment.value = calculate(classification: "美妝")[3]
            invest.value = calculate(classification: "投資")[3]
            other.value = calculate(classification: "其他")[3]
        }
        
        if(food.value > 0.0){food.label = "伙食"}
        if(clothing.value > 0.0){clothing.label = "治裝"}
        if(housing.value > 0.0){housing.label = "房租"}
        if(transpotation.value > 0.0){transpotation.label = "交通"}
        if(education.value > 0.0){education.label = "教育"}
        if(fun.value > 0.0){fun.label = "娛樂"}
        if(daily.value > 0.0){daily.label = "日用"}
        if(medical.value > 0.0){medical.label = "醫療"}
        if(treatment.value > 0.0){treatment.label = "美妝"}
        if(invest.value > 0.0){invest.label = "投資"}
        if(other.value > 0.0){other.label = "其他"}
        
        let colors = [UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.7), UIColor(red: 0.8, green: 0.26, blue: 0.0, alpha: 0.7), UIColor(red: 0.8, green: 0.8, blue: 0.0, alpha: 0.7), UIColor(red: 0.26, green: 0.8, blue: 0.0, alpha: 0.7), UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 0.7), UIColor(red: 0.0, green: 0.8, blue: 0.26, alpha: 0.7), UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 0.7), UIColor(red: 0.0, green: 0.26, blue: 0.8, alpha: 0.7), UIColor(red: 0.0, green: 0.0, blue: 0.8, alpha: 0.7), UIColor(red: 0.26, green: 0.0, blue: 0.8, alpha: 0.7), UIColor(red: 0.8, green: 0.0, blue: 0.8, alpha: 0.7)]
        
        let total = food.value + clothing.value + housing.value + transpotation.value + education.value + fun.value + daily.value + medical.value + treatment.value + invest.value + other.value
        
        chartDataSet.colors = colors
        cell.pieChart.data = chartData
        cell.pieChart.legend.enabled = false
        cell.pieChart.usePercentValuesEnabled = true
        cell.pieChart.holeColor = UIColor.clear
        if(total == 0.0){cell.pieChart.centerText = "No Data"}
        else{cell.pieChart.centerText = "Cost : " + String(total)}
        cell.pieChart.holeRadiusPercent = 0.4
        cell.pieChart.usePercentValuesEnabled = true
        cell.pieChart.rotationEnabled = false
        cell.pieChart.isUserInteractionEnabled = false
        return cell
    }
    
    class DigitValueFormatter: NSObject, IValueFormatter {
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            let valueWithoutDecimalPart = String(format: "%.2f%%", value)
            return valueWithoutDecimalPart

        }
    }
    
    @IBAction func ChangeDate(_ sender: UIDatePicker) {
        checkNowDate(date: datePicker.date)
        statistic.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func calculate(classification:String) -> [Double] {
        var totalDay = 0.0
        var totalMonth = 0.0
        var totalYear = 0.0
        var total = 0.0
        do {
            let statistic_table = try self.database.prepare(self.table)
            
            for statistic_tables in statistic_table {
                if(statistic_tables[self.classfication_db] == classification && statistic_tables[self.state_db] == "cost" ){
                    if(start_currentDate == statistic_tables[self.date_db]){totalDay += Double(statistic_tables[self.money_db])!}
                    if(start_currentMonth < statistic_tables[self.date_db] && statistic_tables[self.date_db] < end_currentMonth){ totalMonth += Double(statistic_tables[self.money_db])!}
                    if(start_currentYear < statistic_tables[self.date_db] && statistic_tables[self.date_db] < end_currentYear){ totalYear += Double(statistic_tables[self.money_db])!}
                    total += Double(statistic_tables[self.money_db])!
                }
                
            } // for
        }
        catch {
        } // catch
        
        return [totalDay, totalMonth, totalYear, total]
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
