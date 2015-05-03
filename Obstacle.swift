//
//  ObjectModel.swift
//  Walker
//
//  Created by Simas Abramovas on 5/2/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import Foundation

// Obstacles are static objects on top of a grid
class Obstacle {
    
    var occupiedCells: [Cell] = []
    init(occupiedCells: [Cell]) {
        self.occupiedCells = occupiedCells
    }
    
    func occupies(cell: Cell) -> Bool {
        return contains(occupiedCells, cell)
    }
    
}