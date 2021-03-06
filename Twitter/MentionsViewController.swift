//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Ji Oh Yoo on 2/26/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetTableViewCellDelegate {
    var tweets: [Tweet]?

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutTouchUpInside(sender: AnyObject) {
        User.currentUser?.logout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshOnly", name: tweetDidPostNotification, object: nil)
        refreshOnly()
        // Do any additional setup after loading the view.
    }
    func refreshOnly() {
        TwitterClient.sharedInstance.mentionsTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.mentionsTimelineWithParams(nil) { (tweets, error) -> () in
            print(error)
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as! TweetTableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didTapProfileImage value: User) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.user = value
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        print("herer", value)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TweetDetailViewController {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            vc.tweet = self.tweets![indexPath!.row]
        } 
    }
}
