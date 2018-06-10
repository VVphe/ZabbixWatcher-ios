//
//  LineChartView.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/4.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class LineChartView: UIView {
    var scrollView: UIScrollView!
    var xAxisView: XView!
    var yAxisView: YView!
    var lineView: LineView!
    
    var yWidth: Float = 50
    var xHeight: Float = 30
    var xInterval: Float = 80
    var xElements = 0
    var axisAttributes: AxisAttributes?
    
    var delegate: LineChartViewDataSource? {
        didSet {
            xAxisView.delegate = delegate
            yAxisView.delegate = delegate
            lineView.delegate = delegate
            xAxisView.axisAttributes = delegate?.lineChartViewAxisAttributes()
            yAxisView.axisAttributes = delegate?.lineChartViewAxisAttributes()
            lineView.axisAttributes = delegate?.lineChartViewAxisAttributes()
            axisAttributes = delegate?.lineChartViewAxisAttributes()
        }
    }
    
    func setupView() {
        xAxisView = XView()
        yAxisView = YView()
        lineView = LineView(xAxisView, yAxisView)
        scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        xAxisView.translatesAutoresizingMaskIntoConstraints = false
        yAxisView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(yAxisView)
        addSubview(scrollView)
        //addSubview(xAxisView)
        scrollView.addSubview(xAxisView)
        scrollView.addSubview(lineView)
        print("yes")
        print(xAxisView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupContraints()
    }
    
    func setupContraints() {
        clearSubConstraints(self)
        let viewsDict: [String : Any] = ["scrollView": scrollView, "xAxisView": xAxisView, "yAxisView": yAxisView, "lineView": lineView]
        if let customYwidth = axisAttributes?.yMargin {
            yWidth = customYwidth
        }
        if let customXheight = axisAttributes?.xMargin {
            xHeight = customXheight
        }
        if let customXInterval = axisAttributes?.xElementInterval {
            xInterval = customXInterval
        }
        xElements = delegate?.numberOfElementsCountWithAxisType(.AxisTypeX) ?? 0
        let scrollHeight = self.frame.height
        let scrollWidth = self.frame.width - CGFloat(yWidth)
        let yHeight = self.frame.height - CGFloat(xHeight)
        var xWidth = self.frame.width - CGFloat(yWidth)
        if (xWidth < CGFloat(Float((xElements+1))*xInterval)) {
            xWidth = CGFloat(Float((xElements+1))*xInterval)
        }
        scrollView.contentSize = CGSize(width: xWidth, height: scrollHeight)
        let metrics: [String : Any] = ["yWidth": yWidth,
                                       "xWidth": xWidth,
                                       "xHeight": xHeight,
                                       "yHeight": yHeight,
                                       "scrollHeight": scrollHeight,
                                       "scrollWidth": scrollWidth]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[yAxisView(==yWidth)][scrollView]|", options: [], metrics: metrics, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView(==scrollHeight)]", options: [], metrics: metrics, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[yAxisView(==yHeight)]|", options: [], metrics: metrics, views: viewsDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[xAxisView(==xWidth)]|", options: [], metrics: metrics, views: viewsDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView(==xWidth)]", options: [], metrics: metrics, views: viewsDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(==yHeight)][xAxisView(==xHeight)]|", options: [], metrics: metrics, views: viewsDict))
        
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width-scrollView.frame.width, y: 0), animated: true)
        scrollAnimationIfcanScroll()
    }
    
    func clearSubConstraints(_ targetView: UIView?) {
        guard let targetView = targetView else {
            return
        }
        if targetView != self {
            NSLayoutConstraint.deactivate(targetView.constraints)
        }
        for subview in targetView.subviews {
            clearSubConstraints(subview)
        }
        
    }
    
    func reloadData() {
        setNeedsLayout()
        layoutIfNeeded()
        xAxisView.refresh()
        yAxisView.refresh()
        lineView.refresh()
    }
    
    func scrollAnimationIfcanScroll() {
        layer.removeAllAnimations()
        scrollView.layer.removeAllAnimations()
        let duration = axisAttributes?.scrollAnimationDuration ?? 0.5
        if let canAnimate = axisAttributes?.scrollAnimation, canAnimate, scrollView.contentSize.width > scrollView.frame.width {
            UIView.animate(withDuration: Double(duration), delay: 0, options: .curveEaseInOut, animations: {
                self.scrollView.setContentOffset(CGPoint(), animated: true)
            }, completion: nil)
        }
    }

}
