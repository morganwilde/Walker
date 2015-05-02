//
//  CharacterNode.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation
import SceneKit

class CharacterNode: SCNNode {
    // Model
    var character: Character
    
    init(character: Character) {
        self.character = character
        super.init()
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}