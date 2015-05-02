//
//  Grid.swift
//  Walker
//
//  Created by Tautvydas Stakėnas on 5/2/15.
//  Copyright (c) 2015 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import SceneKit

struct Index {
    var x: Int
    var y: Int
}

class GridView: SCNNode {
    
    var cells:[[CellView]] = []
    var planeWidth: CGFloat!
    var planeHeight: CGFloat!
    var planeCountX: Int!
    var planeCountY: Int!
    var startingPosition: SCNVector3!
    

    init (planeWidth: CGFloat, planeHeight: CGFloat, planeCountX: Int, planeCountY: Int) {
        
        super.init()
        
        self.planeWidth = planeWidth
        self.planeHeight = planeHeight
        self.planeCountX = planeCountX
        self.planeCountY = planeCountY
        
        let paddingX: Float = Float(planeWidth) * Float(planeCountX)/2
        let paddingY: Float = Float(planeHeight) * Float(planeCountY)/2
        println(paddingX)
        
        self.startingPosition = SCNVector3(x: -paddingX, y: -paddingY, z: -23) //Default
        
        var cellPosition = startingPosition
        
        for (var i=0; i<planeCountX; i++){
            
            var cellsX: [CellView] = []
            for (var j=0; j<planeCountY; j++){
                
                cellPosition.x = Float(CGFloat(i) * planeWidth) + startingPosition.x
                cellPosition.y = Float(CGFloat(j) * planeHeight) + startingPosition.y
                let cell = CellView(position: cellPosition, width: planeWidth, height: planeHeight, index: Index(x: i, y: j))
                cellsX.append(cell)
                
                addChildNode(cell)
            }
            cells.append(cellsX)
        }
        
        for cellX in cells {
            for cell in cellX {
                //println(cell.position.x)
            }
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}