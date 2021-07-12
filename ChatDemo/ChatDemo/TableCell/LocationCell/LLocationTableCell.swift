//
//  LLocationTableCell.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 29/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit

class LLocationTableCell: UITableViewCell {

    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var imgLocationImage: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
       func roundCorner(){
           DispatchQueue.main.async {
               self.viewBubble.roundCornerMask(cornerRadius: 15.0, [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner])
           }
       }

}
