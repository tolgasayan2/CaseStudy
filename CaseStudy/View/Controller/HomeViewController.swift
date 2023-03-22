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
  
  private let viewModel = HomeViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
  }
  
  private func prepareUI() {
    tableView.frame = view.bounds
    view.addSubview(tableView)
    setupTableView()
  }
  
  func setupTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
  }
}

