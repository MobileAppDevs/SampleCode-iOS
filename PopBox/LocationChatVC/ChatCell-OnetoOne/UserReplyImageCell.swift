//
//  ReplyImageCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/7/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserReplyImageCell: UITableViewCell {

    @IBOutlet var meChatBubbleView : UIImageView!
    @IBOutlet var meChatText : UILabel!
    @IBOutlet var chattime : UILabel!
    @IBOutlet var imgLikes : UIImageView!
    @IBOutlet var lblNoOfLikes : UILabel!
    @IBOutlet var viewContainer : UIView!
    @IBOutlet var bttnImgPreview : UIButton!
    @IBOutlet var likecountHeight : NSLayoutConstraint!
    @IBOutlet var replyView : UIView!
    @IBOutlet var otherUSer : UILabel!
    @IBOutlet var otherMsg : UILabel!
    @IBOutlet var imgView : UIImageView!
    
    override func awakeFromNib() {
        
        replyView.backgroundColor = UIColor.init(hex: "8EC2FF").withAlphaComponent(0.45)
        replyView.clipsToBounds = true
        replyView.layer.borderColor = UIColor.white.cgColor
        replyView.layer.borderWidth = 0.4
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
