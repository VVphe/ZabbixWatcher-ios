//
//  ViewController.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit


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
        
        let videoPath = Bundle.main.path(forResource: "spotify", ofType: "mp4")
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
        let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! SideViewController
        //self.navigationController?.pushViewController(controller, animated: true)
//        let controller = UIStoryboard(name: "Cluster", bundle: nil).instantiateViewController(withIdentifier: "ClusterViewController") as! ClusterViewController
        //self.present(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
