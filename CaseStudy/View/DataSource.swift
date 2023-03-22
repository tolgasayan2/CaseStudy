//
//  DataSource.swift
//  CaseStudy
//
//  Created by Ovunc Dalkiran on 01.01.2021.

import Foundation

public extension DataSource {
  typealias FetchCompletionHandler = (Person.FetchResponse?, FetchError?) -> ()
}

public class DataSource {
  
  public enum Constants {
    static let peopleCountRange: ClosedRange<Int> = 100...200 // lower bound must be > 0
    static let fetchCountRange: ClosedRange<Int> = 5...20 // lower bound must be > 0
    static let lowWaitTimeRange: ClosedRange<Double> = 0.0...0.3 // lower bound must be >= 0.0
    static let highWaitTimeRange: ClosedRange<Double> = 1.0...2.0 // lower bound must be >= 0.0
    static let errorProbability = 0.05 // must be > 0.0
    static let backendBugTriggerProbability = 0.05 // must be > 0.0
    static let emptyFirstResultsProbability = 0.1 // must be > 0.0
  }
  
  private var people: [Person.PersonInfo] = []
  private let operationsQueue = DispatchQueue.init(
    label: "data_source_operations_queue",
    qos: .background,
    attributes: [],
    autoreleaseFrequency: .inherit,
    target: nil
  )
  
  public func fetch(next: String?, _ completionHandler: @escaping FetchCompletionHandler) {
    DispatchQueue.global().async {
      self.operationsQueue.sync {
        self.initializeDataIfNecessary()
        let (response, error, waitTime) = self.processRequest(next)
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
          completionHandler(response, error)
        }
      }
    }
  }
  
  private func initializeDataIfNecessary() {
    guard people.isEmpty else { return }
    
    var newPeople: [Person.PersonInfo] = []
    let peopleCount: Int = RandomUtils.generateRandomInt(inClosedRange: Constants.peopleCountRange)
    for index in 0..<peopleCount {
      let firstNames: [String] = DataResponse.PeopleGen.firstNames
      let lastNames: [String] = DataResponse.PeopleGen.firstNames
      let fullName: String = ""
      let person = Person.PersonInfo(id: index + 1, fullName: fullName.generateRandomDoubleString(firstArray: firstNames,
                                                                                                  secondArray: lastNames))
      newPeople.append(person)
    }
    
    people = newPeople.shuffled()
  }
  
  private func processRequest(_ next: String?) -> (Person.FetchResponse?, FetchError?, Double) {
    var error: FetchError? = nil
    var response: Person.FetchResponse? = nil
    let isError = RandomUtils.roll(forProbabilityGTZero: Constants.errorProbability)
    var waitTime: Double!
    
    if isError {
      waitTime = RandomUtils.generateRandomDouble(inClosedRange: Constants.lowWaitTimeRange)
      error = FetchError.internalError
    }
    else {
      waitTime = RandomUtils.generateRandomDouble(inClosedRange: Constants.highWaitTimeRange)
      let fetchCount = RandomUtils.generateRandomInt(inClosedRange: Constants.fetchCountRange)
      let peopleCount = people.count
      
      if let next = next, (Int(next) == nil || Int(next)! < 0) {
        error = FetchError.parameterError
      }
      else {
        let endIndex: Int = min(peopleCount, fetchCount + (next == nil ? 0 : (Int(next!) ?? 0)))
        let beginIndex: Int = next == nil ? 0 : min(Int(next!)!, endIndex)
        var responseNext: String? = endIndex >= peopleCount ? nil : String(endIndex)
        
        var fetchedPeople: [Person.PersonInfo] = Array(people[beginIndex..<endIndex])
        if beginIndex > 0 && RandomUtils.roll(forProbabilityGTZero: Constants.backendBugTriggerProbability) {
          fetchedPeople.insert(people[beginIndex - 1], at: 0)
        }
        else if beginIndex == 0 && RandomUtils.roll(forProbabilityGTZero: Constants.emptyFirstResultsProbability) {
          fetchedPeople = []
          responseNext = nil
        }
        response = Person.FetchResponse(people: fetchedPeople,
                                        next: responseNext)
      }
    }
    
    return (response, error, waitTime)
  }
}

