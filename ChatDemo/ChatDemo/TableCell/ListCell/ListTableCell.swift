//
//  ListTableCell.swift
//  Trippie
//
//  Created by Ongraph on 21/01/20.
//  Copyright © 2020 Ongraph Technologies Private Limited. All rights reserved.
//

import UIKit

class ListTableCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
