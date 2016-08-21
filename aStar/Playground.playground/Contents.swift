//: Playground - noun: a place where people can play

import aStar
import SpriteKit
import PlaygroundSupport

final class Simple2DNode: SKShapeNode, GraphNode {
    var connectedNodes = Set<Simple2DNode>()
    
    func cost(to node: Simple2DNode) -> Float {
        return Float(hypot((position.x - node.position.x), (position.y - node.position.y)))
    }
    
    func estimatedCost(to node: Simple2DNode) -> Float {
        return cost(to: node)
    }
}

let view = SKView(frame: NSRect(x: 0, y: 0, width: 103, height: 103))
PlaygroundPage.current.liveView = view

let scene = SKScene(size: CGSize(width: 100, height: 100))
scene.scaleMode = SKSceneScaleMode.aspectFit
view.presentScene(scene)

scene.backgroundColor = NSColor(red:0.97, green:0.97, blue:0.97, alpha:1.00)

var nodes = SKNode()
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
nodes.position = CGPoint(x: 3, y: 3)

let c1 = createCircle(x: 50, y: 0)
let c2 = createCircle(x: 50, y: 65)
let c3 = createCircle(x: 30, y: 80)
let c4 = createCircle(x: 65, y: 70)
let c5 = createCircle(x: 65, y: 50)

createConnection(from: c1, to: c3)
createConnection(from: c3, to: c4)
createConnection(from: c4, to: c2)

createConnection(from: c1, to: c5)
createConnection(from: c5, to: c2)

//c1.findPath(to: c4)

scene.addChild(nodes)
