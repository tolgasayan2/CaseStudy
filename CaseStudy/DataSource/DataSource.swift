//
//  DataSource.swift
//  CaseStudy
//
//  Created by Ovunc Dalkiran on 01.01.2021.

import Foundation


protocol DataSourceNetworking {
  typealias FetchCompletionHandler = (Person.FetchResponse?, FetchError?) -> ()
  func fetch(next: String?, _ completionHandler: @escaping FetchCompletionHandler)
}

public class DataSource: DataSourceNetworking {
  public typealias FetchCompletionHandler = (Person.FetchResponse?, FetchError?) -> ()
  private var people: [Person.PersonInfo] = []
  private let operationsQueue = OperationQueue()
  
  public func fetch(next: String?, _ completionHandler: @escaping FetchCompletionHandler) {
    let operation1 = BlockOperation {
      self.initializeDataIfNecessary()
    }
    
    let operation2 = BlockOperation {
      
      let (response, error, waitTime) = self.processRequest(next)

      DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
        completionHandler(response, error)
      }
    }
    operation2.addDependency(operation1)
    operationsQueue.addOperations([operation1, operation2], waitUntilFinished: true)
    operationsQueue.maxConcurrentOperationCount = 1
    operationsQueue.qualityOfService = .background
  }
  
  private func initializeDataIfNecessary() {
    guard people.isEmpty else { return }
    
    var newPeople: [Person.PersonInfo] = []
    let peopleCount: Int = RandomUtils.generateRandomInt(inClosedRange: Person.Constants.peopleCountRange)
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
    let isError = RandomUtils.roll(forProbabilityGTZero: Person.Constants.errorProbability)
    var waitTime: Double!
    
    if isError {
      waitTime = RandomUtils.generateRandomDouble(inClosedRange: Person.Constants.lowWaitTimeRange)
      error = FetchError.internalError
    }
    else {
      waitTime = RandomUtils.generateRandomDouble(inClosedRange: Person.Constants.highWaitTimeRange)
      let fetchCount = RandomUtils.generateRandomInt(inClosedRange: Person.Constants.fetchCountRange)
      let peopleCount = people.count
      
      if let next = next, (Int(next) == nil || Int(next)! < 0) {
        error = FetchError.parameterError
      }
      else {
        let endIndex: Int = min(peopleCount, fetchCount + (next == nil ? 0 : (Int(next!) ?? 0)))
        let beginIndex: Int = next == nil ? 0 : min(Int(next!)!, endIndex)
        var responseNext: String? = endIndex >= peopleCount ? nil : String(endIndex)
        
        var fetchedPeople: [Person.PersonInfo] = Array(people[beginIndex..<endIndex])
        if beginIndex > 0 && RandomUtils.roll(forProbabilityGTZero: Person.Constants.backendBugTriggerProbability) {
          fetchedPeople.insert(people[beginIndex - 1], at: 0)
        }
        else if beginIndex == 0 && RandomUtils.roll(forProbabilityGTZero: Person.Constants.emptyFirstResultsProbability) {
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

