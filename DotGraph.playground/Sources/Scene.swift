import SpriteKit
import Dispatch

let queue = DispatchQueue(label: "pathfinding", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)

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
	
	var calculation: DispatchWorkItem?
	public func drawPath() {
		if let update = updateConnections {
			calculation?.cancel()
			calculation = DispatchWorkItem(block: {
				let newLines = update()
				DispatchQueue.main.async {
					for line in self.lines {
						line.strokeColor = .darkGray
					}
					self.lines = newLines
					for line in self.lines {
						line.strokeColor = .red
					}
				}
			})
			queue.async(execute: calculation!)
		}
	}
}

extension CGPoint {
    public static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x-right.x, dy: left.y-right.y)
    }
}
