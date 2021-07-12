//
//  ContactTableCell.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 27/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit

class ContactTableCell: UITableViewCell {

    @IBOutlet weak var view_color: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
