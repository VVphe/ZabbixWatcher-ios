//
//  ViewController.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class LoginViewController: VideoSplashViewController{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoBackground()
        setupNav()
        
        usernameTextField.placeholder = "username"
        passwordTextField.placeholder = "password"
        
        //MARK: 圆角半径
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor.green
        signupButton.layer.cornerRadius = 5
        signupButton.backgroundColor = UIColor.white
        self.view.isUserInteractionEnabled = true
        
        //signupButton.addTarget(self, action: #selector(goRegister(sender:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(goHomePage(sender:)), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupNav() {
        navigationItem.title = "Login"
    }
    
    func setupVideoBackground() {
        
        let videoPath = Bundle.main.path(forResource: "mainbg", ofType: "mp4")
        print(videoPath)
        let videoUrl = URL(fileURLWithPath: videoPath!)
        
        videoFrame = view.frame
        fillMode = ScalingMode.resizeAspectFill
        alwaysRepeat = true
        sound = false
        startTime = 2.0
        alpha = 0.8
        
        contentURL = videoUrl
        view.isUserInteractionEnabled = false
    }
    
    @objc func goHomePage(sender: UIButton) {
        let params: Parameters = ["username": usernameTextField.text as! String, "password": passwordTextField.text as! String]
        Alamofire.request("http://127.0.0.1:8080/login", method: .get, parameters: params).responseString {
            response in
            switch(response.result.value!) {
            case "success":
                Toast(text: "Login success").show()
                let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! SideViewController
                //self.navigationController?.pushViewController(controller, animated: true)
                //        let controller = UIStoryboard(name: "ClusterAdd", bundle: nil).instantiateViewController(withIdentifier: "ClusterAddViewController") as! ClusterAddViewController
                //self.present(controller, animated: true, completion: nil)
                self.navigationController?.pushViewController(controller, animated: true)
            case "none":
                Toast(text: "No such user").show()
            case "wrongPassword":
                Toast(text: "Wrong password").show()
            default:
                Toast(text: "Login failed").show()
            }
        }
        
        
    }
    
}
