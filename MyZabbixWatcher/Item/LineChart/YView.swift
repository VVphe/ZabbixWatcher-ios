//
//  YView.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/4.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class YView: UIView {
    var yLineView: UIView = UIView()
    var delegate: LineChartViewDataSource?
    var yElementInterval: Float = 40
    var axisAttributes: AxisAttributes? {
        didSet {
            if let yElementInterval = axisAttributes?.yElementInterval {
                self.yElementInterval = yElementInterval
            }
        }
    }
    var perPixelOfYvalue: Float = -1
    var firstYvalue: String = "0"
    var lastYvalue: String = "0"
    var minSpaceValue: NSNumber?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadYaxis()
    }
    
    func reloadYaxis() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        perPixelOfYvalue = -1
        yLineView.frame = CGRect(x: self.frame.width - 1, y: 0, width: 1, height: self.frame.height)
        addSubview(yLineView)
        if let lineColor = axisAttributes?.yAxisColor {
            yLineView.backgroundColor = lineColor
        } else {
            yLineView.backgroundColor = UIColor.gray
        }
        guard let elementCons = delegate?.numberOfElementsCountWithAxisType(.AxisTypeY) else {
            return
        }
        var yTexts: [String] = []
        for index in 0..<elementCons {
            if let elementView = delegate?.elementWithAxisType(.AxisTypeY, index) {
                if let elementViewText = elementView.text {
                    yTexts.append(elementViewText)
                }
            }
        }
        var yTextsCopy = yTexts
        let ySpaceValues: NSMutableArray = NSMutableArray()
        if(yTextsCopy.count > 2) {
            for index in 0..<(yTextsCopy.count - 1) {
                let yValue = yTexts[index + 1]
                let yCopyValue = yTextsCopy[index]
                ySpaceValues.add(NSNumber(integerLiteral: (Int(yValue)! - Int(yCopyValue)!)))
            }
            minSpaceValue = ySpaceValues.value(forKeyPath: "@min.self") as? NSNumber
        }
        
        var lastElementView: UIView!
        for index in 0..<elementCons {
            if let elementView = delegate?.elementWithAxisType(.AxisTypeY, index) {
                let elementSize = ("y" as NSString).size(withAttributes: [NSAttributedStringKey.font: elementView.font!])
                var isFirstYAsOrigin = false
                if let wrappedFirstYAsOrigin = axisAttributes?.firstYAsOrigin {
                    isFirstYAsOrigin = wrappedFirstYAsOrigin
                }
                if isFirstYAsOrigin, index == 0 {
                    firstYvalue = elementView.text ?? "0"
                }
                var spaceIndex: Float = Float(exactly: index)!
                if let minSpace = minSpaceValue {
                    spaceIndex = (Float(elementView.text!)! - Float(firstYvalue)!) / Float(truncating: minSpace)
                }
                if(index == elementCons - 1) {
                    lastYvalue = elementView.text ?? ""
                }
                let y = CGFloat(yElementInterval*Float(exactly: spaceIndex)!)
                elementView.frame = CGRect(x: 0, y: self.frame.height - ((elementSize.height/2)+y), width: self.frame.width - 5, height: elementSize.height)
                addSubview(elementView)
                lastElementView = elementView
            }
        }
        yLineView.frame = CGRect(x: self.frame.width - 1, y: lastElementView.frame.origin.y, width: 1, height: self.frame.height - lastElementView.frame.origin.y)
        if !firstYvalue.isEmpty && !lastYvalue.isEmpty {
            if let firstNum = Float(firstYvalue), let lastNum = Float(lastYvalue), firstNum >= 0, lastNum > firstNum {
                perPixelOfYvalue = ((lastNum - firstNum)/Float(truncating: minSpaceValue!)*yElementInterval) / (lastNum - firstNum)
            }
        }
    }
    
    func getYPoint(_ yAxisValue: String) -> CGFloat {
        if(yAxisValue.isEmpty) {
            return 0
        }
        guard let yAxisNumValue = Float(yAxisValue), let firstNum = Float(firstYvalue) else {
            return 0
        }
        return self.frame.height - CGFloat((yAxisNumValue - firstNum)*perPixelOfYvalue)
    }
    
    func refresh() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func getGridHeight(_ yAxisValue: String?, nextYValue: String?) -> Float {
        guard let yValue = yAxisValue, let yNextValue = nextYValue else {
            return 0
        }
        return (Float(yNextValue)! - Float(yValue)!) * perPixelOfYvalue
    }
}
