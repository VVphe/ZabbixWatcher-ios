//
//  HostAddViewController.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SwiftForms

class HostAddViewController: FormViewController {
    
    func setupForm() {
        
        title = "Add Host"
        
        let form = FormDescriptor()
        form.title = "Add Host"
        
        var section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        var row = FormRowDescriptor(tag: "host", type: .text, title: "Host name")
        section1.rows.append(row)
        
        var section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: "group", type: .picker, title: "Host group")
        row.configuration.selection.options = [1,2,3] as [AnyObject]
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? Int else { return "" }
            switch option {
            case 1:
                return "初级"
            case 2:
                return "中级"
            case 3:
                return "高级"
            default: return ""
            }
        }
        section2.rows.append(row)
        row = FormRowDescriptor(tag: "template", type: .picker, title: "Host Template")
        row.configuration.selection.options = [1,2,3] as [AnyObject]
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? Int else { return "" }
            switch option {
            case 1:
                return "初级"
            case 2:
                return "中级"
            case 3:
                return "高级"
            default: return ""
            }
        }
        section2.rows.append(row)
        
        var section3 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: "description", type: .text, title: "Description")
        section3.rows.append(row)
        
        let section4 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: "submit", type: .button, title: "Submit")
        row.configuration.button.didSelectClosure = { _ in
            self.submit()
        }
        section4.rows.append(row)
        
        form.sections = [section1, section2, section3, section3]
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
