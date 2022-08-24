

import UIKit

class PUserProfileTVCell: UITableViewCell {
    

    @IBOutlet weak var imgUserProfile: UIMaskViewImage!
    
    @IBOutlet weak var lblUserInfo: UILabel!
    
    @IBOutlet weak var colView: UICollectionView!

    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var colViewWidthConstraint: NSLayoutConstraint!
 
    var peoples = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
