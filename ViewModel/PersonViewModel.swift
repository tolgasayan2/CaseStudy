//
//  PersonViewModel.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 22.03.2023.
//

import Foundation

protocol PersonDisplayLogic {
  func fetch()
}

class PersonViewModel: PersonDisplayLogic {
  
  let dataSource: DataSource
  
  init() {
    dataSource = DataSource()
  }
  
  func fetch() {
    let fetchCount = (Person.Constants.fetchCountRange.randomElement())
      dataSource.fetch(next: "10") { response, error in
        print(response)
        print(error)
      }
  }
}
