//
//  HeroListTableViewCell.swift
//  HeroBuddy
//
//  Created by Stephen Nary on 9/20/21.
//

import UIKit

class HeroListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
