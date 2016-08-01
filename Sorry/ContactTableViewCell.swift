//
//  ContactTableViewCell.swift
//  Sorry
//
//  Created by Aniruddh Bharadwaj on 7/31/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    /* IBAction's for each custom cell */
    @IBOutlet weak var contactName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
