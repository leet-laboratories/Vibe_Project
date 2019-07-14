//
//  FriendsTableViewCell.swift
//  Vibe
//
//  Created by Allan Frederick on 11/10/18.
//  Copyright © 2018 Allan Frederick. All rights reserved.
//

import UIKit

// Custom delegate-style protocol for RequestsTableViewCell class
protocol FriendsTableViewCellDelegate: class {
    // Delegate method for button actions-
    func vibing(_ sender: FriendsTableViewCell)

}


class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var friendProfilePhoto: UIImageView!
    @IBOutlet weak var vibeIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
