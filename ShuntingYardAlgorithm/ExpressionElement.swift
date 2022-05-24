//
//  ExpressionElement.swift
//  ShuntingYardAlgorithm
//
//  Created by Szymon Kaszuba-Gałka on 24/05/2022.
//

import Foundation

protocol ExpressionElement {
    func get() -> String
    func set(value: String) -> Void
}
