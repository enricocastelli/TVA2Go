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
            return "English"
        } else {
            return "Dutch"
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row == 1) {
            //change language to dutch
            print("English")
        } else {
            //change language to english
            print("Dutch")
        }
    }
    
    
    @IBAction func facebook(sender: UIButton) {
        
        let url = NSURL.init(string: "fb://profile/153712604776798")
        if (UIApplication.sharedApplication().canOpenURL(url!)){
       UIApplication.sharedApplication().openURL(url!)
        } 

    }
    
    @IBAction func instagram(sender: UIButton) {
        let url = NSURL.init(string: "instagram://user?username=tv_academy")
        
            UIApplication.sharedApplication().openURL(url!)

    }
    
    @IBAction func twitter(sender: UIButton) {
        let url = NSURL.init(string: "twitter:///user?screen_name=tv_academy_nl")
        if (UIApplication.sharedApplication().canOpenURL(url!)){
            UIApplication.sharedApplication().openURL(url!)
        } else {
            UIApplication.sharedApplication().openURL(NSURL.init(string: "www.twitter.com/tv_academy_nl")!)
        }

    }
    
    
    @IBAction func website(sender: UIButton) {
        let url = NSURL.init(string: "http://tvacademy.nl/")
        UIApplication.sharedApplication().openURL(url!)

    }
    
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    
    @IBAction func forgotPassword(sender: UIButton) {
        let forgot = UIAlertController.init(title: "Reset password.", message: "Type your email address.", preferredStyle: UIAlertControllerStyle.Alert)
        forgot.addTextFieldWithConfigurationHandler(nil)
        forgot.textFields![0].placeholder = "example@mail.com"
        let ok = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                PFUser.requestPasswordResetForEmailInBackground((forgot.textFields![0].text!), block: { (success, error) -> Void in
                    if (success == true) {
                        self.emailSent()
                    } else {
                        self.emailNotSent()
                    }
                })
            
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        forgot.addAction(cancel)
        forgot.addAction(ok)
        self.presentViewController(forgot, animated: true, completion: nil)
    }
    
    
    func emailSent() {
        let emailSent = UIAlertController.init(title: "Check your email.", message: "Follow the instructions to reset your password.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(emailSent, animated: true, completion: nil)
        emailSent.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(alertAction: UIAlertAction!) in
            emailSent.dismissViewControllerAnimated(true, completion: nil)
        }))
        
    }

    func emailNotSent() {
        let emailSent = UIAlertController.init(title: "Oops!", message: "Email not found.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(emailSent, animated: true, completion: nil)
        emailSent.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(alertAction: UIAlertAction!) in
            emailSent.dismissViewControllerAnimated(true, completion: nil)
        }))
        
    }


}
