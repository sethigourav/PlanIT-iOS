//
//  ChartRenderer.swift
//  PLAN-IT
//
//  Created by KiwiTech on 13/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Charts
import CoreGraphics
extension BudgetSavingViewController {
    func setUpBarChart() {
        var dataArray = [String]()
        for category in AppStateManager.shared.budgetCategoryArray ?? [] {
            dataArray.append(category.categoryName ?? "")
        }
        let legend = barChartView.legend
        legend.form = .none
        var chartArray = [BarChartDataEntry]()
        for (index, data) in AppStateManager.shared.budgetCategoryArray?.enumerated() ?? [].enumerated() where !checkIfAllvalueIsZero() {
            chartArray.append(BarChartDataEntry(x: Double(index), y: Double(data.lastMonthSpend ?? 0.0)))
        }
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(entries: chartArray, label: "")
        set1.colors = [ChartColorTemplates.colorFromString(.chartColor)]
        set1.drawValuesEnabled = true
        set1.barBorderWidth = 1
        set1.barBorderColor = UIColor(name: .headingColor)
        let data = BarChartData(dataSet: set1)
        data.barWidth = 1
        barChartView.data = data.entryCount > 0 ? data : nil
        lastTransactionView.isHidden = data.entryCount > 0 ? false : true
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.noDataText = .noChartData
        barChartView.noDataFont = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 12) ?? UIFont.systemFont(ofSize: 12.0)
        barChartView.noDataTextColor = UIColor(name: .headingColor)
        barChartView.xAxis.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.setViewPortOffsets(left: 2, top: 50, right: 2, bottom: 0)
        barChartView.leftAxis.axisMinimum = 0.0
        let formatter = MyValueFormatter()
        formatter.dataArray = dataArray
        barChartView.barData?.setValueFormatter(formatter)
        barChartView.barData?.setDrawValues(true)
        let chartRenderer = ChartRenderer(dataProvider: barChartView, animator: barChartView.chartAnimator, viewPortHandler: barChartView.viewPortHandler)
        chartRenderer.initBuffer()
        barChartView.renderer = chartRenderer
        barChartView.isUserInteractionEnabled = false
    }
    func checkIfAllvalueIsZero() -> Bool {
        for data in AppStateManager.shared.budgetCategoryArray ?? [] where data.lastMonthSpend ?? 0.0 > 0 {
            return false
        }
        return true
    }
}
class MyValueFormatter: IValueFormatter {
    var dataArray = [String]()
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(value)" + "," + dataArray[Int(entry.x)]
    }
}
class ChartRenderer: BarChartRenderer {
    func initBuffer() {
        super.initBuffers()
    }
    override func drawValue(context: CGContext, value: String, xPos: CGFloat, yPos: CGFloat, font: NSUIFont, align: NSTextAlignment, color: NSUIColor) {
        let array = value.components(separatedBy: ",")
        let str = array[1].components(separatedBy: " ")
        if str.count == 2 {
            ChartUtils.drawText(context: context,
                                text: (AppStateManager.shared.budgetCategoryArray?.count ?? 0) > 0 ? Float(array[0])?.formatNumber(code: AppStateManager.shared.budgetCategoryArray?.first?.isoCurrencyCode ?? "") ?? "$" : array[0],
                                point: CGPoint(x: xPos, y: yPos - 45),
                                align: align,
                                attributes: [NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.italic), size: 9) ?? UIFont.systemFont(ofSize: 9.0), NSAttributedString.Key.foregroundColor: UIColor(name: .defaultColor)])
            ChartUtils.drawText(context: context,
                                text: str[0],
                                point: CGPoint(x: xPos, y: yPos - 30),
                                align: align,
                                attributes: [NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 9) ?? UIFont.systemFont(ofSize: 9.0), NSAttributedString.Key.foregroundColor: UIColor(name: .headingColor)])
             ChartUtils.drawText(context: context,
                                 text: str[1],
                                 point: CGPoint(x: xPos, y: yPos - 15),
                                 align: align,
                                 attributes: [NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 9) ?? UIFont.systemFont(ofSize: 9.0), NSAttributedString.Key.foregroundColor: UIColor(name: .headingColor)])
        } else {
            ChartUtils.drawText(context: context,
                                text: (AppStateManager.shared.budgetCategoryArray?.count ?? 0) > 0 ? Float(array[0])?.formatNumber(code: AppStateManager.shared.budgetCategoryArray?.first?.isoCurrencyCode ?? "") ?? "$" : array[0],
                                point: CGPoint(x: xPos, y: yPos - 30),
                                align: align,
                                attributes: [NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.italic), size: 9) ?? UIFont.systemFont(ofSize: 9.0), NSAttributedString.Key.foregroundColor: UIColor(name: .defaultColor)])
            ChartUtils.drawText(context: context,
                                text: str[0],
                                point: CGPoint(x: xPos, y: yPos - 15),
                                align: align,
                                attributes: [NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 9) ?? UIFont.systemFont(ofSize: 9.0), NSAttributedString.Key.foregroundColor: UIColor(name: .headingColor)])
        }
    }
}
