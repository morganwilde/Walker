//
//  ViewController.swift
//  pathTest
//
//  Created by Arūnas Seniucas on 5/2/15.
//  Copyright (c) 2015 Arūnas Seniucas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var array:Array<Array<Int>> = Array(count: 10, repeatedValue: Array(count: 30, repeatedValue: 0))
    var visitedArray:Array<Array<Bool>> = Array(count: 10, repeatedValue: Array(count: 30, repeatedValue: false))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var columns:Int = 10
        var rows:Int = 30
        
        
        for column in 0..<columns {
            for row in 0..<rows {
                if column == 0 || column == columns-1 || row == 0 || row == rows-1 {
                    array[column][row] = 1
                }
            }
        }
        array[1][2] = 1
        array[2][2] = 1
        array[2][3] = 1
        
        var startNode = Node(map: &array, closedMap: &visitedArray, g: CGPoint(x: 1, y: 7), p: CGPoint(x: 1,y: 1), l: 0)
        

        
        
        
        //startNode.getCoords()
        
        findPath(startNode)
        //println(array)
        
        for column in 0..<columns {
            for row in 0..<rows {
                print(array[column][row])
            }
            println()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func findPath(startNode: Node) -> Bool{
        
        var current = startNode
        
        //doesnt mark as visited
        visitedArray[Int(current.pos.y)][Int(current.pos.x)] = true
        
        if current.remain == 0 {
            println("Found path of length \(current.level)")
            return true
        }
        
        var possible = current.getNeighbors()
        
        var shortest:Int = current.remain + 2
        
        for neighbor in possible {
            if neighbor.remain < shortest {
                shortest = neighbor.remain
            }
        }
        
        for neighbor in possible {
            if neighbor.remain == shortest {
                if findPath(neighbor) {
                    return true
                }
            }
        }
        
        for neighbor in possible {
            if neighbor.remain == shortest + 1 {
                if findPath(neighbor) {
                    return true
                }
            }
        }
        
        return false
        
        
    }
    
    


}

