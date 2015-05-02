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
    
    // 2D array of cells
    var cells: [Cell] = []
    // Object array
    var objects: [Object] = []
    // Grid size
    let cellCountX, cellCountY: Int
    
    // Initialize a grid with objects
    init(cellCountX: Int, cellCountY: Int, objects: [Object]) {
        self.cellCountX = cellCountX
        self.cellCountY = cellCountY
        self.objects = objects
    }
    
    // Initialize a grid without any objects
    convenience init(cellCountX: Int, cellCountY: Int) {
        self.init(cellCountX: cellCountX, cellCountY: cellCountY, objects: [])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Returns false if cell doesn't exist or object isn't found on that cell, otherwise true
    func isCellOccupied(#x: Int, y: Int) -> Bool {
        if (getObjectOnCell(x: x, y: y) == nil) {
            return false
        } else {
            return true
        }
    }
    
    // Return the object that's on the given cell position
    // Returns nil if the cell is not occupied or just doesn't exist
    func getObjectOnCell(#x: Int, y: Int) -> Object? {
        if (cells.count < x * y) {
            return nil
        }
        
        for cell in cells {
            for object in objects {
                if object.occupies(cell) {
                    return object
                }
            }
        }
        
        return nil
    }
    
}