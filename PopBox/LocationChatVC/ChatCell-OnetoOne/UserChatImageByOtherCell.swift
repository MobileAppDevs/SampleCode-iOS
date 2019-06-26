//
//  ChatImageByOtherCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 11/24/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserChatImageByOtherCell: UITableViewCell {

    @IBOutlet var chatBubbleView : UIImageView!
    @IBOutlet var userImg : UIMaskViewImage!
    @IBOutlet var userStatus : UIImageView!
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var chatTime : UILabel!
    @IBOutlet var lblUserName  : UILabel!
    @IBOutlet var bttnLike : UIButton!
    @IBOutlet var lblCountLikes : UILabel!
    @IBOutlet var likecountHeight : NSLayoutConstraint!
    @IBOutlet var viewContainer : UIView!
    @IBOutlet var bttnImgPreview : UIButton!
    @IBOutlet var userConnection : UILabel!
    @IBOutlet var newConnection : UIButton!
    @IBOutlet var rating : UIButton!
    @IBOutlet var lblRating : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // imgView.layer.cornerRadius = 3.5
        imgView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
