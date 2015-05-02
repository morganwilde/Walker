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
        static let X_COUNT = 6
        static let Y_COUNT = 6
    }
    
    // 2D array of cells
    var cells: [Cell] = []
    // Object array
    var obstacles: [Obstacle] = []
    // Grid size
    let cellCountX, cellCountY: Int
    
    // Empty initialiser
    convenience init() {
        self.init(cellCountX: Const.X_COUNT, cellCountY: Const.Y_COUNT, obstacles: [])
    }
    
    // Initialize a grid without any objects
    convenience init(cellCountX: Int, cellCountY: Int) {
        self.init(cellCountX: cellCountX, cellCountY: cellCountY, obstacles: [])
    }
    
    // Initialize a grid with objects
    init(cellCountX: Int, cellCountY: Int, obstacles: [Obstacle]) {
        self.cellCountX = cellCountX
        self.cellCountY = cellCountY
        self.obstacles = obstacles
        
        // Add children
        for x in 0..<cellCountX {
            for y in 0..<cellCountY {
                cells.append(Cell(x: x, y: y))
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Returns false if cell doesn't exist or object isn't found on that cell, otherwise true
    func isCellOccupied(#x: Int, y: Int) -> Bool {
        if (getObstacleOnCell(x: x, y: y) == nil) {
            return false
        } else {
            return true
        }
    }
    
    // Return the object that's on the given cell position
    // Returns nil if the cell is not occupied or just doesn't exist
    func getObstacleOnCell(#x: Int, y: Int) -> Obstacle? {
        if (cells.count < x * y) {
            return nil
        }
        
        for cell in cells {
            for obstacle in obstacles {
                if obstacle.occupies(cell) {
                    return obstacle
                }
            }
        }
        
        return nil
    }
    
}