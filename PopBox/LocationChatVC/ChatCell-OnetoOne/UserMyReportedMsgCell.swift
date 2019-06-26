//
//  MyReportedMsgCell.swift
//  PopboxChat
//
//  Created by Ashish Sharma on 12/14/17.
//  Copyright © 2017 Noto. All rights reserved.
//

import UIKit

class UserMyReportedMsgCell: UITableViewCell {

    @IBOutlet var meChatBubbleView : UIImageView!
    @IBOutlet var meChatText : UILabel!
    @IBOutlet var chattime : UILabel!
    @IBOutlet var viewContainer : UIView!
    
    let dateFormaatr = DateFormatter()
    let timeFormattr = DateFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   /* func setReportedMessageCell(chatObj :ChatUser)
    {
        dateFormaatr.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeFormattr.dateFormat = "HH:mm"
        
        let date = dateFormaatr.date(from: chatObj.created_at!)
        self.chattime.text = String(format:"%@",timeFormattr.string(from: date!))
        
        self.meChatBubbleView.backgroundColor = UIColor.lightGray
        self.meChatBubbleView.layer.shadowOffset = .zero
        self.meChatBubbleView.layer.shadowColor = UIColor.black.cgColor
        self.meChatBubbleView.layer.shadowRadius = 4
        self.meChatBubbleView.layer.shadowOpacity = 0.25
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
