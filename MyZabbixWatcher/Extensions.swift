//
//  Extensions.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/1.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var next = self.superview
        while next != nil {
            let ctr = next?.next
            if (ctr is UIViewController) {
                return ctr as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
}
