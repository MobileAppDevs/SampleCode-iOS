//
//  PLocationPeopleHeaderTVCell.swift
//  Popbox
//
//  Created by Chandan Kumar on 12/27/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class PLocationPeopleHeaderTVCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnCount: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
