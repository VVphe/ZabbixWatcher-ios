//
//  RegisterViewController.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class RegisterViewController: UIViewController {
    
//    @IBAction func backButtonDidToch(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
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
    
    @IBAction func register(_ sender: UIButton) {
        if usernameTextField.text as! String == "" {
            Toast(text: "Username cannot be empty").show()
            return
        }
        if passwordTextField.text as! String == "" {
            Toast(text: "Password cannot be empty").show()
            return
        }
        if confirmTextField.text as! String == "" {
            Toast(text: "Please confirm your password").show()
            return
        }
        if passwordTextField.text as! String != confirmTextField.text as! String {
            Toast(text: "Please reconfirm your password").show()
            return
        }
        let params: Parameters = ["username": usernameTextField.text as! String, "password": passwordTextField.text as! String]
        Alamofire.request("http://127.0.0.1:8080/register", method: .get, parameters: params).responseString {
            response in
            switch(response.result.value!) {
            case "exist":
                Toast(text: "Username has been registered").show()
            case "success":
                Toast(text: "Register success").show()
            default:
                Toast(text: "Register fail").show()
            }
        }
    }
}
