//
//  SideViewController.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {
    var sideViewController: UIViewController = MySideViewController()
    var currentViewController: UIViewController = HomeViewController()
    var currentVCPanEnableRange: CGFloat = 100
    var isSide: Bool = true
    var sideContentOffset : CGFloat = 75
    let ScreenWidth = UIScreen.main.bounds.size.width
    let ScreenHeight = UIScreen.main.bounds.size.height
    
    let button: UIButton = UIButton()
    
    
//    var currentNavController : UINavigationController? {
//        get {
//            return getCurrentNavtion()
//        }
//    }
    
    lazy var beginSidePoint : CGPoint = { [unowned self] in
        var point : CGPoint = self.view.center
        point.x = point.x - self.sideContentOffset / 2;
        return point
        }()
    
    lazy var beginPoint : CGPoint = { [unowned self] in
        var point : CGPoint = self.view.center
        return point
        }()
    
    lazy var viewStartCenterPoint : CGPoint = { [unowned self] in
        var point : CGPoint = self.view.center
        return point
        }()
    
    lazy var tapView : UIView = { [unowned self] in
        var tap_view = UIView()
        tap_view.frame = CGRect(x: 0, y: 0, width: self.ScreenWidth - self.sideContentOffset, height: self.ScreenHeight)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesure(_:)))
        tap_view.addGestureRecognizer(tapGesture)
        tap_view.isHidden = true
        return tap_view
        }()
    
//    init(_ sideMenuViewController: UIViewController, _ currentMainViewController: UIViewController) {
//        sideViewController = sideMenuViewController
//        currentViewController = currentMainViewController
//        currentVCPanEnableRange = 100
//        sideContentOffset = ScreenWidth * 3 / 4
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var tmpVc = MySideViewController()
//        tmpVc.setSuperView(self)
//        sideViewController = tmpVc
        navigationItem.title = "Alerts"
        
        sideContentOffset = ScreenWidth * 3 / 4
        view.backgroundColor = .white
  
        self.addChildViewController(sideViewController)
        sideViewController.view.center = CGPoint(x: view.center.x - (sideContentOffset / 2), y: view.center.y)
        sideViewController.view.bounds = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        view.addSubview(sideViewController.view)
        
        let currentMainVC = UINavigationController(rootViewController: HomeViewController())

        //let navOne = UINavigationController(rootViewController: HomeViewController())
        currentViewController = currentMainVC
        
        
        currentViewController.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        currentViewController.view.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.new , context: nil)
        let panGesure = UIPanGestureRecognizer(target: self, action: #selector(panGesure(_:)))
        currentViewController.view.addGestureRecognizer(panGesure)
        panGesure.delegate = self;
        currentViewController.view.addSubview(tapView)
        view.addSubview(currentViewController.view)
        
        button.frame = CGRect(x:325, y:650, width:50, height:50)
        button.setImage(UIImage(named: "goCluster"), for: .normal)
        
        //button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
        button.setTitle("Go cluster", for: .normal)
        button.addTarget(self, action: #selector(btnClick(sender:)), for:.touchUpInside)
        view.addSubview(button)
    }
    
    @objc func btnClick(sender: UIButton) {
        let controller = UIStoryboard(name: "Cluster", bundle: nil).instantiateViewController(withIdentifier: "ClusterViewController") as! ClusterViewController
        self.navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)

    }
    
    // MARK : - 关闭侧拉菜单
    func closeSideVC() {
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.currentViewController.view.center = self.view.center
            var point = self.view.center
            point.x = point.x - (self.sideContentOffset / 2)
            self.sideViewController.view.center = point
        }) { (isFinished) in
            self.beginPoint = self.currentViewController.view.center
            self.beginSidePoint = self.sideViewController.view.center
        }
    }
    
    // MARK : - 打开侧拉菜单
    func openSideVC() {
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            var point = self.view.center
            point.x = self.viewStartCenterPoint.x + self.sideContentOffset
            self.currentViewController.view.center = point
            self.sideViewController.view.center = self.view.center
        }) { (isFinished) in
            self.beginPoint = self.currentViewController.view.center
            self.beginSidePoint = self.sideViewController.view.center
        }
    }
    
    // MARK : - 手势方法
    @objc func tapGesure(_ tap : UITapGestureRecognizer) {
        closeSideVC()
    }
    
    @objc func panGesure(_ pan : UIPanGestureRecognizer) {
//        guard (isPushViewController() && isSide) else {
//            return
//        }
        let point = pan.velocity(in: currentViewController.view)
        let movePoint = pan.translation(in: currentViewController.view)
        let tabBarCenterPoint = currentViewController.view.center
        if pan.state == UIGestureRecognizerState.changed {
            // 手势滑动时改变侧拉VC和主VC的center
            var tabBarVCCenter = beginPoint
            var sideVCCenter = beginSidePoint
            tabBarVCCenter.x = beginPoint.x + movePoint.x
            sideVCCenter.x = beginSidePoint.x + ((movePoint.x * (sideContentOffset / 2)) / sideContentOffset)
            if tabBarVCCenter.x >= viewStartCenterPoint.x && (viewStartCenterPoint.x + sideContentOffset) >= tabBarVCCenter.x{
                currentViewController.view.center = tabBarVCCenter
                sideViewController.view.center = sideVCCenter
            }else if viewStartCenterPoint.x > tabBarVCCenter.x {
                currentViewController.view.center = view.center
                var point = view.center
                point.x = point.x - (sideContentOffset / 2)
                sideViewController.view.center = point
            }else if tabBarVCCenter.x > (viewStartCenterPoint.x + sideContentOffset) {
                var point = view.center
                point.x = viewStartCenterPoint.x + sideContentOffset
                currentViewController.view.center = point
                sideViewController.view.center = view.center
            }
        }else if pan.state == UIGestureRecognizerState.ended {
            // 根据手势停止的位置决定关闭/开启侧拉VC
            let changeX = fabs(point.x)
            let changeY = fabs(point.y)
            if changeX > changeY && changeX > 50 {
                if point.x > 0 {
                    openSideVC()
                }else {
                    closeSideVC()
                }
            }else {
                if tabBarCenterPoint.x > view.center.x && (view.center.x + (sideContentOffset / 2)) >= tabBarCenterPoint.x {
                    closeSideVC()
                }else if tabBarCenterPoint.x > (view.center.x + sideContentOffset / 2) && (view.center.x + sideContentOffset) >= tabBarCenterPoint.x {
                    openSideVC()
                }
            }
        }
    }

