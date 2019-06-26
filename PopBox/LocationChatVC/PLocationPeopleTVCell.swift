//
//  PLocationPeopleTVCell.swift
//  Popbox
//
//  Created by Chandan Kumar on 12/27/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class PLocationPeopleTVCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIMaskViewImage!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var btnFriend: UIButton!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblUserShortName: UILabel!
    @IBOutlet weak var lblBumps: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
