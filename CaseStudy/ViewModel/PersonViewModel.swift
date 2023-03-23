//
//  PersonViewModel.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 22.03.2023.
//

import Foundation

protocol PersonDisplayLogic {
  func fetch(next: String?)
  func delegate(output: DisplayLogic)
}

class PersonViewModel: PersonDisplayLogic {
  weak var viewController: DisplayLogic?
  let dataSource: DataSource
  
  init() {
    dataSource = DataSource()
  }
  
  func fetch(next: String?) {
      dataSource.fetch(next: next) { [weak self] response, error in
        guard let self = self, error == nil else {
          if let error = error {
            self?.viewController?.displayAlert(error: error)
          }
          return
        }
        self.handleResponse(response: response)
      }
  }
  
  private func handleResponse(response: Person.FetchResponse?) {
    if let people = response?.people {
      let personArray: [Person.ViewModel] = people.map({ person in
        let person = Person.ViewModel(name: person.fullName,
                                      id: person.id)
        return person
      })
      viewController?.displayTableView(viewModel: personArray)
      
      if let next = response?.next {
        viewController?.getNext(next: next)
      }
    } else {
      viewController?.displayEmptyView()
    }
  }
  
  func delegate(output: DisplayLogic) {
    viewController = output
  }
}
