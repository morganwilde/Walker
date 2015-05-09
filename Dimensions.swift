//
//  Dimensions.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation
import UIKit

struct Dimensions {
    let width: CGFloat // Y
    let height: CGFloat // Z
    let length: CGFloat // X

    init(width: CGFloat, height: CGFloat, length: CGFloat) {
        self.width = width
        self.height = height
        self.length = length
    }
}