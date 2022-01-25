//  DiaryTableViewCell.swift
//  FinalProject

import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DataLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var wheather: UIImageView!
    @IBOutlet weak var mood: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
