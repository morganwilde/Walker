//
//  ObjectModel.swift
//  Walker
//
//  Created by Simas Abramovas on 5/2/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import Foundation
import SceneKit

// Objects are static objects on top of a grid
class Object {
    
    // ToDo? Create object from given width
    
    var occupiedCells: [Cell] = []
    init(occupiedCells: [Cell]) {
        self.occupiedCells = occupiedCells
    }
    
    func occupies(cell: Cell) -> Bool {
        return contains(occupiedCells, cell)
    }
    
}