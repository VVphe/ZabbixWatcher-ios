//
//  LineView.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/4.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class LineView: UIView {
    var xAxisView: XView?
    var yAxisView: YView?
    var delegate: LineChartViewDataSource?
    var axisAttributes: AxisAttributes?
    
    convenience init(_ xAxisView: XView, _ yAxisView: YView) {
        self.init()
        self.xAxisView = xAxisView
        self.yAxisView = yAxisView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        for subview in subviews {
            subview.removeFromSuperview()
        }
          drawLineAndPoints(rect: rect)
    }
    
    @objc func pointDidSelect(_ superIndex: Int, subIndex: Int) {
        delegate?.elementDidClickedWithPointSuperIndex(superIndex, subIndex)
    }
    
    func refresh() {
        setNeedsDisplay()
    }
  
    func drawLineAndPoints(rect: CGRect) {
        guard let yCon = delegate?.numberOfElementsCountWithAxisType(.AxisTypeY) else {
            return
        }
        var isPointHide = false
        if let wrappedPointHide = axisAttributes?.pointHide {
            isPointHide = wrappedPointHide
        }
        var isGridHide = false
        if let wrappedGridHide = axisAttributes?.gridHide {
            isGridHide = wrappedGridHide
        }
        
        if !isGridHide {
            var gridCon = yCon
            var isFirstAsOrigin = false
            for i in 0..<gridCon {
                if let yElementLab = delegate?.elementWithAxisType(.AxisTypeY, i) {
                    var gridHeight: Float = 0
                    if(i < gridCon - 1) {
                        let nextElementLab: UILabel = (delegate?.elementWithAxisType(.AxisTypeY, i + 1))!
                        let pointY = yAxisView?.getYPoint(nextElementLab.text!)
                        gridHeight = (yAxisView?.getGridHeight(yElementLab.text, nextYValue: nextElementLab.text))!
                        let gridRect = CGRect(x: 0, y: pointY ?? 0, width: self.frame.width, height: CGFloat(gridHeight))
                        var fillcolor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
                        if let fc = axisAttributes?.gridColor {
                            fillcolor = fc
                        }
                        if isFirstAsOrigin {
                            if(i % 2 != 0) {
                                UIColor.clear.setFill()
                            } else {
                                fillcolor.setFill()
                            }
                        } else {
                            if(i%2 == 0) {
                                UIColor.clear.setFill()
                            } else {
                                fillcolor.setFill()
                            }
                        }
                        let rectPath = UIBezierPath(rect: gridRect)
                        rectPath.fill()
                    }
                }
            }
            
            guard let lines = delegate?.numberOfChartLines() else {
                return
            }
            
            for i in 0..<lines {
                let ctx = UIGraphicsGetCurrentContext()
                let path = UIBezierPath()
                ctx?.setLineWidth(0.5)
                if let points = delegate?.plotsOfLineIndex(i), points.count > 0 {
                    let startPointItem = points.first
                    let startX = xAxisView?.getXPoint((startPointItem?.px_pointXvalue())!) ?? 0
                    let startY = yAxisView?.getYPoint((startPointItem?.px_pointYvalue())!) ?? 0
                    let isFill = startPointItem?.px_chartFill()
                    let strokeColor = startPointItem?.px_chartLineColor()
                    var start = CGPoint()
                    if isFill! {
                        start = CGPoint(x: startX, y: (yAxisView?.getYPoint("0"))!)
                    } else {
                        start = CGPoint(x: startX, y: startY)
                    }
                    path.move(to: start)
                    
                    var endPoint = CGPoint()
                    for j in 0..<points.count {
                        let pointItem = points[j]
                        let pointXValue = pointItem.px_pointXvalue()
                        let pointYValue = pointItem.px_pointYvalue()
                        let pointX = xAxisView?.getXPoint(pointXValue)
                        let pointY = yAxisView?.getYPoint(pointYValue)
                        
                        var pointButton: UIButton?
                        if !isPointHide {
                            pointButton = UIButton()
                            pointButton?.tag = j
                            pointButton?.backgroundColor = pointItem.px_chartPointColor()
                            let pointSize = pointItem.px_pointSize()
                            pointButton?.frame = CGRect(x: 0, y: 0, width: pointSize.width, height: pointSize.height)
                            pointButton?.center = CGPoint(x: pointX!, y: pointY!)
                            pointButton?.layer.masksToBounds = true
                            pointButton?.isUserInteractionEnabled = true
                            pointButton?.layer.cornerRadius = min(pointSize.width, pointSize.height) / 2
                            pointButton?.addTarget(self, action: #selector(pointDidSelect), for: .touchUpInside)
                            //TODO:
                            //addSubview(pointButton!)
                        }
                        path.addLine(to: CGPoint(x: pointX!, y: pointY!))
                        endPoint = CGPoint(x: pointX!, y: (yAxisView?.getYPoint("0"))!)
                    }
                    if isFill! {
                        path.addLine(to: endPoint)
                        let fillColor = startPointItem?.px_chartFillColor()
                        fillColor?.set()
                        ctx?.addPath(path.cgPath)
                        ctx?.fillPath()
                    } else {
                        strokeColor?.set()
                        ctx?.addPath(path.cgPath)
                        ctx?.strokePath()
                    }
                }
            }
        }
    }
}

extension UIButton {
    func action(_ withEvent: UIControlEvents, operation: ((UIButton) -> Void)) {
        objc_setAssociatedObject(self, "operationKey", operation, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(callAction(_:)), for: withEvent)
    }
    
    @objc func callAction(_ sender: UIButton) {
        
    }
}
