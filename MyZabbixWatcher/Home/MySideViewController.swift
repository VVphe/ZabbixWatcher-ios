//
//  MySideViewController.swift
//  ZabbixWatcher
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class MySideViewController: UIViewController {
    
    static let TABLEVIEWCELLIDENTIFIER = "TABLEVIEWCELLIDENTIFIER"
    let titleArray = ["My zabbix", "关于zabbix", "退出登录"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backImage)
        view.addSubview(rootTableView)
    }
    
    lazy var backImage : UIImageView = { [unowned self] in
        var image = UIImageView(image: UIImage(named: "starground.jpeg"))
        image.frame = self.view.bounds
        image.alpha = 0.85
        return image
        }()
    
    lazy var rootTableView : UITableView = { [unowned self] in
        var tableView : UITableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: MySideViewController.TABLEVIEWCELLIDENTIFIER)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        }()
    
}

extension MySideViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MySideViewController.TABLEVIEWCELLIDENTIFIER, for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .clear
        headView.alpha = 1
        
        let author = UILabel()
        author.frame = CGRect(x: 10, y: 30, width: 300, height: 100)
        author.textAlignment = NSTextAlignment.left
        author.font = UIFont.systemFont(ofSize: 20)
        author.text = "ZABBIX Management"
        author.numberOfLines = 0
        author.textColor = .white
        author.backgroundColor = .clear
        headView.addSubview(author)
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let controller = UIStoryboard(name: "KnowMore", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.navigationController?.pushViewController(controller, animated: true)
            //self.present(controller, animated: true)
        
            break
        case 3:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(controller, animated: true)
            //self.present(controller, animated: true, completion: nil)
            break
        
        default:
            break
        }
    }
}