//    func isPushViewController() -> Bool {
//        let arr : Array<UIViewController>? = getCurrentNavtion()?.viewControllers
//        if arr?.count == 1 {
//            return true
//        }else {
//            return false
//        }
//    }
//
//    func getCurrentNavtion() -> UINavigationController? {
//        var currentNavViewController: UINavigationController?
//        if let tabBarViewController = currentViewController as? UITabBarController {
//            var viewControllers = tabBarViewController.viewControllers
//            let navController = viewControllers?[tabBarViewController.selectedIndex]
//            if let navViewController = navController as? UINavigationController {
//                currentNavViewController = navViewController
//            }
//        } else if let navViewController = currentViewController as? UINavigationController {
//            currentNavViewController = navViewController
//        }
//        return currentNavViewController
//    }
}

extension SideViewController: UIGestureRecognizerDelegate {
    
    // MARK : - 手势代理方法
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let beginPointInView = touch.location(in: currentViewController.view)
        if (gestureRecognizer is UIPanGestureRecognizer) && (ScreenHeight - 49) >= beginPointInView.y {
            if beginPointInView.x < currentVCPanEnableRange {
                //return isPushViewController()
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center" {
            if let centerpoint = change?[NSKeyValueChangeKey.newKey] {
                if let centerpointValue = centerpoint as? NSValue {
                    let point = centerpointValue.cgPointValue
                    if point.x == (viewStartCenterPoint.x + sideContentOffset) {
                        tapView.isHidden = false
                    }else {
                        tapView.isHidden = true
                    }
                }
            }
        }
    }
    
}
