//
//  CircleChartView.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 16/05/16.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit

private struct CircleChartItemModel {
    let color: UIColor
    let startAngle: Double
    let endAngle: Double
}

private extension CollectionType where Generator.Element == CircleChartItem {

    private func normalize() -> [CircleChartItem] {
        let ratioSum = reduce(0.0, combine: { $0 + $1.ratio })
        guard ratioSum != 0 else {
            return Array(self)
        }
        return map {
            CircleChartItem(color: $0.color, ratio: $0.ratio / ratioSum)
        }
    }

    func mapToModelsWithStartAngle(startAngle: Double) -> [CircleChartItemModel] {
        var nextStartAngle = startAngle
        return map { (item) -> CircleChartItemModel in
            let startAngle = nextStartAngle
            let endAngle = startAngle - 2 * M_PI * item.ratio
            nextStartAngle = endAngle
            return CircleChartItemModel(color: item.color, startAngle: startAngle, endAngle: endAngle)
        }
    }
}

final class CircleChart: UIView {

    private var itemModels: [CircleChartItemModel] = []
    @IBInspectable var strokeWidth: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }

    func configureWithViewModel(viewModel: CircleChartViewModel) {
        itemModels = viewModel.items.normalize().mapToModelsWithStartAngle(viewModel.startAngle)
        setNeedsDisplay()
    }

    private func drawArcForModel(model: CircleChartItemModel, inContext context: CGContext?, inRect rect: CGRect) {
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let chartRadius = min(rect.size.width, rect.size.height) / 2 - strokeWidth / 2
        let smallerArcRadius = chartRadius - strokeWidth / 2
        let biggerArcRadius = chartRadius + strokeWidth / 2
        let startAngle = CGFloat(model.startAngle)
        let endAngle = CGFloat(model.endAngle)

        let startPointInternal = CGPoint(x: smallerArcRadius * cos(startAngle) + center.x,
                                         y: smallerArcRadius * sin(startAngle) + center.y)
        let roundingInsideCenter = CGPoint(x: chartRadius * cos(endAngle) + center.x, y: chartRadius * sin(endAngle) + center.y)
        let roundingOutsideCenter = CGPoint(x: chartRadius * cos(startAngle) + center.x, y: chartRadius * sin(startAngle) + center.y)

        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, startPointInternal.x, startPointInternal.y)
        CGPathAddArc(path, nil, center.x, center.y, smallerArcRadius, startAngle, endAngle, true)
        CGPathAddArc(path, nil, roundingInsideCenter.x, roundingInsideCenter.y, strokeWidth / 2, endAngle - CGFloat(M_PI), endAngle, true)
        CGPathAddArc(path, nil, center.x, center.y, biggerArcRadius, endAngle, startAngle, false)
        CGPathAddArc(path, nil, roundingOutsideCenter.x, roundingOutsideCenter.y, strokeWidth / 2, startAngle, startAngle + CGFloat(M_PI), false)


        CGContextAddPath(context, path)
        CGContextSetFillColorWithColor(context, model.color.CGColor)
        CGContextFillPath(context)
    }

    override func drawRect(rect: CGRect) {
        guard itemModels.count > 0 else {
            return
        }

        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, .High)

        for model in itemModels {
            drawArcForModel(model, inContext: context, inRect: rect)
        }
    }
}
