//
//  RequestsTableViewCell.swift
//  Vibe
//
//  Created by Allan Frederick on 11/3/18.
//  Copyright © 2018 Allan Frederick. All rights reserved.
//

import UIKit


// Custom delegate-style protocol for RequestsTableViewCell class
protocol RequestsTableViewCellDelegate: class {
    // Delegate method for button actions- acceptand and ignore
    func requestTableViewCellDidAccept(_ sender: RequestsTableViewCell)
    func requestTableViewCellDidIgnore(_ sender: RequestsTableViewCell)
}

class RequestsTableViewCell: UITableViewCell {

    // Weak variable outlets
    @IBOutlet weak var acceptRequestButton: UIButton!
    @IBOutlet weak var ignoreRequestButton: UIButton!
    @IBOutlet weak var requestedNameLabel: UILabel!
    
    // Adds a delegate property to RequestsTableViewCell class
    weak var delegate: RequestsTableViewCellDelegate?
    
    // Accept button tapped
    @IBAction func acceptedRequest(_ sender: UIButton) {
        delegate?.requestTableViewCellDidAccept(self)
    }

    // Ignore button tapped
    @IBAction func ignoredRequest(_ sender: UIButton) {
        delegate?.requestTableViewCellDidIgnore(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
