//
//  ChatByOtherCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 11/24/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserChatByOtherCell: UITableViewCell {
    
    @IBOutlet var otherChatBubbleView : UIImageView!
//    @IBOutlet var userImg : UIMaskViewImage!
//    @IBOutlet var userStatus : UIImageView!
    @IBOutlet var userChatText : UILabel!
//    @IBOutlet var userName : UILabel!
    @IBOutlet var chatTime : UILabel!
//    @IBOutlet var userConnection : UILabel!
//    @IBOutlet var newConnection : UIButton!
//    @IBOutlet var rating : UIButton!
//    @IBOutlet var lblRating : UILabel!
//    @IBOutlet var bttnLike : UIButton!
//    @IBOutlet var noOfLikes : UILabel!
    @IBOutlet var chatContainer : UIView!
    @IBOutlet var trailingConstraint : NSLayoutConstraint!
//    @IBOutlet var userNamewidthConstraint : NSLayoutConstraint!
//     @IBOutlet var likecountHeight : NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
//        userImg.layer.cornerRadius = 15.0
//        userStatus.layer.cornerRadius = 5
//       
//        userConnection.layer.cornerRadius = 1.5
//        userConnection.clipsToBounds = true
        
        NSLog("chatTime ---- \(chatTime.frame.origin.y+chatTime.frame.size.height)")
         NSLog("chatContainer ---- \(chatContainer.frame.origin.y+chatContainer.frame.size.height)")
        
      /*UIImageView *bubbleImage=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Bubbletyperight"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        bubbleImage.tag=55;
        [self.contentView addSubview:bubbleImage];*/
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
