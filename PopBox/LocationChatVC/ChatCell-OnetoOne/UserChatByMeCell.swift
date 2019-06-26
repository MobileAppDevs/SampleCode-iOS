//
//  ChatByMeCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 11/24/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserChatByMeCell: UITableViewCell {

    @IBOutlet var meChatBubbleView : UIImageView!
    @IBOutlet var meChatText : UILabel!
    @IBOutlet var chattime : UILabel!
    @IBOutlet var imgLikes : UIImageView!
    @IBOutlet var lblNoOfLikes : UILabel!
    @IBOutlet var viewContainer : UIView!
    @IBOutlet var leadingConstraint : NSLayoutConstraint!
    @IBOutlet var likecountHeight : NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
       
       
        
        
        //meChatBubbleView.image = UIImage(named:"chatbyme")?.resizableImage(withCapInsets: UIEdgeInsetsMake(10, 10, 10, 10), resizingMode:.stretch)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
