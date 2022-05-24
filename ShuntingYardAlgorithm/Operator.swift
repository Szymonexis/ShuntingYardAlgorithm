//
//  Operator.swift
//  ShuntingYardAlgorithm
//
//  Created by Szymon Kaszuba-Gałka on 24/05/2022.
//

import Foundation

class Operator: ExpressionElement, CustomStringConvertible {
    var val: String
    
    init(value: String) {
        val = value
    }
    
    func get() -> String {
        return val
    }
    
    func set(value: String) -> Void {
        val = value
    }
    
    func getPrecedence() -> Int {
        if (val != "(" && val != ")") {
            return precedenceDict[val]!
        }
        return 0
    }
    
    public var description: String { return "\(val)" }
}
