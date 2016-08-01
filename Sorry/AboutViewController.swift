//
//  AboutViewController.swift
//  Sorry
//
//  Created by Aniruddh Bharadwaj on 7/31/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    // UIApplication.sharedApplication().openURL(NSURL(string: "http://www.google.com")!)

    /* IBAction Functions on About Screen */
    @IBAction func twitterButtonDidTouch(sender: UIButton) {
        // send to twitter page
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.twitter.com/aniruddhbatUSC")!)
    }
    
    @IBAction func linkedinButtonDidTouch(sender: UIButton) {
        // send to linkedin page
        UIApplication.sharedApplication().openURL(NSURL(string: "http://linkedin.com/in/aniruddhbharadwaj")!)
    }
}
