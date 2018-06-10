//
//  CardCell.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/1.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var hostIdLabel: UILabel!
    
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostDecriptionLabel: UILabel!
    
    @IBOutlet weak var hostStatusLabel: UILabel!
    @IBOutlet weak var hostErrorLabel: UILabel!
    @IBOutlet weak var hostGroupLabel: UILabel!
    @IBOutlet weak var hostAvailableLabel: UILabel!
    
    var id = "0" {
        didSet {
            idLabel.text = id
        }
    }
    
    var hostId = "10000" {
        didSet {
            hostIdLabel.text = hostId
        }
    }
    
    var hostName = "Host1" {
        didSet {
            hostNameLabel.text = hostName
        }
    }
    
    var hostDecription = "zabbix host" {
        didSet {
            hostDecriptionLabel.text = hostDecription
        }
    }
    
    var hostStatus = "normal" {
        didSet {
            hostStatusLabel.text = hostStatus
        }
    }
    
    var hostError = "normal" {
        didSet {
            hostErrorLabel.text = hostError
        }
    }
    
    var hostGroup = "" {
        didSet {
            hostGroupLabel.text = hostGroup
        }
    }
    
    var hostAvailable = "yes" {
        didSet {
            hostAvailableLabel.text = hostAvailable
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func goItems(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Items", bundle: nil).instantiateViewController(withIdentifier: "ItemTabBarController") as! UITabBarController
        
        let collection = superCollectionView()
        let collectionViewController = collection?.parentViewController()?.parent as! UINavigationController
        
        collectionViewController.pushViewController(controller, animated: true)
    }
    
}
