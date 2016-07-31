//
//  LoginViewController.swift
//  Sorry
//
//  Created by Aniruddh Bharadwaj on 7/30/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    // MARK: - IBAction's
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func aboutButtonDidTouch(sender: UIButton) {
        performSegueWithIdentifier("AboutSegue", sender: sender)
    }
    
    // MARK: - iOS Memory Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
