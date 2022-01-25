//
//  TravelTableViewCell.swift
//  FinalProject
//
//  Created by Chen Eva on 2019/1/6.
//  Copyright © 2019年 Chen Eva. All rights reserved.
//

import UIKit

class TravelTableViewCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var PhotoImage: UIImageView!
    @IBOutlet weak var CountryLabel: UILabel!
    @IBOutlet weak var PlaceLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
