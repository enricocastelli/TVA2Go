//
//  MostPinnedSwift.swift
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 12/16/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

import UIKit

@objc class MostPinnedSwift: PFQueryTableViewController {
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: "Video")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Video")
        query.orderByDescending("pinCount")
        return query
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "RankingTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.separatorColor = UIColor.clearColor()
        
        self.createHeader()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNav()
    }

    func createHeader (){
        let headerArr = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil) as NSArray
        let header = headerArr.firstObject as! UIView
        header.frame = CGRectMake(0, 0, self.view.frame.size.width, 25)
        self.tableView.tableHeaderView = header
        self.tableView.tableHeaderView?.userInteractionEnabled = true
        
        let allButton = header.viewWithTag(1) as! UIButton
        allButton.addTarget(self, action: "allVideos", forControlEvents: UIControlEvents.TouchUpInside)
        
        let allLabel = header.viewWithTag(4)
        allLabel?.hidden = true
        
        let mineButton = header.viewWithTag(2) as! UIButton
        mineButton.addTarget(self, action: "pushMine", forControlEvents: UIControlEvents.TouchUpInside)
        
        let mineLabel = header.viewWithTag(5)
        mineLabel?.hidden = true
        
        let mostLabel = header.viewWithTag(6)
        mostLabel?.hidden = false
        
    }
    

    
    func setNav(){
        self.navigationItem.title = "Most Pinned"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.init(name: "OpenSans-Light", size: 22.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let home = UIImage.init(named: "Home")
        let homeButton = UIBarButtonItem.init(image: home, style: UIBarButtonItemStyle.Plain, target: self, action: "home")
        self.navigationItem.rightBarButtonItem = homeButton
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RankingTableViewCell
        
        if (object!["thumbnail"]).isKindOfClass(PFFile) {
            cell.imageThumbnail?.hidden = false;
            cell.imageThumbnail?.file = object!["thumbnail"] as? PFFile
            cell.imageThumbnail?.loadInBackground()
        } else {
            cell.imageThumbnail?.image = nil
            cell.imageThumbnail?.hidden = true
        }
        
        cell.titleLabel?.text = object!["title"] as? String
        cell.rankingLabel?.text = "\(object!["pinCount"])"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell 
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let f = FullVideoSwift(nibName:"FullSwiftViewController", bundle:nil)
        f.parseVideoObject = self.objects?[indexPath.row] as? PFObject
        self.navigationController?.pushViewController(f, animated: true)
    }
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func pushMine() {
        let pin = PinnedSwiftViewController()
        let home = HomeViewController()
        self.navigationController?.setViewControllers([home, pin], animated: false)
        self.navigationController?.popToViewController(pin, animated: true)
    }
    
    func allVideos() {
        let full = AllVTableViewController.init(style: UITableViewStyle.Plain)
        let home = HomeViewController()
        self.navigationController?.setViewControllers([home, full], animated: false)
        self.navigationController?.popToViewController(full, animated: true)
    }
}
