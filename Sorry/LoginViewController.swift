//
//  LoginViewController.swift
//  Sorry
//
//  Created by Aniruddh Bharadwaj on 7/30/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    // MARK: - IBAction's
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        // sign in via google
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func aboutButtonDidTouch(sender: UIButton) {
        // perform segue to about screen
        performSegueWithIdentifier("AboutSegue", sender: sender)
    }
    
    // MARK: - iOS Memory Methods with Basic Google SignIn Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // initialize google sign in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Google SignIn Functions (conforming to protocol)
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,UIApplicationOpenURLOptionsAnnotationKey: annotation]
        
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error == nil {
            // segue to the home-screen (tableview)
            performSegueWithIdentifier("HomeSegue", sender: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        // TODO: Disconnect User from App
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
