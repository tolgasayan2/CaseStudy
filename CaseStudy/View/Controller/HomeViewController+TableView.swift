//
//  HomeViewController+TableView.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              UIScrollViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return detailViewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let customCell = CustomTableViewCell()
    let fullName = detailViewModel[indexPath.row].name
    let id = detailViewModel[indexPath.row].id
    customCell.isUserInteractionEnabled = false
    customCell.viewModel = CustomCellViewModel(name: fullName,
                                               id: id)
    customCell.makePagination(indexPath: indexPath,
                              arrayModel: self.detailViewModel) {
      viewModel.fetch(next: self.nextCounter,
                      isPagination: true)
    }
    return customCell
  }
}
