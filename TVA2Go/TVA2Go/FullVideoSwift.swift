//
//  FullVideoSwift.swift
//  TVA2Go
//
//  Created by Eyolph on 07/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

import Foundation

var fullVideo = GTLYouTubeVideo()
var parseVideoObject = PFObject()
var playerView = YTPlayerView()
var titleLabel = UILabel()
var dateLabel = UILabel()
var textView = UITextView()

//func viewDidLoad() {
//    playerView.delegate = self
//    if fullVideo {
//        playerView.loadWithVideoId(fullVideo.identifier)
//        titleLabel.text = fullVideo.snippet.title
//        var date = NSDate()
//        date = fullVideo.snippet.publishedAt.date
//        let formatter = NSDateFormatter.init()
//        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        dateLabel.text = formatter.stringFromDate(date)
//        textView.text = fullVideo.snippet.descriptionProperty
//    } else {
//    
//        playerView.loadWithVideoId(parseVideoObject["videoID"])
//        titleLabel.text = parseVideoObject["title"]
//    }
//}
