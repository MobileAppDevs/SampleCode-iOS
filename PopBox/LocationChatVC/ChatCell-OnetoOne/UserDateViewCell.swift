//
//  DateViewCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/20/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserDateViewCell: UITableViewCell {

    @IBOutlet var dateBubbleimgView : UIImageView!
    @IBOutlet var lblDate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateBubbleimgView.clipsToBounds = true
        // Initialization code
    }
    /*func setDateTop(chatObj : ChatUser)
    {
        self.lblDate.text = chatuser.message
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.isUserInteractionEnabled = false
    }*/

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
