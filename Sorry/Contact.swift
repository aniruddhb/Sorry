//
//  Contact.swift
//  Sorry
//
//  Created by Aniruddh Bharadwaj on 8/1/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import Foundation

class Contact {
    /* model for each contact. currently
       contains 3 different properties.
       name and background color */
    
    var contactName: String = ""
    
    var contactBackgroundColor: String = ""
    
    var contactPrimaryPhoneNumber: String = ""
    
    func configure(name: String, color: String) {
        contactName = name
        contactBackgroundColor = color
    }
}
