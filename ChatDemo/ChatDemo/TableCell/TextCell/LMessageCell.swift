//
//  LMessageCell.swift
//  Trippie
//
//  Created by Ongraph on 21/01/20.
//  Copyright © 2020 Ongraph Technologies Private Limited. All rights reserved.
//

import UIKit

class LMessageCell: UITableViewCell {
    
    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    
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
