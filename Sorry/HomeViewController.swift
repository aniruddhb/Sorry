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
    
    /* local variable to hold all filtered contacts */
    var filteredUserContacts: [Contact] = []
    
    // search controller
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    // local array holding flatui background colors
    var flatUIColors: [String] = ["1abc9c", "16a085", "f1c40f", "f39c12", "2ecc71", "27ae60", "e67e22", "d35400", "3498db", "2980b9", "e74c3c", "c0392b", "9b59b6", "8e44ad", "34495e", "2c3e50"]
    
    // MARK: - On Load Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // set title of navigation bar to 'Contacts'
        self.title = "Contacts"
        
        // remove seperators for tableview
        self.tableView.separatorStyle = .None
        
        // define parameters for searchcontroller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        // populate the view
        populateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Functions
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if search field is active and non-empty, return number of filtered contacts
        if searchController.active && searchController.searchBar.text != "" {
            return filteredUserContacts.count
        }
        
        // otherwise, return number of friends
        return userContacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ContactTableViewCell {
        // declare cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactTableViewCell
        
        // if user isn't searching, return data from full array, but if user is, return from filtered list
        if searchController.active && searchController.searchBar.text != "" {
            cell.contactName.text = filteredUserContacts[indexPath.row].contactName
            cell.backgroundColor = UIColor(hex: filteredUserContacts[indexPath.row].contactBackgroundColor)
        } else {
            cell.contactName.text = userContacts[indexPath.row].contactName
            cell.backgroundColor = UIColor(hex: userContacts[indexPath.row].contactBackgroundColor)
        }
        
        // set cell name
        cell.contactName.text = userContacts[indexPath.row].contactName
        
        // set size of label in cell based on width
        cell.contactName.adjustsFontSizeToFitWidth = true
        
        // set cell color
        cell.backgroundColor = UIColor(hex: userContacts[indexPath.row].contactBackgroundColor)
        
        // return cell
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // deselect row once it has been selected
        self.tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
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
            contactModelInstance.configure(CNContactFormatter.stringFromContact(eachContact, style: .FullName)!, color: flatUIColors[Int(arc4random_uniform(UInt32(flatUIColors.count)))], number: (eachContact.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("digits") as? String ?? "No number on record")
            
            // append to global scope array
            userContacts.append(contactModelInstance)
        }
        
        // hide loading animation
        self.view.hideLoading()
    }
    
    // MARK: - Search Controller Function
    
    func filterContactContent(searchText: String, scope: String = "ALL") {
        // filter contact content into filtered list
        filteredUserContacts = userContacts.filter({ (thisContact: Contact) -> Bool in
            return thisContact.contactName.lowercaseString.containsString(searchText.lowercaseString)
        })
        
        // reload tableview
        self.tableView.reloadData()
    }
}

/* class extensions for search feature */
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContactContent(searchController.searchBar.text!)
    }
}
