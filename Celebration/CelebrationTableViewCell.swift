//  CelebrationTableViewCell.swift
//  FinalProject

import UIKit

class CelebrationTableViewCell: UITableViewCell {
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var EventLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
