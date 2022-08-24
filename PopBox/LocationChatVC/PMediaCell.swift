//
//  PMediaCell.swift
//  Popbox
//
//  Created by Ongraph on 3/20/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class PMediaCell: UITableViewCell {

    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
