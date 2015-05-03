//
//  CellModel.swift
//  Walker
//
//  Created by Simas Abramovas on 5/2/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import Foundation

let CELL_ACTIVATION_NOTIFIER = "cell_activation_notifier"

class Cell : NSObject {
    
    let index: Int
    var activated = false {
        didSet {
            if activated != oldValue {
                NSNotificationCenter.defaultCenter().postNotificationName(CELL_ACTIVATION_NOTIFIER, object: self)
            }
        }
    }
    
    init(index: Int) {
        self.index = index
    }
    
}