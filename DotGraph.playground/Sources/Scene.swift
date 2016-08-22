import SpriteKit

public class Scene: SKScene {
    var selection: RedDot?
    var previousLocation: CGPoint!
    
    public override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        if let dot = rootNode.nodes(at: location).filter({$0 is RedDot}).first as! RedDot? {
            selection = dot
            previousLocation = location
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        selection = nil
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let location = event.location(in: self)
        if let dot = selection {
            dot.run(SKAction.move(by: location - previousLocation, duration: 0))
            for line in dot.connectedLines {
                line.run(SKAction.customAction(withDuration: 0) { _, _ in
                    line.updateLength()
                })
            }
			drawPath()
        }
       previousLocation = location
    }
	
	var lines = Set<DirectedLine>()
	public var updateConnections: (() -> Set<DirectedLine>)?
	
	public func drawPath() {
		for line in lines {
			line.strokeColor = .darkGray
		}
		if let update = updateConnections {
			lines = update()
			for line in lines {
				line.strokeColor = .red
			}
		}
	}
}

extension CGPoint {
    public static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x-right.x, dy: left.y-right.y)
    }
}
