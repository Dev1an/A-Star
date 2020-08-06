//
//  Step+Comparable.swift
//  
//
//  Created by Damiaan on 06/08/2020.
//

extension Step: Hashable, Equatable, Comparable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(node)
	}

	static func ==(lhs: Step, rhs: Step) -> Bool {
		return lhs.node == rhs.node
	}

	public static func <(lhs: Step, rhs: Step) -> Bool {
		return lhs.cost() < rhs.cost()
	}

	public static func <=(lhs: Step, rhs: Step) -> Bool {
		return lhs.cost() <= rhs.cost()
	}

	public static func >=(lhs: Step, rhs: Step) -> Bool {
		return lhs.cost() >= rhs.cost()
	}

	public static func >(lhs: Step, rhs: Step) -> Bool {
		return lhs.cost() > rhs.cost()
	}

}
