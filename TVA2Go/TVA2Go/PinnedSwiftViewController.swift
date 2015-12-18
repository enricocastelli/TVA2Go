//
//  PinnedSwiftViewController.swift
//  TVA2Go
//
//  Created by Eyolph on 17/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

import Foundation

@objc class PinnedSwiftViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var pinned : UICollectionView!
    var array : NSMutableArray
    var videos : NSArray
    var user : PFUser
    var query : PFQuery?
    var deleting : String
    var playImage : UIImageView?
    var deleteImage : UIImageView?
    @IBOutlet var headerView : UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        array  = []
        videos = []
        deleting = ""
        self.user = PFUser.currentUser()!
        query = nil
        self.playImage = nil
        self.deleteImage = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backImage = UIImage.init(named:"background")
        let background = UIImageView.init(image: backImage)
        background.alpha = 0.05
        pinned.backgroundView = background
        self.deleting = "NO"
        self.setCollectionView()
        self.setObjects()
        self.createHeader()
        
        self.view.backgroundColor = self.pinned.backgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setNav()
    }
    
 
    func createHeader(){
        let headerArr = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil) as NSArray
        let header = headerArr.firstObject as! UIView
        self.headerView.addSubview(header)
      
        let allButton = header.viewWithTag(1) as! UIButton
        allButton.addTarget(self, action: "pushAll", forControlEvents: UIControlEvents.TouchUpInside)
        let allLabel = header.viewWithTag(4)
        allLabel?.hidden = true
        let myPinsLabel = header.viewWithTag(5)
        myPinsLabel?.hidden = false
        let most = header.viewWithTag(3) as! UIButton
        most.addTarget(self, action: "pushMost", forControlEvents: UIControlEvents.TouchUpInside)
        let mostLabel = header.viewWithTag(6)
        mostLabel!.hidden = true
    }
    
    func setCollectionView() {
        self.pinned.registerNib(UINib.init(nibName: "PinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.pinned.delegate = self
        self.pinned.allowsMultipleSelection = false
        self.pinned.allowsSelection = true
    }
    
    func setNav() {
        self.navigationItem.title = "My Pins"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.init(name: "OpenSans-Light", size: 22.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let home = UIImage.init(named: "Home")
        let homeButton = UIBarButtonItem.init(image: home, style: UIBarButtonItemStyle.Plain, target: self, action: "home")
        self.navigationItem.leftBarButtonItem = homeButton
        
        let editButton = UIBarButtonItem.init(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "edit")
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    
    func setObjects() {
        self.user = PFUser.currentUser()!
        self.user.fetchInBackgroundWithBlock { (object, error) -> Void in
            self.array = self.user["pinnedVideos"] as! NSMutableArray
            self.query = PFQuery.init(className: "Video")
            self.query!.whereKey("videoID", containedIn: self.array as [AnyObject])
            self.query!.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                let objectsArray = objects! as NSArray
                
                self.videos = objectsArray.sortedArrayUsingComparator{
                    (obj1, obj2) -> NSComparisonResult in
                    let object1 = obj1 as! PFObject
                    let object2 = obj2 as! PFObject
                    let one = self.array.indexOfObject(object1["videoID"])
                    let two = self.array.indexOfObject(object2["videoID"])
                    
                    if one>two {
                        return NSComparisonResult.OrderedDescending
                    } else {
                        return NSComparisonResult.OrderedAscending
                    }
                }
                self.pinned.reloadData()
            })
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    
    func createCell(cell: PinCollectionViewCell, atIndex indexPath:NSIndexPath) -> UICollectionViewCell
    {
        cell.thumbnail?.file = self.videos[indexPath.row]["thumbnail"] as? PFFile
        cell.thumbnail!.layer.cornerRadius = 10
        cell.thumbnail?.clipsToBounds = true
        cell.thumbnail?.loadInBackground()

        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.pinned.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PinCollectionViewCell
        
        if self.deleting == "YES" {
            self.dancingCells()
            cell.deleteImage?.hidden = false
            cell.playImage?.hidden = true
        } else {
            self.stopDancing()
            cell.deleteImage?.hidden = true
            cell.playImage?.hidden = false
        }

        self.createCell(cell, atIndex: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let full = FullVideoSwift.init(nibName:"FullSwiftViewController", bundle:nil)
        
        if self.deleting == "NO" {
            let selected = self.videos[indexPath.row] as! PFObject
            full.parseVideoObject = selected
            self.navigationController?.pushViewController(full, animated: true)
        } else {
            self.pinned.allowsSelection = false
            let cellToDelete = self.pinned.cellForItemAtIndexPath(indexPath)
            
            let act = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            act.frame = CGRectMake(30, 30, 32, 32)
            cellToDelete?.addSubview(act)
            act.startAnimating()
            self.array.removeObjectAtIndex(indexPath.row)
            self.user.setObject(self.array.copy(), forKey: "pinnedVideos")
            self.user.saveInBackgroundWithBlock({ (succeded, error) -> Void in
                if succeded == true {
                    UIView.animateWithDuration(0.6, animations: { () -> Void in
                        cellToDelete?.alpha = 0
                    })
                 self.pinned.deleteItemsAtIndexPaths([indexPath])
                    self.pinned.reloadData()
                    self.dancingCells()
                    self.pinned.allowsSelection = true
                }
            })
        }
    }
    
    
    func edit() {
        if self.deleting == "NO" {
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.deleting = "YES"
            self.dancingCells()
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.deleting = "NO"
            self.stopDancing()
        }
    }
    
    func dancingCells() {
        for cell in self.pinned.visibleCells() {
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [.Autoreverse, .Repeat, .AllowUserInteraction], animations: { () -> Void in
                cell.transform = CGAffineTransformMakeRotation(0.02)
                cell.transform = CGAffineTransformMakeRotation(-0.02)
                }, completion: nil)
            (cell as! PinCollectionViewCell).deleteImage?.hidden = false
            (cell as! PinCollectionViewCell).playImage?.hidden = true
        }
    }
    
    func stopDancing() {
        for cell in self.pinned.visibleCells() {
            cell.transform = CGAffineTransformMakeRotation(0)
            cell.layer.removeAllAnimations()
            (cell as! PinCollectionViewCell).deleteImage?.hidden = true
            (cell as! PinCollectionViewCell).playImage?.hidden = false
        }
    }
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func pushAll() {
        let all = AllVTableViewController.init(style: UITableViewStyle.Plain)
        let home = HomeViewController.init()
        self.navigationController?.setViewControllers([home, all], animated: false)
        self.navigationController?.popToViewController(all, animated: true)
    }
    
    func pushMost() {
        let most = MostPinnedTableViewController.init()
        let home = HomeViewController.init()
        self.navigationController?.setViewControllers([home, most], animated: false)
        self.navigationController?.popToViewController(most, animated: true)
    }

    
    
    
    
    
}
