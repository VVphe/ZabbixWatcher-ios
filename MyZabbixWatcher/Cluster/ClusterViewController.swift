//
//  ClusterViewController.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClusterViewController: UITableViewController {
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    
    var addBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Clusters"
        setup()
        
        //add button
        addBtn = UIButton()
        addBtn?.frame = CGRect(x:320, y: 600, width:50, height:50)
        addBtn?.layer.masksToBounds = true
        addBtn?.layer.cornerRadius = (addBtn?.frame.width)! / 2
        addBtn?.setImage(UIImage(named: "plus"), for: .normal)
        addBtn?.addTarget(self, action: #selector(btnClick(sender:)), for:.touchUpInside)
        tableView?.addSubview(addBtn!)
    }
    //
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.yellow
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    //
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

extension ClusterViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 3
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
        
        if let dataFromString = ClusterData.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            print(json![indexPath.row]["name"])
            cell.hostName = json![indexPath.row]["name"].stringValue
            cell.hostIp = json![indexPath.row]["ip"].stringValue
            cell.hostPort = json![indexPath.row]["port"].stringValue
            cell.hostDns = json![indexPath.row]["dns"].stringValue
            cell.hostDescription = json![indexPath.row]["description"].stringValue
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.register(DemoCell.self, forCellReuseIdentifier: "FoldingCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            print("delete")
        }
        
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }

}

extension ClusterViewController {
    @objc func btnClick(sender: UIButton) {
        let controller = UIStoryboard(name: "ClusterAdd", bundle: nil).instantiateViewController(withIdentifier: "ClusterAddViewController") as! ClusterAddViewController
        self.navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
        
    }
}
