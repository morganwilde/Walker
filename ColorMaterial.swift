//
//  ColorMaterial.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation
import SceneKit

class ColorMaterial: SCNMaterial {
    
    init(_ color: UIColor) {
        super.init()
        diffuse.contents = color
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}