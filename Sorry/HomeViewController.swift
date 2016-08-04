//
//  HomeViewController.swift
//  Sorry
//
//  Created by Aniruddh Bharadwaj on 7/31/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
import PhoneNumberKit

class HomeViewController: UITableViewController {
    
    /* local variable to hold all contacts */
    var userContacts: [Contact] = []
    
    /* local variable to hold all filtered contacts */
    var filteredUserContacts: [Contact] = []
    
    /* local variable to hold user's phone number */
    var userPhoneNumber: String = ""
    
    // search controller
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    // local array holding flatui background colors
    var flatUIColors: [String] = ["1abc9c", "16a085", "f1c40f", "f39c12", "2ecc71", "27ae60", "e67e22", "d35400", "3498db", "2980b9", "e74c3c", "c0392b", "9b59b6", "8e44ad", "34495e", "2c3e50"]
    
    // MARK: - Basic Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // present alert controller to get user's phone number for twilio api sending
        let phoneNumberAlert = UIAlertController(title: "Phone Number", message: "This app requires your phone number to be able to send text messages using the Twilio SMS API. Please enter your phone number below.", preferredStyle: .Alert)
        phoneNumberAlert.addTextFieldWithConfigurationHandler { (textField) in
            textField.text = "000-000-0000"
        }
        phoneNumberAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.userPhoneNumber = (phoneNumberAlert.textFields![0] as UITextField).text!.stringByReplacingOccurrencesOfString("-", withString: "")
            print(self.userPhoneNumber)
        }))
        self.presentViewController(phoneNumberAlert, animated: true, completion: nil)
        
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
    
    override func viewWillAppear(animated: Bool) {
        // show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        // hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
            cell.contactPrimaryPhoneNumber.text = filteredUserContacts[indexPath.row].contactPrimaryPhoneNumber
            cell.backgroundColor = UIColor(hex: filteredUserContacts[indexPath.row].contactBackgroundColor)
        } else {
            cell.contactName.text = userContacts[indexPath.row].contactName
            cell.contactPrimaryPhoneNumber.text = userContacts[indexPath.row].contactPrimaryPhoneNumber
            cell.backgroundColor = UIColor(hex: userContacts[indexPath.row].contactBackgroundColor)
        }
        
        // set size of labels in cell based on width
        cell.contactName.adjustsFontSizeToFitWidth = true
        cell.contactPrimaryPhoneNumber.adjustsFontSizeToFitWidth = true
        
        // return cell
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // grab this cell's phone number
        let recipientPhoneNumber = (self.tableView.cellForRowAtIndexPath(indexPath) as! ContactTableViewCell).contactPrimaryPhoneNumber.text!
        
        
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
            
            // grab phone number for this instance
            let instanceNumber = eachContact.phoneNumbers[0].value as! CNPhoneNumber
            var instancePrimaryPhoneNumber: String = instanceNumber.valueForKey("digits") as? String ?? "Number unavailable"
            if instancePrimaryPhoneNumber != "Number unavailable" {
                instancePrimaryPhoneNumber = PartialFormatter().formatPartial(instancePrimaryPhoneNumber)
            }
            
            // configure instance
            contactModelInstance.configure(CNContactFormatter.stringFromContact(eachContact, style: .FullName)!, color: flatUIColors[Int(arc4random_uniform(UInt32(flatUIColors.count)))], number: instancePrimaryPhoneNumber)
            
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
