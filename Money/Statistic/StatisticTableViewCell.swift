//  StatisticTableViewCell.swift
//  FinalProject

import UIKit
import Charts
class StatisticTableViewCell: UITableViewCell {

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var statisticLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
