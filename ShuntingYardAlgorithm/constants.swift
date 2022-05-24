//
//  constants.swift
//  ShuntingYardAlgorithm
//
//  Created by Szymon Kaszuba-Gałka on 24/05/2022.
//

import Foundation

let operators: [String] = ["^", "*", "/", "-", "+", "(", ")"]

let precedenceDict: [String:Int] = [
    "(": 5,
    ")": 5,
    "^": 4,
    "*": 3,
    "/": 3,
    "-": 2,
    "+": 2
]

let operatorEnumDict: [String:OperatorEnum] = [
    "^": OperatorEnum.power,
    "*": OperatorEnum.multiply,
    "/": OperatorEnum.divide,
    "-": OperatorEnum.substract,
    "+": OperatorEnum.add,
    "(": OperatorEnum.leftBrace,
    ")": OperatorEnum.rightBrace,
]
