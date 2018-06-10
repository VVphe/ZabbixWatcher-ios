//
//  ItemViewController.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/3.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import QuartzCore

class ItemViewController: UIViewController {
    
    //@IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    var fill = false
    var lines: [[PointItemProtocol]]!//折线count
    var xElements: [String]!//x轴数据
    var yElements: [String]!//y轴数据
    var xLabel:[String] = []
    var yLabel:[Float] = []
    
    //var addressPicker: UIPickerView!
    
    //@IBOutlet weak var itemPicker: UIPickerView!
    @IBOutlet weak var itemPicker: UIPickerView!
    
    @IBAction func searchItem(_ sender: UIButton) {
        let c = self.itemArray[classIndex]
        let items = c["class"]!
        
        let i = (c["items"] as! NSArray)[itemIndex]
        let item = i as! String
        
        let message = "值：\(items) - \(item)"
        print(message)
    }
    
    var itemArray = [[String: AnyObject]]()
    var classIndex = 0
    var itemIndex = 0
    
    func lineData(_ fill: Bool) -> [[PointItemProtocol]] {
//        let firstline = [["xValue": "16-2", "yValue": "1000"],
//                         ["xValue": "16-4", "yValue": "2000"],
//                         ["xValue": "16-6", "yValue": "1700"],
//                         ["xValue": "16-8", "yValue": "3100"],
//                         ["xValue": "16-9", "yValue": "3500"],
//                         ["xValue": "16-12", "yValue": "3400"],
//                         ["xValue": "17-02", "yValue": "1100"],
//                         ["xValue": "17-04", "yValue": "1500"]]

        let firstline = ItemData
//        let secondline = [["xValue": "16-2", "yValue": "2000"],
//                          ["xValue": "16-3", "yValue": "2200"],
//                          ["xValue": "16-4", "yValue": "3000"],
//                          ["xValue": "16-6", "yValue": "3750"],
//                          ["xValue": "16-7", "yValue": "3800"],
//                          ["xValue": "16-8", "yValue": "4000"],
//                          ["xValue": "16-10", "yValue": "2000"]]
        var firstLineItems: [PointItemProtocol] = []
        //var secondLineItems: [PointItemProtocol] = []
        for i in 0..<firstline.count {
            var item = PointItem()
            let itemDic = firstline[i]
            item.price = itemDic["value"]!
            
            item.time = itemDic["timeStamp"]!
            xLabel.append(item.time)
            item.chartLineColor = UIColor.red
            item.chartPointColor = UIColor.red
            item.pointValueColor = UIColor.red
            if fill {
                item.chartFillColor = UIColor(red: 0, green: 0.5, blue: 0.2, alpha: 0.5)
            }
            item.chartFill = fill
            firstLineItems.append(item)
        }
        
//        for i in 0..<secondline.count {
//            var item = PointItem()
//            let itemDic = secondline[i]
//            item.price = itemDic["yValue"]!
//            item.time = itemDic["xValue"]!
//            item.chartLineColor = UIColor(red: 0.2, green: 1, blue: 0.7, alpha: 1)
//            item.chartPointColor = UIColor(red: 0.2, green: 1, blue: 0.7, alpha: 1)
//            item.pointValueColor = UIColor(red: 0.2, green: 1, blue: 0.7, alpha: 1)
//            if fill {
//                item.chartFillColor = UIColor(red: 0.5, green: 0.1, blue: 0.8, alpha: 0.5)
//            }
//            item.chartFill = fill
//            secondLineItems.append(item)
//        }
  
        return [firstLineItems]
    }
    
    func setupAddress() {
        let path = Bundle.main.path(forResource: "ItemTemplate", ofType: "plist")
        itemArray = NSArray(contentsOfFile: path!) as! Array
        
        itemPicker.delegate = self
        itemPicker.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lines = lineData(fill)
        lineChartView.delegate = self
        setupAddress()
        //xElements = ["16-2","16-3","16-4","16-5","16-6","16-7","16-8"]
        xElements = ["1521035350", "1521035410", "1521035470", "1521035530", "1521035590", "1521035650", "1521035710"]
        //xElements = xLabel
        //yElements = ["1000","2000","3000","4000","5000"];
        //yElements = ["1050701824","1051508736","1052635136","1053049984", "1060000000"];
        yElements = ["1050000000", "1052000000", "1054000000", "1056000000"]
    }
    
}

extension ItemViewController: LineChartViewDataSource {
    
    //
    func numberOfChartLines() -> Int {
        return lines.count
    }
    
    //通用设置
    func lineChartViewAxisAttributes() -> AxisAttributes {
        return (nil, Float(80), Float(80), Float(50), Float(25),
                UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1),
                UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1),
                UIColor(red: 244.0/255, green: 244.0/255, blue: 244.0/255, alpha: 1),
                false,
                UIFont.systemFont(ofSize: 10),
                false,
                true,
                true,
                Float(2))
    }
    
    //每条line对应的point数组
    func plotsOfLineIndex(_ lineIndex: Int) -> [PointItemProtocol] {
        return lines[lineIndex]
    }
    
    //x轴y轴对应的元素count
    func numberOfElementsCountWithAxisType(_ axisType: AxisType) -> Int {
        return (axisType == .AxisTypeY) ?  yElements.count : xElements.count;
    }
    
    //x轴y轴对应的元素view
    func elementWithAxisType(_ axisType: AxisType, _ axisIndex: Int) -> UILabel {
        let label = UILabel()
        var axisValue = ""
        if axisType == .AxisTypeX {
            axisValue = xElements[axisIndex]
            label.textAlignment = .center
        }else{
            axisValue = yElements[axisIndex]
            label.textAlignment = .right
        }
        label.text = axisValue
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        return label
    }
    
    //点击point回调响应
    func elementDidClickedWithPointSuperIndex(_ superidnex: Int, _ pointSubIndex: Int) {
        guard let item = lines[superidnex][pointSubIndex] as? PointItem else {
            return
        }
        let xTitle = item.time
        let yTitle = item.price
        let alertView = UIAlertController(title: yTitle, message: "x:\(xTitle) \ny:\(yTitle)", preferredStyle: .alert)
        let  alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fill = !fill;
        lines = lineData(fill)
        lineChartView.reloadData()
    }
}

extension ItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return itemArray.count
        case 1:
            let items = itemArray[classIndex]
            return items["items"]!.count
        default:
            return 0
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            return itemArray[row]["class"] as? String
//        case 1:
//            let items = itemArray[classIndex]
//            let item = (items["items"] as! NSArray)[row]
//            return item as? String
//        default:
//            return "no option"
//        }
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            classIndex = row
            itemIndex = 0
            itemPicker.reloadComponent(1)
            itemPicker.selectRow(0, inComponent: 1, animated: false)
        case 1:
            itemIndex = row

           
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16)
        }
        pickerLabel?.numberOfLines = 0
        switch component {
        case 0:
            pickerLabel?.text = itemArray[row]["class"] as? String
            pickerLabel?.textAlignment = .center
            return pickerLabel!
        case 1:
            let items = itemArray[classIndex]
            let item = (items["items"] as! NSArray)[row]
            pickerLabel?.text = item as? String
            pickerLabel?.textAlignment = .left
            return pickerLabel!
        default:
            return pickerLabel!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 100
        case 1:
            return itemPicker.frame.width - 120
        default:
            return 0
        }
    }
    
}

