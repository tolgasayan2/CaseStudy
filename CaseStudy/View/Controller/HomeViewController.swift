//
//  ViewController.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import UIKit

final class HomeViewController: UIViewController {
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomTableViewCell.self,
                       forCellReuseIdentifier: CustomTableViewCell.identifier)
    return tableView
  }()
  
  let viewModel: PersonDisplayLogic = PersonViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    viewModel.fetch()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  private func prepareUI() {
    view.addSubview(tableView)
    setupTableView()
  }
  
  func setupTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
  }
}

