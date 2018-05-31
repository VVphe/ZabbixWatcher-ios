//
//  HomeViewController.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class HomeViewController:  UIViewController {
    
    static let ROOTTABLEVIEWCELLIDENTIFIER = "ROOTTABLEVIEWCELLIDENTIFIER"
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Alerts"
        view.backgroundColor = .white
        view.addSubview(rootTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    lazy var rootTableView : UITableView = { [unowned self] in
        var tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: HomeViewController.ROOTTABLEVIEWCELLIDENTIFIER)
        return tableView
        }()
    lazy var timeArray: [String] = {
        var array = ["2018-5-25", "2018-5-26", "2018-5-27", "2018-5-28", "2018-5-29", "2018-5-30"]
        return array
    }()
    lazy var titleArray : [String] = {
        var array = ["ubuntu3 内存不足", "ubuntu2 磁盘容量不足5%", "ubuntu4 出流量过大", "ubuntu5 inode空间不足", "ubuntu1 cpu占用过高", "ubuntu6 内存不足"]
        return array
    }()
    let imageArray : [String] = {
        let array = ["yewan", "shan", "feng", "chang", "fushi", "haidi"]
        return array
    }()
    
    
//    let kCloseCellHeight: CGFloat = 179
//    let kOpenCellHeight: CGFloat = 488
//    let kRowsCount = 10
//    var cellHeights: [CGFloat] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        setup()
//    }
//
//    private func setup() {
//        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
//        tableView.estimatedRowHeight = kCloseCellHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
//        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
//        if #available(iOS 10.0, *) {
//            tableView.refreshControl = UIRefreshControl()
//            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
//        }
//    }
//
//    @objc func refreshHandler() {
//        let deadlineTime = DispatchTime.now() + .seconds(1)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
//            if #available(iOS 10.0, *) {
//                self?.tableView.refreshControl?.endRefreshing()
//            }
//            self?.tableView.reloadData()
//        })
//    }
}

// MARK -- TableView Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.ROOTTABLEVIEWCELLIDENTIFIER, for: indexPath)
        
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.timeArray[indexPath.row] + "\n" + self.titleArray[indexPath.row]
        cell.imageView?.image = UIImage(named: self.imageArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let otherVC = OtherViewController()
//        otherVC.title = titleArray[indexPath.row]
//        self.navigationController?.pushViewController(otherVC, animated: true)
//    }
}

//extension HomeViewController {
//
//    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
//        return 10
//    }
//
//    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard case let cell as DemoCell = cell else {
//            return
//        }
//
//        cell.backgroundColor = .clear
//        
//        if cellHeights[indexPath.row] == kCloseCellHeight {
//            cell.unfold(false, animated: false, completion: nil)
//        } else {
//            cell.unfold(true, animated: false, completion: nil)
//        }
//        
//        cell.number = indexPath.row
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.register(DemoCell.self, forCellReuseIdentifier: "FoldingCell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
//        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
//        cell.durationsForExpandedState = durations
//        cell.durationsForCollapsedState = durations
//        return cell
//    }
//    
//    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellHeights[indexPath.row]
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
//
//        if cell.isAnimating() {
//            return
//        }
//        
//        var duration = 0.0
//        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
//        if cellIsCollapsed {
//            cellHeights[indexPath.row] = kOpenCellHeight
//            cell.unfold(true, animated: true, completion: nil)
//            duration = 0.5
//        } else {
//            cellHeights[indexPath.row] = kCloseCellHeight
//            cell.unfold(false, animated: true, completion: nil)
//            duration = 0.8
//        }
//        
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }, completion: nil)
//    }
//}
