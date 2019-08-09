//
//  GridDrawer.swift
//  Gridy
//
//  Created by Ahmad Murad on 30/07/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import Foundation
import UIKit

public class GridDrawer {
    
//    let context: UIGraphicsRendererContext
//    let squareDimension: CGFloat
//    
//    init(context: UIGraphicsRendererContext, squareDimension: CGFloat) {
//        self.context         = context
//        self.squareDimension = squareDimension
//    }
    
    func drawGrid(context: UIGraphicsImageRendererContext, squareDimension: CGFloat) {
                for row in 0...4 {
                    let point = CGPoint(x: CGFloat(row)*(squareDimension/4), y: 0)
                    context.cgContext.move(to: point)
                    context.cgContext.addLine(to: CGPoint(x: CGFloat(row)*(squareDimension/4), y: squareDimension))
                    context.cgContext.strokePath()
                }
                for col in 0...4 {
                    let point = CGPoint(x:  0, y:CGFloat(col)*(squareDimension/4))
                    context.cgContext.move(to: point)
                    context.cgContext.addLine(to: CGPoint(x: squareDimension, y: CGFloat(col)*(squareDimension/4)))
                    context.cgContext.strokePath()
                }
            }
    
    
    
}
