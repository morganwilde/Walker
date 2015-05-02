//
//  CellModel.swift
//  Walker
//
//  Created by Simas Abramovas on 5/2/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import Foundation
import SceneKit

// Compare CellModel coordinates instead of pointers
func ==(lhs: Cell, rhs: Cell) -> Bool {
    return (lhs.x == rhs.x && lhs.y == rhs.y)
}

let CELL_ACTIVATION_NOTIFIER = "cell_activation_notifier"

class Cell : NSObject {
    
    // Cell position within the Grid
    let x, y: Int
    var activated = false {
        didSet {
            if activated != oldValue {
                NSNotificationCenter.defaultCenter().postNotificationName(CELL_ACTIVATION_NOTIFIER, object: self)
            }
        }
    }
    
    override var description: String {
        return "Cell position: (\(x),\(y))"
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}