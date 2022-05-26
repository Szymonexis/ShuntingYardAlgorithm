//
//  main.swift
//  ShuntingYardAlgorithm
//
//  Created by Szymon Kaszuba-Gałka on 24/05/2022.
//

import Foundation

class ShuntingYardAlgo {
    private var values: [ExpressionElement] = []
    private var isRpn: Bool = false
    private var output: [ExpressionElement] = []
    private var opStack: [Operator] = []
    private var valuesStack: [Number] = []

    init(expression: String) {
        self.generateValuesArray(expression: expression)
    }
    
    public func setNewExpression(expression: String) -> Void {
        clearAll()
        generateValuesArray(expression: expression)
    }
    
    // returns the value of expression or -0.0 if an error occured
    public func solve(
        showRpn: Bool? = false,
        showIsRpn: Bool? = false
    ) -> Float {
        shunt()
        showIsRpn != nil && showIsRpn! ? print("isRpn: \(isRpn)") : nil
        showRpn != nil && showRpn! && isRpn ? print("RPN stream: \(output)") : nil
        return solveRpn()
    }
    
    public func printCurrentState(
        printOutput: Bool? = true,
        printOpStack: Bool? = true,
        printValues: Bool? = true,
        printValuesStack: Bool? = false,
        value: String? = nil,
        text: String? = nil
    ) -> Void {
        if (printOutput != nil && printOutput!) {
            print("output: \(output)")
        }
        if (printOpStack != nil && printOpStack!) {
            print("opStack: \(opStack)")
        }
        if (printValues != nil && printValues!) {
            print("values: \(values)")
        }
        if (printValuesStack != nil && printValuesStack!) {
            print("valuesStack: \(valuesStack)")
        }
        if (value != nil) {
            print("Current value: \(value!)")
        }
        if (text != nil) {
            print(text!)
        }
    }
    
    private func clearAll() -> Void {
        values = []
        isRpn = false
        output = []
        opStack = []
        valuesStack = []
    }
    
    private func generateValuesArray(expression: String) -> Void {
        let elements = convertNegativeNumbers(substrings: expression.split(separator: " "))
        
        for element in elements {
            if (operators.contains(element)) {
                values.append(Operator(value: element))
            } else {
                values.append(Number(value: element))
            }
        }
    }
    
    private func convertNegativeNumbers(substrings: [String.SubSequence]) -> [String] {
        var strings: [String] = []
        
        var thisElem: String.SubSequence? = nil
        var prevElem: String.SubSequence? = nil
        
        for (index, element) in substrings.enumerated() {
            prevElem = thisElem
            thisElem = element
            
            if (thisElem == "-") {
                if (index == 0) {
                    strings.append("0")
                    strings.append(String(thisElem!))
                } else if (prevElem == "(") {
                    strings.append("0")
                    strings.append(String(thisElem!))
                } else {
                    strings.append(String(thisElem!))
                }
            } else {
                strings.append(String(thisElem!))
            }
        }
        
        return strings
    }
    
    // carries out the conversion from expression to RPN sequence
    private func shunt() -> Void {
        for value in values {
            if (value is Number) {
                output.append(value)
            } else {
                let op: Operator = Operator(value: value.get())
                if (opStack.isEmpty || op.get() == "(") {
                    opStack.append(op)
                } else {
                    if (op.get() == ")") {
                        var lastOperator = opStack.popLast()
                        while (lastOperator!.get() != "(") {
                            output.append(lastOperator!)
                            lastOperator = opStack.popLast()
                        }
                    } else if (op.getPrecedence() > opStack.last!.getPrecedence()
                               || opStack.last!.getPrecedence() == 0) {
                        opStack.append(op)
                    } else {
                        var lastOperator = opStack.last
                        while(lastOperator != nil
                              && op.getPrecedence() <= lastOperator!.getPrecedence()) {
                            output.append(opStack.popLast()!)
                            lastOperator = opStack.last
                        }
                        opStack.append(op)
                    }
                }
            }
        }
        
        while (!opStack.isEmpty) {
            let op = opStack.popLast()!;
            output.append(op)
        }
        
        checkForErrors()
    }
    
    private func checkForErrors() -> Void {
        var numberCount = 0
        var operatorCount = 0
        
        for value in output {
            operatorCount = value is Operator ? operatorCount + 1 : operatorCount
            numberCount = value is Number ? numberCount + 1 : numberCount
        }
        
        isRpn = numberCount == operatorCount + 1;
    }
    
    // returns the value of expression or -0.0 if an error occured
    private func solveRpn() -> Float {
        if (isRpn) {
            for value in output {
                if (value is Number) {
                    valuesStack.append(Number(value: value.get()))
                } else {
                    let rightValue = valuesStack.popLast()!
                    let leftValue = valuesStack.popLast()!
                    
                    let rightValueFloat = Float(rightValue.get())!
                    let leftValueFloat = Float(leftValue.get())!
                    var result: Float = 0.0
                    
                    let op: OperatorEnum = operatorEnumDict[value.get()]!
                    
                    switch op {
                    case .power:
                        if (leftValueFloat == 0 && rightValueFloat == 0) {
                            return -0.0
                        }
                        result = pow(leftValueFloat, rightValueFloat)
                        break
                    case .multiply:
                        result = leftValueFloat * rightValueFloat
                        break
                    case .divide:
                        if (rightValueFloat == 0) {
                            return -0.0
                        }
                        result = leftValueFloat / rightValueFloat
                        break
                    case .add:
                        result = leftValueFloat + rightValueFloat
                        break
                    case .substract:
                        result = leftValueFloat - rightValueFloat
                        break
                    case .leftBrace:
                        break
                    case .rightBrace:
                        break
                    }
                    
                    valuesStack.append(Number(value: String(result)))
                }
            }
            return Float(valuesStack.popLast()!.get())!
        }
        return -0.0;
    }
}

// shunting yard algorithm example
var expression = "- 2 + 3 * 4 - 5 + 7 * 6 / 3 - 2 * 3 ^ 2 + ( 5 - 2 ) * 2 * ( - 3 )"
var shuntingYardAlgo = ShuntingYardAlgo(expression: expression)
print("\(expression) = \(shuntingYardAlgo.solve())")
