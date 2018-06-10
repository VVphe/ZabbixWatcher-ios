//
//  ClusterAddViewController.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SwiftForms

class ClusterAddViewController: FormViewController {
    
    func setupForm() {
        
        title = "Add Cluster"
        
        let form = FormDescriptor()
        form.title = "Add Cluster"
        
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        var row = FormRowDescriptor(tag: "cluster", type: .text, title: "Cluster name")
        section1.rows.append(row)
        row = FormRowDescriptor(tag: "ip", type: .url, title: "Ip")
        section1.rows.append(row)
        
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: "username", type: .text, title: "Username")
        section2.rows.append(row)
        row = FormRowDescriptor(tag: "password", type: .password, title: "Password")
        section2.rows.append(row)
        
        let section3 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: "submit", type: .button, title: "Submit")
        row.configuration.button.didSelectClosure = { _ in
            self.submit()
        }
        section3.rows.append(row)
        
        form.sections = [section1, section2, section3]
        self.form = form
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupForm()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submit() {
        self.view.endEditing(true)
        let message = self.form.formValues().description
        print(message)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
