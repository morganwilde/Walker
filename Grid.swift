//
//  GridModel.swift
//  Walker
//
//  Created by Simas Abramovas on 5/2/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import Foundation
import SceneKit

class Grid {
    // Grid related constants
    struct Const {
        static let WIDTH = 6
        static let HEIGHT = 6
    }
    
    // Grid dimensions (cell count)
    let width: Int
    let height: Int
    // Grid containers
    var cells: [Cell] = []
    var obstacles: [Obstacle] = []
    
    // Empty initialiser
    convenience init() {
        self.init(width: Const.WIDTH, height: Const.HEIGHT)
    }
    
    // Initialize a grid with objects
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        // Add children in the row first order - (0,0) is the top left coordinate
        for row in 0..<height {
            for column in 0..<width {
                cells.append(Cell(index: row * width + column))
            }
        }
    }
    
    func getCell(column: Int, row: Int) -> Cell {
        return cells[row * width + column]
    }

}