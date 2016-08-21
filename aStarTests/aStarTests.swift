//
//  aStarTests.swift
//  aStarTests
//
//  Created by Damiaan Dufaux on 19/08/16.
//  Copyright © 2016 Damiaan Dufaux. All rights reserved.
//

import XCTest
@testable import aStar
import SpriteKit

final class Simple2DNode: SKShapeNode, GraphNode {
    var connectedNodes = Set<Simple2DNode>()
    
    func cost(to node: Simple2DNode) -> Float {
        return Float(hypot((position.x - node.position.x), (position.y - node.position.y)))
    }
    
    func estimatedCost(to node: Simple2DNode) -> Float {
        return cost(to: node)
    }
    
    override var description: String {
        return position.debugDescription
    }
}


class aStarTests: XCTestCase {
    var nodes = SKNode()

    var c1, c2, c3, c4, c5: Simple2DNode!
    
    func createCircle(x: CGFloat, y: CGFloat) -> Simple2DNode {
        let circle = Simple2DNode(circleOfRadius: 3)
        (circle.position.x, circle.position.y) = (x, y)
        circle.fillColor = .red
        nodes.addChild(circle)
        return circle
    }
    
    func createConnection(from source: Simple2DNode, to target: Simple2DNode) {
        source.connectedNodes.insert(target)
        let shape = SKShapeNode()
        let line = CGMutablePath()
        line.move(to: source.position)
        line.addLine(to: target.position)
        shape.path = line
        shape.strokeColor = .darkGray
        nodes.insertChild(shape, at: 0)
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        nodes.position = CGPoint(x: 3, y: 3)
        
        c1 = createCircle(x: 50, y: 0)
        c2 = createCircle(x: 50, y: 65)
        c3 = createCircle(x: 30, y: 80)
        c4 = createCircle(x: 65, y: 70)
        c5 = createCircle(x: 65, y: 50)
        
        createConnection(from: c1, to: c3)
        createConnection(from: c3, to: c4)
        createConnection(from: c4, to: c2)
        
        createConnection(from: c1, to: c5)
        createConnection(from: c5, to: c2)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStraightPath() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let path = c1.findPath(to: c3)
        XCTAssertEqual(path[0], c1)
        XCTAssertEqual(path[1], c3)
    }

    func testTwoSegmentPath() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let path = c1.findPath(to: c4)
        XCTAssertEqual(path[0], c1)
        XCTAssertEqual(path[1], c3)
        XCTAssertEqual(path[2], c4)
    }
    
    func testOptimalPath() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let path = c1.findPath(to: c2)
        print(path)
        XCTAssertEqual(path[0], c1)
        XCTAssertEqual(path[1], c5)
        XCTAssertEqual(path[2], c2)
        
        (c3.position.x, c3.position.y) = (50, 20)
        (c4.position.x, c4.position.y) = (60, 50)
        let otherPath = c1.findPath(to: c2)
        print(otherPath)
        XCTAssertEqual(otherPath[0], c1)
        XCTAssertEqual(otherPath[1], c3)
        XCTAssertEqual(otherPath[2], c4)
        XCTAssertEqual(otherPath[3], c2)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
