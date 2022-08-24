//
//  OtherReportedMsgCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/14/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserOtherReportedMsgCell: UITableViewCell {

    @IBOutlet var otherChatBubbleView : UIImageView!
    @IBOutlet var userImg : UIMaskViewImage!
    @IBOutlet var userStatus : UIImageView!
    @IBOutlet var userName : UILabel!
    @IBOutlet var chatContainer : UIView!
    @IBOutlet var chatTime : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
