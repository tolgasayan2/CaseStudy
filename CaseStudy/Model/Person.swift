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
  
  struct PersonViewModel {
    let name: String
    let id: String
  }
  
  enum Section {
    case person(viewModel: Person.PersonViewModel)
  }
}




