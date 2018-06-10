//
//  DemoCell.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class DemoCell: FoldingCell {
    
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    
    @IBOutlet weak var hostNameLabel: UILabel!
    
    @IBOutlet weak var openHostNameLabel: UILabel!
    
    @IBOutlet weak var hostIpLabel: UILabel!
    @IBOutlet weak var hostDnsLabel: UILabel!
    @IBOutlet weak var hostPortLabel: UILabel!
    
    @IBOutlet weak var hostDescriptionLabel: UILabel!
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
            openNumberLabel.text = String(number)
        }
    }
    
    var hostName: String = "Cluster1" {
        didSet {
            hostNameLabel.text = hostName
            openHostNameLabel.text = hostName
        }
    }
    
    var hostIp: String = "127.0.0.1" {
        didSet {
            hostIpLabel.text = hostIp
        }
    }
    
    var hostDns: String = "" {
        didSet {
            hostDnsLabel.text = hostDns
        }
    }
    
    var hostPort: String = "80" {
        didSet {
            hostPortLabel.text = hostPort
        }
    }
    
    var hostDescription = "" {
        didSet {
            hostDescriptionLabel.text = hostDescription
        }
    }
    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

extension DemoCell {
    
    @IBAction func buttonHandler(_: AnyObject) {
        let controller = UIStoryboard(name: "Hosts", bundle: nil).instantiateViewController(withIdentifier: "HostViewController") as! HostViewController
        
        let tableView = superTableView()
        let tableViewController = tableView?.parentViewController() as! UINavigationController
        
        tableViewController.pushViewController(controller, animated: true)

    }
}

