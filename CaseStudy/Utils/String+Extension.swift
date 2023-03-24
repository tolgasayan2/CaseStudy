//
//  String+Extension.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 22.03.2023.
//

import Foundation


public extension Optional where Wrapped == String {
  var stringValue: String {
    return self ?? ""
  }
  
  var intValue: Int {
    return Int(stringValue) ?? 0
  }
}

public extension String {
  
  func generateRandomDoubleString(firstArray: [String],
                              secondArray: [String]) -> String {
    let firstArrayCount = firstArray.count
    let secondArrayCount = secondArray.count
    let firstArrayIndex = RandomUtils.generateRandomInt(inRange: 0..<firstArrayCount)
    let secondArrayIndex = RandomUtils.generateRandomInt(inRange: 0..<secondArrayCount)
    let firstString = firstArray[firstArrayIndex]
    let secondString = secondArray[secondArrayIndex]
    
    return "\(firstString) \(secondString)"
  }
}
