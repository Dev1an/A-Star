import AStar

public struct Board: Graph {
	public typealias Node = Int

	let size: Size
	let walls: Set<Int>

	public struct Size {
		let rows: Int
		let columns: Int
		let tileCount: Int

		public init(rows: Int, columns: Int) {
			self.rows = rows
			self.columns = columns
			tileCount = rows * columns
		}
	}

	enum Side: CaseIterable {
		case up, down, left, right//, upLeft, upRight, downLeft, downRight
	}

	func neighbour(of tile: Int, side: Side) -> Int? {
		let position: Int
		switch side {
		case .up:
			position = tile - size.columns
			guard position >= 0 else { return nil }
		case .down:
			position = tile + size.columns
			guard position < size.tileCount else { return nil }
		case .left:
			guard tile % size.columns > 0 else { return nil }
			position = tile - 1
		case .right:
			position = tile + 1
			guard position % size.columns != 0 else { return nil }
		}
		return position
	}

	public func nodesAdjacent(to node: Node) -> Set<Node> {
		Set(
			Side.allCases
				.compactMap { direction in neighbour(of: node, side: direction) }
				.filter { neighbour in !walls.contains(neighbour) }
		)
	}

	public func estimatedCost(from start: Node, to end: Node) -> Float {
		let (width, height) = difference(between: start, and: end)
		return Float(width*width + height*height).squareRoot()
	}

	public func cost(from start: Node, to end: Node) -> Float {
		let (width, height) = difference(between: start, and: end)
		return Float(width + height + 1)
	}

	func difference(between start: Node, and end: Node) -> (horizontal: Node, vertical: Node) {
		let width = abs(start%size.columns - end%size.columns)
		let height = abs(start/size.columns - end/size.columns)
		return (width, height)
	}
}
