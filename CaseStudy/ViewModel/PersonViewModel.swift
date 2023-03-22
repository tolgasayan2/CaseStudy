//
//  PersonViewModel.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 22.03.2023.
//

import Foundation

protocol PersonDisplayLogic {
  func fetch()
  func delegate(output: DisplayLogic)
}

class PersonViewModel: PersonDisplayLogic {
  weak var viewController: DisplayLogic?
  let dataSource: DataSource
  
  init() {
    dataSource = DataSource()
  }
  
  func fetch() {
      dataSource.fetch(next: nil) { [weak self] response, error in
        guard let self = self, error == nil else {
          print(error?.rawValue as Any)
          return
        }
        self.handleResponse(response: response)
      }
  }
  
  private func handleResponse(response: Person.FetchResponse?) {
    if let response = response?.people {
      let personArray: [Person.ViewModel] = response.map({ person in
        let person = Person.ViewModel(name: person.fullName,
                                      id: person.id)
        return person
      })
      viewController?.displayTableView(viewModel: personArray)
    } else {
      viewController?.displayEmptyView()
    }
  }
  
  func delegate(output: DisplayLogic) {
    viewController = output
  }
}
