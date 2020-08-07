import SwiftUI

public struct BoardView: View {
	let size = Board.Size(rows: 8, columns: 8)

	@State var mode = Mode.editBlocks

	@State var walls: Set = [35]
	@State var start = 32
	@State var end = 39

	public init() {}

	public var body: some View {
		func blockColor(for block: Int) -> Color {
			if walls.contains(block) { return .secondary }
			if path.contains(block)  { return .accentColor }
			else                     { return .grid }
		}
		let board = Board(size: size, walls: walls)
		let path = board.findPath(from: start, to: end)

		return VStack {
			HStack {
				Text("Edit:")
				Picker(selection: $mode, label: Text("Picker")) {
					Text("Blocks").tag(Mode.editBlocks)
					Text("Start point").tag(Mode.editStart)
					Text("End point").tag(Mode.editEnd)
				}.pickerStyle(SegmentedPickerStyle())
			}.padding()
			VStack {
				ForEach(0..<size.rows) { row in
					HStack {
						ForEach(row*size.columns ..< (row+1)*size.columns) { number in
							Rectangle()
								.frame(width: 20, height: 20)
								.foregroundColor(blockColor(for: number))
								.onTapGesture { edit(number: number) }
						}
					}
				}
			}
			Text("Path length: \(path.count)").padding(.bottom)
		}
	}

	enum Mode {
		case editStart, editEnd, editBlocks
	}

	func edit(number: Int) {
		switch mode {
		case .editStart:
			start = number
			walls.remove(number)
		case .editEnd:
			end = number
			walls.remove(number)
		case .editBlocks:
			if walls.contains(number) {
				walls.remove(number)
			} else if number != start && number != end {
				walls.insert(number)
			}
		}
	}
}

extension Color {
	#if os(iOS)
	static let grid = Color(UIColor.tertiarySystemFill)
	#elseif os(macOS)
	static let grid = Color(NSColor.controlBackgroundColor)
	#endif
}
