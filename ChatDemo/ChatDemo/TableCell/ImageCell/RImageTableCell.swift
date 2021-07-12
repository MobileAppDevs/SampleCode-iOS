//
//  RImageTableCell.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 22/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit

class RImageTableCell: UITableViewCell {

    @IBOutlet weak var view_buble: UIView!
    @IBOutlet weak var img_Rimage: UIImageView!
    @IBOutlet weak var lbl_time: UILabel!
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
            self.view_buble.roundCornerMask(cornerRadius: 15.0, [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
}
