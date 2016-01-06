//
//  AllTableViewController.swift
//  TVA2Go
//
//  Created by Eyolph on 16/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

import UIKit

@objc class AllVTableViewController: UITableViewController, UITextFieldDelegate {
    
    var videos : NSMutableArray
    var stringSearch : String
    var searchField : UITextField
    
    override init(style: UITableViewStyle) {
        self.videos = []
        self.stringSearch = " "
        self.searchField = UITextField.init()
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.hidden = true
        tableView.separatorColor = UIColor.clearColor()
        let nib = UINib.init(nibName: "RankingTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.registerClass(RankingTableViewCell.self, forCellReuseIdentifier: "empty")
        stringSearch = " "
        
        TAAYouTubeWrapper.videosForUser("TVAcademyNL") { (success, videos, error) -> Void in
            self.videos = (videos as NSArray).mutableCopy() as! NSMutableArray
            self.tableView.reloadData()
            self.tableView.hidden = false
            
            self.createHeader()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNav()
        
    }
    
    func createHeader(){
        let headerArr = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil) as NSArray
        let header = headerArr.firstObject as! UIView
        header.frame = CGRectMake(0, 0, self.view.frame.size.width, 40)
        self.tableView.tableHeaderView = header
        self.tableView.tableHeaderView?.userInteractionEnabled = true
        let allLabel = header.viewWithTag(4)
        allLabel?.hidden = false
        let myPins = header.viewWithTag(2) as! UIButton
        myPins.addTarget(self, action: "pushMine", forControlEvents: UIControlEvents.TouchUpInside)
        let myPinsLabel = header.viewWithTag(5)
        myPinsLabel?.hidden = true
        let most = header.viewWithTag(3) as! UIButton
        most.addTarget(self, action: "pushMost", forControlEvents: UIControlEvents.TouchUpInside)
        let mostLabel = header.viewWithTag(6)
        mostLabel!.hidden = true
    }
    
    func setNav()   {
        self.navigationItem.title = "All Videos"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.init(name: "OpenSans-Light", size: 22.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let home = UIImage.init(named: "Home")
        let homeButton = UIBarButtonItem.init(image: home, style: UIBarButtonItemStyle.Plain, target: self, action: "home")
        self.navigationItem.leftBarButtonItem = homeButton
        
        let search = UIImage.init(named: "Search")
        let searchButton = UIBarButtonItem.init(image: search, style: UIBarButtonItemStyle.Plain, target: self, action: "search")
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func pushMine() {
        let pin = PinnedSwiftViewController.init(nibName: "PinnedSwiftViewController", bundle: nil)
        let home = HomeViewController()
        self.navigationController?.setViewControllers([home, pin], animated: false)
        self.navigationController?.popToViewController(pin, animated: true)
    }
    
    func pushMost() {
        let most = MostPinnedSwift()
        let home = HomeViewController()
        self.navigationController?.setViewControllers([home, most], animated: false)
        self.navigationController?.popToViewController(most, animated: true)
    }
    
    func search(){
        self.tableView.hidden = true
        searchField = UITextField.init(frame: CGRectMake(0, 0, 130, 30))
        searchField.backgroundColor = UIColor.whiteColor()
        searchField.borderStyle = UITextBorderStyle.RoundedRect
        searchField.placeholder = "Search"
        self.navigationItem.titleView = searchField
        searchField.becomeFirstResponder()
        let searchGo = UIBarButtonItem.init(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "searchGo")
        self.navigationItem.rightBarButtonItem = searchGo
        stringSearch = searchField.text!
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        stringSearch = textField.text!
    }
    
    func searchGo(){
        self.setNav()
        searchField.resignFirstResponder()
        
        TAAYouTubeWrapper.videosForUser("TVAcademyNL") { (success, videos, error) -> Void in
            self.videos = (videos as NSArray).mutableCopy() as! NSMutableArray
        }
        
        var arra : NSMutableArray
        arra = []
        for video in self.videos {
            
            if ((video as? GTLYouTubeVideo)!.snippet.title.lowercaseString.containsString((searchField.text?.lowercaseString)!)) {
                arra.addObject(video)
            }
            
            self.videos = arra
            self.navigationItem.titleView = nil
            tableView.reloadData()
            tableView.hidden = false
        }
    }
    
    
    //MARK: TableView Stuff
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (videos.count == 0) {
            return 1
        } else {
            return videos.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RankingTableViewCell {
        
        if (videos.count == 0) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("empty", forIndexPath: indexPath) as! RankingTableViewCell
            
            cell.textLabel?.text = "NO VIDEOS FOUND"
            self.tableView.allowsSelection = false
            
            return cell
        } else {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RankingTableViewCell
            
            let video = self.videos[indexPath.row] as!GTLYouTubeVideo
            
            cell.titleLabel?.text = video.snippet.title
            let url = NSURL.init(string: video.snippet.thumbnails.standard.url)
//            let data = NSData.init(contentsOfURL: url!)
//            let thumbnail = UIImage.init(data: data!)
            
            cell.imageThumbnail?.sd_setImageWithURL(url)
            cell.imageThumbnail?.loadInBackground()
            cell.pinImage?.alpha = 0
            cell.rankingLabel?.alpha = 0
            
            self.tableView.allowsSelection = true
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let full = FullVideoSwift(nibName:"FullSwiftViewController", bundle: nil)
        full.fullVideo = self.videos[indexPath.row] as? GTLYouTubeVideo
        self.navigationController?.pushViewController(full, animated: true)
    }
}
