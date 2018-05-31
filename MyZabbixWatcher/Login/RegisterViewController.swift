//
//  RegisterViewController.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
//    @IBAction func backButtonDidToch(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()

        usernameTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        signupButton.layer.cornerRadius = 5
        signupButton.backgroundColor =  UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        self.view.isUserInteractionEnabled = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        signupButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.20, options: UIViewAnimationOptions(), animations: {
            
            self.signupButton.alpha = 1
            
        }, completion: nil)
        
    }
    
    func setupNav() {
        navigationItem.title = "Register"
    }
    
}
