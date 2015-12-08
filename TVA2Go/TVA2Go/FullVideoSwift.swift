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
    @IBOutlet var playerView : YTPlayerView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var textView : UITextView!

override func viewDidLoad() {
    playerView?.delegate = self
    let home = UIImage.init(named:"Home")
    let homeButton = UIBarButtonItem.init(image: home, style: UIBarButtonItemStyle.Plain, target: self, action:"home")
    self.navigationItem.rightBarButtonItem = homeButton
    if (fullVideo != nil) {
        playerView.loadWithVideoId(fullVideo!.identifier)
        titleLabel.text = fullVideo!.snippet.title
        let date = fullVideo!.snippet.publishedAt.date
        let formatter = NSDateFormatter.init()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateLabel.text = formatter.stringFromDate(date)
        textView.text = fullVideo!.snippet.descriptionProperty
    } else {
        let videoID = parseVideoObject!["videoID"] as! String
        playerView.loadWithVideoId(videoID)
        titleLabel.text = parseVideoObject!["title"] as? String
        let date = parseVideoObject!["youtubeDate"] as? NSDate
        let formatter = NSDateFormatter.init()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateLabel.text = formatter.stringFromDate(date!)
        textView.text = parseVideoObject!["description"] as? String
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}