//
//  MyChatVideoCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/6/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserMyChatVideoCell: UITableViewCell {

    @IBOutlet var chatBubble : UIImageView!
    @IBOutlet var playerView : PlayerView!
    @IBOutlet var bttnPlayPauseVideo : UIButton!
    @IBOutlet var chtaTime : UILabel!
    @IBOutlet var imgLike : UIImageView!
    @IBOutlet var lblCountLikes : UILabel!
     @IBOutlet var likecountHeight : NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
