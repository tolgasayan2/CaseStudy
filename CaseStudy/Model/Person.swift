//
//  Person.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import Foundation


public enum FetchError: String {
    case internalError = "Internal Server Error"
    case parameterError = "Parameter error"
}

public struct Person {
  
  public enum Constants {
    static let peopleCountRange: ClosedRange<Int> = 100...200 // lower bound must be > 0
    static let fetchCountRange: ClosedRange<Int> = 5...20 // lower bound must be > 0
    static let lowWaitTimeRange: ClosedRange<Double> = 0.0...0.3 // lower bound must be >= 0.0
    static let highWaitTimeRange: ClosedRange<Double> = 1.0...2.0 // lower bound must be >= 0.0
    static let errorProbability = 0.05 // must be > 0.0
    static let backendBugTriggerProbability = 0.05 // must be > 0.0
    static let emptyFirstResultsProbability = 0.1 // must be > 0.0
    static let emptyString = "No one here :)"
  }
 
  public class FetchResponse {
      let people: [PersonInfo]
      let next: String?
      
      init(people: [PersonInfo], next: String?) {
          self.people = people
          self.next = next
      }
  }

  public class PersonInfo {
      let id: Int
      let fullName: String
      
      init(id: Int, fullName: String) {
          self.id = id
          self.fullName = fullName
      }
  }
  
  struct ViewModel {
    let name: String
    let id: Int
  }
}




