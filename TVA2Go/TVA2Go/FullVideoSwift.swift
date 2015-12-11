//
//  FullVideoSwift.swift
//  TVA2Go
//
//  Created by Eyolph on 07/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

import Foundation
@objc class FullVideoSwift : UIViewController, YTPlayerViewDelegate {
    
    var fullVideo : GTLYouTubeVideo?
    var parseVideoObject : PFObject?
    var user : PFUser?
    @IBOutlet var playerView : YTPlayerView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var textView : UITextView!
    @IBOutlet weak var pin: UIButton!

override func viewDidLoad() {
    playerView?.delegate = self
     self.user = PFUser.currentUser()
    self.pin.alpha = 1

    self.navigationItem.title = "TVA2Go"
    self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.init(name: "OpenSans-Light", size: 22.0)! ,NSForegroundColorAttributeName : UIColor.whiteColor()]
        pin.layer.cornerRadius = pin.frame.size.width/2
    let home = UIImage.init(named:"Home")
    let homeButton = UIBarButtonItem.init(image: home, style: UIBarButtonItemStyle.Plain, target: self, action:"home")
    self.navigationItem.rightBarButtonItem = homeButton
    self.detectVideo()
}
    
    
    func detectVideo() {
        if (fullVideo != nil) {
            playerView.loadWithVideoId(fullVideo!.identifier)
            titleLabel.text = fullVideo!.snippet.title
            let date = fullVideo!.snippet.publishedAt.date
            let formatter = NSDateFormatter.init()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateLabel.text = formatter.stringFromDate(date)
            textView.text = fullVideo!.snippet.descriptionProperty
            self.userGTL()
        } else {
            let videoID = parseVideoObject!["videoID"] as! String
            playerView.loadWithVideoId(videoID)
            titleLabel.text = parseVideoObject!["title"] as? String
            let date = parseVideoObject!["youtubeDate"] as? NSDate
            let formatter = NSDateFormatter.init()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateLabel.text = formatter.stringFromDate(date!)
            textView.text = parseVideoObject!["description"] as? String
            self.userParse()
        }
    }
    
    
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        playerView!.playVideo()
    }
    
    override func viewWillDisappear(animated: Bool) {
        playerView!.stopVideo()
    }
    
    
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    

    
    @IBAction func pinVideo(sender: UIButton) {
        if (fullVideo == nil){
        if (user!["pinnedVideos"].containsObject(parseVideoObject!["videoID"])){
            
            print("Already Pinned")
        } else {
            let userArray = user!["pinnedVideos"].mutableCopy()
            userArray.addObject(parseVideoObject!["videoID"])
            user?.setObject(userArray.copy(), forKey: "pinnedVideos")
            user?.saveInBackgroundWithBlock({ (success, error) -> Void in
                self.pin.enabled = false
                self.pin.alpha = 0.4

            })
            
        }
        } else {
            if (user!["pinnedVideos"].containsObject(fullVideo!.identifier)){
                
                print("Already Pinned")
            } else {
                let userArray = user!["pinnedVideos"].mutableCopy()
                userArray.addObject(fullVideo!.identifier)
                user?.setObject(userArray.copy(), forKey: "pinnedVideos")
                user?.saveInBackgroundWithBlock({ (success, error) -> Void in
                    self.pin.enabled = false
                    self.pin.alpha = 0.4

                })
                
            }

            
            
        }
    }
    
    func userGTL(){
        if (user == nil) {
            self.pin.enabled = false
            self.pin.alpha = 0.4

        } else {
        
        if (user!["pinnedVideos"].containsObject(fullVideo!.identifier)){
            self.pin.enabled = false
            self.pin.alpha = 0.4

        }
            self.pin.enabled = true

    }
    }
    
    
    func userParse() {
        if (user == nil) {
            self.pin.enabled = false
            self.pin.alpha = 0.4

            
        } else {
            
        if (user!["pinnedVideos"].containsObject(parseVideoObject!["videoID"])){
            self.pin.enabled = false
            self.pin.alpha = 0.4

        }
            self.pin.enabled = true
        }
    }
    
    
    
    
    
    
    
}