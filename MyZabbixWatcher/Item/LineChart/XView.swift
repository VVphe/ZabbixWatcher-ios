//
//  XView.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/4.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class XView: UIView {
    
    var xLineView: UIView = UIView()
    var xElements: [String] = []
    var xElementInterval: Float = 40
    
    var delegate: LineChartViewDataSource?
    
    var axisAttributes: AxisAttributes? {
        didSet {
            if let xElementInterval = axisAttributes?.xElementInterval {
                self.xElementInterval = xElementInterval
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadXaxis()
    }
    
    func reloadXaxis() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        xElements.removeAll()
        
        if let lineColor = axisAttributes?.xAxisColor {
            xLineView.backgroundColor = lineColor
        }else{
            xLineView.backgroundColor = UIColor.gray
        }
        
        xLineView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        addSubview(xLineView)
        
        guard let elementCons = delegate?.numberOfElementsCountWithAxisType(.AxisTypeX) else {
            return
        }
        
        if let xElementInterval = axisAttributes?.xElementInterval {
            self.xElementInterval = xElementInterval
        }
        
        for index in 0..<elementCons {
            if let elementView = delegate?.elementWithAxisType(.AxisTypeX, index) {
                var elementSize = CGSize()
                if let elementViewText = elementView.text {
                    xElements.append(elementViewText)
                    elementSize = (elementViewText as NSString).size(withAttributes: [NSAttributedStringKey.font: elementView.font!])
                }
                elementView.frame = CGRect(x: 0, y: self.frame.height - elementSize.height, width: elementSize.width, height: elementSize.height)
                elementView.center = CGPoint(x: CGFloat(xElementInterval*Float(index+1)), y: elementView.center.y)
                addSubview(elementView)
            }
        }
    }
    
    func getXPoint(_ xAxisText: String) -> CGFloat {
        if(xAxisText.isEmpty) {
            return 0
        }
        guard let xIndex = xElements.index(of: xAxisText) else {
            return 0
        }
        return CGFloat(xElementInterval*Float(xIndex+1))
    }
    
    func refresh() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
