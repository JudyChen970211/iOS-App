//  CalendarTableViewCell.swift
//  FinalProject

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var ClassificationLable: UILabel!
    @IBOutlet weak var EventLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
