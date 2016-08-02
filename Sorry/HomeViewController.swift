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
    var userContacts: [Contact] = []
    
    // local array holding flatui background colors
    var flatUIColors: [String] = ["1abc9c", "16a085", "f1c40f", "f39c12", "2ecc71", "27ae60", "e67e22", "d35400", "3498db", "2980b9", "e74c3c", "c0392b", "9b59b6", "8e44ad", "34495e", "2c3e50"]
    
    // MARK: - On Load Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // set title of navigation bar to 'Contacts'
        self.title = "Contacts"
        
        // set seperator style to none
        self.tableView.separatorStyle = .None
        
        // populate the view
        populateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView DataSource Functions
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userContacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ContactTableViewCell {
        // declare cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactTableViewCell
        
        // set cell name
        cell.contactName.text = userContacts[indexPath.row].contactName
        
        // set cell color
        cell.backgroundColor = UIColor(hex: userContacts[indexPath.row].contactBackgroundColor)
        
        // return cell
        return cell
    }
    
    // MARK: - Custom Functions
    
    func populateView() {
        // show loading animation
        self.view.showLoading()
        
        // declare local cncontacts array (to be converted into local model)
        var localUserContacts: [CNContact] = []
        
        // declare set of keys to grab within contacts
        let contactKeys = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactThumbnailImageDataKey]
        
        // grab all contact containers on phone
        var allContactContainers: [CNContainer] = []
        do {
            allContactContainers = try CNContactStore().containersMatchingPredicate(nil)
        } catch {
            print("Error retrieving contact containers")
        }
        
        // iterate over all containers
        for eachContainer in allContactContainers {
            // find container id for this container
            let contactContainerID = eachContainer.identifier
            
            // construct predicate for this container
            let contactContainerPredicate = CNContact.predicateForContactsInContainerWithIdentifier(contactContainerID)
            
            // get contacts form this container and append to overall array
            do {
                let containerContacts = try CNContactStore().unifiedContactsMatchingPredicate(contactContainerPredicate, keysToFetch: contactKeys)
                localUserContacts.appendContentsOf(containerContacts)
            } catch {
                print("Error retriving contacts from this container")
            }
        }
        
        // convert each entry from the localUserContacts into the Contact model
        for eachContact in localUserContacts {
            // declare contact model
            let contactModelInstance: Contact = Contact()
            
            // configure instance
            contactModelInstance.configure(CNContactFormatter.stringFromContact(eachContact, style: .FullName)!, color: flatUIColors[Int(arc4random_uniform(UInt32(flatUIColors.count)))])
            
            // append to global scope array
            userContacts.append(contactModelInstance)
        }
        
        // hide loading animation
        self.view.hideLoading()
    }
}
