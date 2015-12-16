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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNav()
    }
    
    func setNav(){
        self.navigationItem.title = "Most Pinned"
        self.navigationController?.navigationBar 
    }
    
}
