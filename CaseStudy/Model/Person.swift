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

public typealias FetchCompletionHandler = (FetchResponse?, FetchError?) -> ()

public class FetchResponse {
    let people: [Person]
    let next: String?
    
    init(people: [Person], next: String?) {
        self.people = people
        self.next = next
    }
}

public class Person {
    let id: Int
    let fullName: String
    
    init(id: Int, fullName: String) {
        self.id = id
        self.fullName = fullName
    }
}
