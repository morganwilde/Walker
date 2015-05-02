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
        
        var obstacles: [Obstacle]?
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onCellActivated:", name: CELL_ACTIVATION_NOTIFIER, object: nil)
        
        let grid = Grid()
        grid.cells[1].activated = true
        grid.cells[1].activated = false
    }
    
    func onCellActivated(notification: NSNotification) {
        println("received notification: \(notification.object!)")
    }
    
}

