//
//  Dimensions.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation

struct Dimensions {
    var width: Float // Y
    var height: Float // Z
    var length: Float // X
    
    init(width: Float, height: Float, length: Float) {
        self.width = width
        self.height = height
        self.length = length
    }
}