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

    struct Const {
        static let WIDTH = 6
        static let HEIGHT = 6
    }
    
    var cells: [Cell] = []
    var obstacles: [Obstacle] = []
    // Gride dimensions (cell count)
    let width, height: Int
    
    // Empty initialiser
    convenience init() {
        self.init(width: Const.WIDTH, height: Const.HEIGHT)
    }
    
    // Initialize a grid with objects
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        // Add children
        for col in 0..<width {
            for row in 0..<height {
                cells.append(Cell(index: row * width + col))
            }
        }
    }
    
    func getCell(col: Int, row: Int) -> Cell {
        return cells[row * width + row]
    }

}