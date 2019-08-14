//
//  RoundedButton.swift
//  Gridy
//
//  Created by Ahmad Murad on 26/06/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import Foundation
import UIKit

struct RoundedButton {
    
    private var button: UIButton?
    
    mutating func setButton(_ button: UIButton) {
        self.button = button
    }

    func rounded() {
        if let newButton = button {
            newButton.layer.cornerRadius  = 10.0
            newButton.layer.masksToBounds = true
        }
    }
}
