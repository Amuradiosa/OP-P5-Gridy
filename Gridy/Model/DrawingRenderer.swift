//
//  DrawingRenderer.swift
//  Gridy
//
//  Created by Ahmad Murad on 30/07/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import Foundation
import UIKit

public class DrawingRenderer: GridDrawer {
    
    let drawingView: UIImageView
    
    init(drawingView: UIImageView) {
        self.drawingView = drawingView
    }
    
    func drawingOn(thisView: UIImageView) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: thisView.frame.width, height: thisView.frame.height))
        let image = renderer.image { (ctx) in
            let squareDimension = thisView.frame.width
            drawGrid(context: ctx, squareDimension: squareDimension)
        }
        thisView.image = image
    }

}

