//
//  HomeViewController+TableView.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let customCell = CustomTableViewCell()
    let viewModel = CustomCellViewModel(name: "Mustafa Ali Yilmaz", id: "(30)")
    customCell.viewModel = viewModel
    return customCell
  }
}
