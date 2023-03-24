//
//  PersonViewModel.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 22.03.2023.
//

import Foundation

protocol PersonDisplayLogic {
  func fetch(next: String?,
             isPagination: Bool)
  func delegate(output: DisplayLogic)
}

class PersonViewModel: PersonDisplayLogic {
  weak var viewController: DisplayLogic?
  let dataSource: DataSource
  
  init() {
    dataSource = DataSource()
  }
  
  func fetch(next: String?,
             isPagination: Bool) {
    dataSource.fetch(next: next) { [weak self] response, error in
      guard let self = self, error == nil else {
        if let error = error {
          self?.viewController?.displayAlert(error: error)
        }
        return
      }
      self.handleResponse(response: response,
                          isPagination: isPagination)
    }
  }
  
  private func handleResponse(response: Person.FetchResponse?,
                              isPagination: Bool) {
    guard let people = response?.people else {
      viewController?.displayEmptyView()
      return
    }
  
    if isPagination {
      var detailViewModel = viewController?.detailViewModel
      people.forEach { person in
        let person = Person.ViewModel(name: person.fullName,
                                                   id: person.id)
        detailViewModel?.append(person)
      }
      viewController?.displayTableView(viewModel: detailViewModel ?? [])
    } else {
      let personArray: [Person.ViewModel] = people.map({ person in
        let person = Person.ViewModel(name: person.fullName,
                                      id: person.id)
        return person
      })
      viewController?.displayTableView(viewModel: personArray)
    }
    if let next = response?.next {
      viewController?.getNext(next: next)
    }
  }
  
  func delegate(output: DisplayLogic) {
    viewController = output
  }
}
