//
//  InfoViewController.swift
//  TVA2Go
//
//  Created by Eyolph on 10/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

import UIKit




class InfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var facebookButton: UIButton!

    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    weak var dataSource: UIPickerViewDataSource?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePicker.delegate = self
        languagePicker.dataSource = self
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false;
        let home = UIImage.init(named:"Home")
        let homeButton = UIBarButtonItem.init(image: home, style: UIBarButtonItemStyle.Plain, target: self, action:"home")
        self.navigationItem.leftBarButtonItem = homeButton
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String?
    {
        if (row == 1) {
            return "Dutch"
        } else {
            return "English"
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row == 1) {
            //change language to dutch
            print("dutch")
        } else {
            //change language to english
            print("english")
        }
    }
    
    
    @IBAction func facebook(sender: UIButton) {
        
        let url = NSURL.init(string: "fb://profile/153712604776798")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func instagram(sender: UIButton) {
        let url = NSURL.init(string: "instagram://user?username=tv_academy")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func twitter(sender: UIButton) {
        let url = NSURL.init(string: "twitter:///user?screen_name=tv_academy_nl")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    @IBAction func website(sender: UIButton) {
        let url = NSURL.init(string: "http://tvacademy.nl/")
        UIApplication.sharedApplication().openURL(url!)

    }
    
    
    
    
    
    
    
    



}
