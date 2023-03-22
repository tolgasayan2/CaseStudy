//
//  RandomUtils.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 22.03.2023.
//

import Foundation

public class RandomUtils {
  
  class func generateRandomInt(inClosedRange range: ClosedRange<Int>) -> Int {
    return Int.random(in: range)
  }
  
  class func generateRandomInt(inRange range: Range<Int>) -> Int {
    return Int.random(in: range)
  }
  
  
  class func generateRandomDouble(inClosedRange range: ClosedRange<Double>) -> Double {
    return Double.random(in: range)
  }
  
  class func roll(forProbabilityGTZero probability: Double) -> Bool {
    let random = Double.random(in: 0.0...1.0)
    return random <= probability
  }
  

}
