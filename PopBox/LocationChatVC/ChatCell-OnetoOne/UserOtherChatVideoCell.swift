//
//  OtherChatVideoCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/6/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserOtherChatVideoCell: UITableViewCell {
    @IBOutlet var userImg : UIMaskViewImage!
    @IBOutlet var userStatus : UIImageView!
    @IBOutlet var chatBubble : UIImageView!
    @IBOutlet var playerView : PlayerView!
    @IBOutlet var bttnPlayPauseVideo : UIButton!
    @IBOutlet var chtaTime : UILabel!
    @IBOutlet var bttnLike : UIButton!
    @IBOutlet var lblCountLikes : UILabel!
    @IBOutlet var otherUerName : UILabel!
     @IBOutlet var likecountHeight : NSLayoutConstraint!
    @IBOutlet var userConnection : UILabel!
    @IBOutlet var newConnection : UIButton!
    @IBOutlet var rating : UIButton!
    @IBOutlet var lblRating : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
