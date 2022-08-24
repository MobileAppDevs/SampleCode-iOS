//
//  MyMsgReplyCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/1/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserMyMsgReplyCell: UITableViewCell {

    @IBOutlet var meChatBubbleView : UIImageView!
    @IBOutlet var meChatText : UILabel!
    @IBOutlet var chattime : UILabel!
    @IBOutlet var imgLikes : UIImageView!
    @IBOutlet var lblNoOfLikes : UILabel!
    @IBOutlet var viewContainer : UIView!
    @IBOutlet var leadingConstraint : NSLayoutConstraint!
     @IBOutlet var likecountHeight : NSLayoutConstraint!
    @IBOutlet var replyView : UIView!
//    @IBOutlet var otherUSer : UILabel!
    @IBOutlet var otherMsg : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        replyView.backgroundColor = UIColor.init(hex: "8EC2FF").withAlphaComponent(0.45)
        replyView.clipsToBounds = true
        replyView.layer.borderColor = UIColor.white.cgColor
        replyView.layer.borderWidth = 0.3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
