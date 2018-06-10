//
//  ItemViewHistoryController.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ItemViewHistoryController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var selectType: UISegmentedControl!
    var type: String = "From"
    
    @IBOutlet weak var timeTillLabel: UILabel!
    @IBOutlet weak var timeFromLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func searchHistory(_ sender: UIButton) {
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var strFrom = dformatter.date(from: timeFromLabel.text!)
        var strTill = dformatter.date(from: timeTillLabel.text!)
        var dateStampFrom:TimeInterval = strFrom!.timeIntervalSince1970
        var dateStampTill:TimeInterval = strTill!.timeIntervalSince1970
        var dateStFrom:Int = Int(dateStampFrom)
        var dateStTill:Int = Int(dateStampTill)
        print(dateStFrom)
        print(dateStTill)

    }
    
    override func viewDidLoad() {
        datePicker.addTarget(self, action: #selector(chooseDate( _:)), for:UIControlEvents.valueChanged)
        selectType.addTarget(self, action: #selector(chooseType( _:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func chooseDate(_ datePicker:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = datePicker.date
        let dateText = formatter.string(from: date)
     
        if (type == "From") {
            timeFromLabel.text = dateText
        } else if(type == "To") {
            timeTillLabel.text = dateText
        }
    }
    
    @objc func chooseType(_ segmentedControl: UISegmentedControl) {
        type = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
    }
}
