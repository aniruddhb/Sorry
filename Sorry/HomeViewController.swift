//
//  HomeViewController.swift
//  Sorry
//
//  Created by Aniruddh Bharadwaj on 7/31/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit
import Contacts

class HomeViewController: UITableViewController {
    
    /* local variable to hold all contacts */
    var userContacts: [CNContact] = [CNContact]()
    
    // MARK: - On Load Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // set title of navigation bar to 'Contacts'
        self.title = "Contacts"
        
        // populate the view
        populateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Functions
    
    func populateView() {
        // show loading animation
        self.view.showLoading()
        
        // declare contact store from db
        let contactStore = CNContactStore()
        
        // define keys to fetch
        let contactProperties = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactThumbnailImageDataKey]
        
        // get all contact containers
        var allContactContainers: [CNContainer] = []
        do {
            allContactContainers = try contactStore.containersMatchingPredicate(nil)
        } catch {
            print("Error - could not fetch containers")
        }
        
        // iterate through containers and append contacts to total array
        for contactContainer in allContactContainers {
            // define the predicate for this container
            let contactPredicate = CNContact.predicateForContactsInContainerWithIdentifier(contactContainer.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContactsMatchingPredicate(contactPredicate, keysToFetch: contactProperties)
                self.userContacts.appendContentsOf(containerResults)
            } catch {
                print("Error fetching contacts for this container")
            }
        }
        
        // hide loading animation
        self.view.hideLoading()
    }
}
