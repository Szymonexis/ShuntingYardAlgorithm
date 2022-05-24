//
//  Number.swift
//  ShuntingYardAlgorithm
//
//  Created by Szymon Kaszuba-Gałka on 24/05/2022.
//

import Foundation

class Number: ExpressionElement, CustomStringConvertible {
    var val: Float
    
    init(value: String) {
        val = Float(value)!
    }
    
    func get() -> String {
        return String(val)
    }
    
    func set(value: String) -> Void {
        val = Float(value)!
    }
    
    public var description: String { return "\(val)" }
}
