//
//  ChatImageByMeCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 11/24/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit
import Kingfisher

class UserChatImageByMeCell: UITableViewCell {

    @IBOutlet var chatBubbleView : UIImageView!
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var imgLike : UIImageView!
    @IBOutlet var lblCountLikes : UILabel!
     @IBOutlet var likecountHeight : NSLayoutConstraint!
    
    @IBOutlet var viewContainer : UIView!
    @IBOutlet var bttnImgPreview : UIButton!
    
    let dateFormaatr = DateFormatter()
    let timeFormattr = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //imgView.layer.cornerRadius = 3.5
        imgView.clipsToBounds = true
        // Initialization code
    }

  /*  func setMyChatImage(chatuser : ChatUser)
    {
        dateFormaatr.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeFormattr.dateFormat = "HH:mm"
        
        let date = dateFormaatr.date(from: chatuser.created_at!)
        let likeCount : Int = chatuser.count!
        self.lblTime.text = String(format:"%@",timeFormattr.string(from: date!))
        self.lblCountLikes.isHidden = true
        self.likecountHeight.constant = 0
        self.imgLike.isHidden = true
        if(likeCount > 0)
        {
            self.lblCountLikes.isHidden = false
            self.likecountHeight.constant = 15
            self.imgLike.isHidden = false
            if(likeCount > 1)
            {
                self.lblCountLikes.text = String(format:"%d likes",likeCount)
            }
            else
            {
                self.lblCountLikes.text = String(format:"%d like",likeCount)
            }
            
        }
        let imgName : String = chatuser.logo!
        self.imgView.image = nil
        if(imgName != "")
        {
           
            let url : URL = URL(string: String(format:"%@%@",imageBaseURL,imgName))!
            // myImageCell.imgView.af_setImage(withURL: url)
            self.imgView.sd_addActivityIndicator()
            self.imgView.sd_setIndicatorStyle(.gray)
            self.imgView.sd_setImage(with: url, completed: nil)
            
        }
        else
        {
            
            self.imgView.image = UIImage(named:"no_Preview")
        }
       
       )
        
        self.chatBubbleView.layer.shadowOffset = .zero
        self.chatBubbleView.layer.shadowColor = UIColor.black.cgColor
        self.chatBubbleView.layer.shadowRadius = 4
        self.chatBubbleView.layer.shadowOpacity = 0.25
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
