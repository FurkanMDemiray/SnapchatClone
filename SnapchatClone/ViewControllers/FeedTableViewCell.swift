//
//  FeedTableViewCell.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 10.12.2023.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
