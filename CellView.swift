//
//  Cell.swift
//  Walker
//
//  Created by Tautvydas Stakėnas on 5/2/15.
//  Copyright (c) 2015 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import SceneKit

class CellView: SCNNode {
    
    var box: SCNBox!
    var index: Index!
//    var width: Float32
//    var height: Float32
    
    init(position: SCNVector3, width: CGFloat, height: CGFloat, index: Index){
        
        self.index = index
        box = SCNBox(width: width, height: height, length: 1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 0, green: 0, blue: 255, alpha: 0.5)
        material.diffuse.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        box.firstMaterial = material
        
        super.init()
        geometry = box
        self.position = position
        
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}