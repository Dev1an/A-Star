//: Playground - noun: a place where people can play
import aStar
import SpriteKit
import PlaygroundSupport

final class Node: RedDot, GraphNode {
    var connectedNodes = Set<Node>()
    
    func cost(to node: Node) -> Float {
        return Float(hypot(
            (position.x - node.position.x),
            (position.y - node.position.y)
        ))
    }
    
    func estimatedCost(to node: Node) -> Float {
        return cost(to: node)
    }
}

let view = SKView(frame: NSRect(x: 0, y: 0, width: 103, height: 103))
let scene = Scene(size: CGSize(width: 100, height: 100))

scene.scaleMode = SKSceneScaleMode.aspectFit
scene.backgroundColor = NSColor(red:0.97, green:0.97, blue:0.97, alpha:1.00)
//PlaygroundPage.current.liveView = view
view.presentScene(scene)

func createConnection(from source: Node, to target: Node) {
    source.connectedNodes.insert(target)
    DirectedLine(from: source, to: target)
}
rootNode.position = CGPoint(x: 3, y: 3)

let c1 = Node(x: 50, y: 0,  label: "1")
let c2 = Node(x: 50, y: 65, label: "2")
let c3 = Node(x: 30, y: 80, label: "3")
let c4 = Node(x: 65, y: 70, label: "4")
let c5 = Node(x: 90, y: 50, label: "5")

createConnection(from: c1, to: c3)
createConnection(from: c3, to: c4)
createConnection(from: c4, to: c2)

createConnection(from: c1, to: c5)
createConnection(from: c5, to: c2)
createConnection(from: c5, to: c4)

let path = c1.findPath(to: c2)
for index in 1..<path.count {
    connections[path[index-1]]?[path[index]]?.strokeColor = .red
}

scene.addChild(rootNode)
print("Hurray")