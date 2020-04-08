//
//  TileAttributes.swift
//  Gridy
//
//  Created by Ahmad Murad on 08/07/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit

class TileAttributes: UIImageView, UIGestureRecognizerDelegate {
    
    var originalTileLocation: CGPoint
    var tileGridLocation: Int
    var isTileInCorrectLocation: Bool
    
    init(originalTileLocation: CGPoint, frame: CGRect, tileGridLocation: Int) {
        self.originalTileLocation = originalTileLocation
        self.tileGridLocation     = tileGridLocation
        isTileInCorrectLocation   = false
        super.init(frame: frame)
        
    }
    
    // this a protocol that handles this mechanism of freeze-drying what's in interface builder resurrecting it when you app runs
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
