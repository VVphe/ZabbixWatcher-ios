//
//  Protocols.swift
//  MyZabbixWatcher
//
//  Created by apple on 2018/6/4.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

typealias AxisAttributes = (yElementsCount: Int?, yElementInterval: Float?, xElementInterval: Float?, yMargin: Float?, xMargin: Float?, yAxisColor: UIColor?, xAxisColor: UIColor?, gridColor: UIColor?, gridHide: Bool?, pointFont: UIFont?, pointHide: Bool?, firstYAsOrigin: Bool?, scrollAnimation: Bool?, scrollAnimationDuration: Float?)

enum AxisType {
    case AxisTypeX, AxisTypeY
}

protocol PointItemProtocol {
    
    func px_pointYvalue() -> String //y坐标值
    func px_pointXvalue() -> String //x坐标值
    func px_chartLineColor() -> UIColor //折线color
    func px_chartPointColor() -> UIColor //point color
    func px_pointValueColor() -> UIColor //
    func px_pointSize() -> CGSize //point size
    func px_chartFillColor() -> UIColor //fill color - UIColor
    func px_chartFill() -> Bool //是否fill
    
    
}

extension PointItemProtocol {
    func px_chartLineColor() -> UIColor { return UIColor.gray }
    func px_chartPointColor() -> UIColor { return UIColor.gray }
    func px_pointValueColor() -> UIColor {return UIColor.gray }
    func px_pointSize() -> CGSize { return CGSize(width: 6, height: 6) }
    func px_chartFillColor() -> UIColor { return UIColor.green }
    func px_chartFill() -> Bool { return true }
}

protocol LineChartViewDataSource {
    func numberOfElementsCountWithAxisType(_ axisType: AxisType) -> Int
    
    func elementWithAxisType(_ axisType: AxisType, _ axisIndex: Int) -> UILabel
    
    func numberOfChartLines() -> Int
    
    func plotsOfLineIndex(_ lineIndex: Int) -> [PointItemProtocol]
    
    func elementDidClickedWithPointSuperIndex(_ superidnex: Int, _ pointSubIndex: Int)
    
    func lineChartViewAxisAttributes() -> AxisAttributes
}

extension LineChartViewDataSource {
    func lineChartViewAxisAttributes() -> [String: Any] {
        return [:]
    }
    func elementDidClickedWithPointSuperIndex(_ superidnex: Int, _ pointSubIndex: Int) {}
}
