//
//  ViewController.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    var mainViewControllerAfterLogin: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startOAuth1Login()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(sender: AnyObject) {
        startOAuth1Login()
    }
    func startOAuth1Login() {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if let user = user {
                print(user)
//                self.performSegueWithIdentifier("loginSegue", sender: self)
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let menuViewController = sb.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
                let mainViewController = sb.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                menuViewController.mainViewController = mainViewController
                mainViewController.menuViewController = menuViewController

                self.showViewController(mainViewController, sender: self)
            } else {
                print(error)
            }
        }
    }
}

