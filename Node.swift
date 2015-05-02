//
//  Node.swift
//  pathTest
//
//  Created by Arūnas Seniucas on 5/2/15.
//  Copyright (c) 2015 Arūnas Seniucas. All rights reserved.
//

import UIKit

class Node {
    
    //detects walls, but for some reason walks over some instead of walking around it
    //can get stuck in between walls though
    
    var array:Array<Array<Int>>
    var visitedArray:Array<Array<Bool>>
    var goal: CGPoint
    var pos: CGPoint
    
    var level:Int
    var remain:Int
    
    
    init(inout map:Array<Array<Int>>, inout closedMap:Array<Array<Bool>>, g:CGPoint, p:CGPoint, l: Int) {
        array = map
        visitedArray = closedMap
        goal = g
        pos = p
        level = l
        
        remain = (abs(Int(goal.x)) - abs(Int(pos.x))) + (abs(Int(goal.y)) - abs(Int(pos.y)))
        
        
        
        println("node at \(Int(pos.x)),\(Int(pos.y))")
        if (array[Int(pos.y)][Int(pos.x+1)] == 1) {
           println("Im standing next to a wall")
        }
        
    }
    
    func getCoords(){
        println("Current coordinates: \(array[Int(pos.x)][Int(pos.y+1)] == 1)")
    }
    
    func getNeighbors() -> [Node]{
        
        var neighbors:[Node] = []
        
        if array[Int(pos.y+1)][Int(pos.x)] == 0 && visitedArray[Int(pos.y+1)][Int(pos.x)] == false{
            neighbors.append(Node(map: &array, closedMap: &visitedArray, g: goal, p: CGPoint(x: pos.x+1, y: pos.y),  l: level+1))
        }
        else if array[Int(pos.y-1)][Int(pos.x)] == 0 &&  visitedArray[Int(pos.y-1)][Int(pos.x    )] == false {
            neighbors.append(Node(map: &array, closedMap: &visitedArray, g: goal, p: CGPoint(x: pos.x-1, y: pos.y),  l: level+1))
        }
        else if array[Int(pos.y)][Int(pos.x+1)] == 0 && visitedArray[Int(pos.y)][Int(pos.x+1)] == false {
            neighbors.append(Node(map: &array, closedMap: &visitedArray, g: goal, p: CGPoint(x: pos.x, y: pos.y+1),  l: level+1))
        }
        else if array[Int(pos.y)][Int(pos.x-1)] == 0 && visitedArray[Int(pos.y)][Int(pos.x-1)] == false {
            neighbors.append(Node(map: &array, closedMap: &visitedArray, g: goal, p: CGPoint(x: pos.x, y: pos.y-1),  l: level+1))
        }
        
        return neighbors
    }
    
    
    
    
    
    
}
