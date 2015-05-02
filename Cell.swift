//
//  CellModel.swift
//  Walker
//
//  Created by Simas Abramovas on 5/2/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import Foundation
import SceneKit

let CELL_ACTIVATION_NOTIFIER = "cell_activation_notifier"

class Cell : NSObject {
    
    var activated = false {
        didSet {
            if activated != oldValue {
                NSNotificationCenter.defaultCenter().postNotificationName(CELL_ACTIVATION_NOTIFIER, object: self)
            }
        }
    }
    let index: Int
    
    init(index: Int) {
        self.index = index
    }
    
}