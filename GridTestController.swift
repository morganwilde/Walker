//
//  ViewController.swift
//  Walker
//
//  Created by Morgan Wilde on 02/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import UIKit
import SceneKit

class GridTestController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SceneView settings
        sceneView.backgroundColor = UIColor.blackColor()
        sceneView.autoenablesDefaultLighting = true
        sceneView.showsStatistics = true
        
        // Scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        var objects: [Object]?
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onCellActivated", name: "identifier", object: nil)
        
        let grid = Grid(cellCountX: 10, cellCountY: 10)
        println(grid.cells[0].count)
        grid.cells[0][0].activated = true
//        scene.rootNode.addChildNode(GridModel(width: 10, height: 10))
    }
    
    func onCellActivated(notification: NSNotification) {
        println("received notification: \(notification)")
    }
    
}

