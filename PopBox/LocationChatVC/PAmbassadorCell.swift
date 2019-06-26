//
//  PAmbassadorCell.swift
//  Popbox
//
//  Created by Ongraph on 2/13/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class PAmbassadorCell: UITableViewCell {

    @IBOutlet weak var lblSerial: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var txtViewAnswer: UITextView!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnAmbassador: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
