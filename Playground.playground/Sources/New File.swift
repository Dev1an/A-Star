import aStar
import SpriteKit
import PlaygroundSupport

public var rootNode = SKNode()

extension SKShapeNode {
    public func setup(x: CGFloat, y: CGFloat, label: String) -> SKShapeNode {
        (position.x, position.y) = (x, y)
        fillColor = .red
        rootNode.addChild(self)
       
        let label = SKLabelNode(text: label)
        label.fontSize = 12
        (label.position.x, label.position.y) = (x, y+3)
        label.fontColor = .red
        rootNode.addChild(label)
        
        return self
    }
}

public struct EndPoints: Hashable {
    public var source: SKShapeNode
    public var target: SKShapeNode
    
    public init(_ points: (SKShapeNode, SKShapeNode)) {
        (source, target) = points
    }
    
    public var hashValue: Int {
        return source.hashValue | target.hashValue
    }
    
    public static func ==(lhs: EndPoints, rhs: EndPoints) -> Bool {
        return (lhs.source, lhs.target) == (rhs.source, rhs.target)
    }
}
public var connections = Dictionary<EndPoints, SKShapeNode>()

public func directedLineBetween(endPoints: EndPoints) -> SKShapeNode {
    let (source, target) = (endPoints.source, endPoints.target)
    let shape = SKShapeNode()
    let line = CGMutablePath()
    line.move(to: source.position)
    line.addLine(to: target.position)
    
    let v1 = CGVector(dx: target.position.x-source.position.x, dy: target.position.y-source.position.y)
    let v2 = CGVector(dx: 0, dy: 1)
    let rotation = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
    
    let center = CGPoint(
        x: (target.position.x+source.position.x)/2,
        y: (target.position.y+source.position.y)/2
    )
    line.move(to: center)
    
    let c1 = CGFloat(  -M_PI_4) - rotation
    let c2 = CGFloat(-3*M_PI_4) - rotation
    
    line.addLine(to: CGPoint(x: center.x + 3*cos(c1), y: center.y + 3*sin(c1)))
    line.move(to: center)
    line.addLine(to: CGPoint(x: center.x + 3*cos(c2), y: center.y + 3*sin(c2)))
    
    shape.path = line
    shape.strokeColor = .darkGray
    rootNode.insertChild(shape, at: 0)
    return shape
}
