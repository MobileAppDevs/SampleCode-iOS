//
//  LImageTableViewCell.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 23/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit

class LImageTableViewCell: UITableViewCell {

    @IBOutlet weak var view_buble: UIView!
    @IBOutlet weak var img_Limage: UIImageView!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var view_blur: UIView!
    @IBOutlet weak var btn_download: UIButton!
    
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
            self.view_buble.roundCornerMask(cornerRadius: 15.0, [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner])
        }
    }
}
