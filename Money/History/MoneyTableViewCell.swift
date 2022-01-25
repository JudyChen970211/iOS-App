//  MoneyTableViewCell.swift
//  FinalProject

import UIKit

class MoneyTableViewCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var ClassificationLabel: UILabel!
    @IBOutlet weak var MoneyLabel: UILabel!
    @IBOutlet weak var DetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
