//
//  MostPinnedSwift.swift
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 12/16/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

import UIKit

@objc class MostPinnedSwift: PFQueryTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "RankingTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.separatorColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
    }

    func createHeader (){
        let header = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil) 
    }
    
}
