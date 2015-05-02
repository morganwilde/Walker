//
//  WallObstacle.swift
//  Walker
//
//  Created by Tautvydas Stakėnas on 5/2/15.
//  Copyright (c) 2015 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import SceneKit

class WallObstacle: SCNNode {

    
    init(cell: CellView) {
        
        let box = SCNBox(width: 10, height: 10, length: 20, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 255, green: 0, blue: 0, alpha: 0.9)
        material.diffuse.borderColor = UIColor(red: 0, green: 25, blue: 255, alpha: 0.9)
        
        box.firstMaterial = material
        
        super.init()
        geometry = box
        self.position = SCNVector3(x: Float(cell.index.x*10), y: Float(cell.index.y*10), z: Float(-20))
        println(Int(position.x), Int(position.y))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}