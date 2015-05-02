//
//  CellModel.swift
//  Walker
//
//  Created by Simas Abramovas on 5/2/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import Foundation
import SceneKit

// Convenience function to compare a cell to two integers, i.e. a set of x,y coordinate
func ==(lhs: Cell, rhs: (Int, Int)) -> Bool {
    return (lhs.x == rhs.0 && lhs.y == rhs.1)
}

// Compare CellModel coordinates instead of pointers
func ==(lhs: Cell, rhs: Cell) -> Bool {
    return (lhs.x == rhs.x && lhs.y == rhs.y)
}

class Cell : NSObject {
    
    // Cell position within the Grid
    let x, y: Int
    var activated = false {
        didSet {
            if activated != oldValue {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "identifier", object: self))
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