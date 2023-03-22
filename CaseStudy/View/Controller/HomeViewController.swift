//
//  ViewController.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import UIKit
protocol DisplayLogic: AnyObject {
  func displayTableView(viewModel: [Person.ViewModel])
  func getNext(next: String)
  func displayEmptyView()
}

final class HomeViewController: UIViewController, DisplayLogic {
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomTableViewCell.self,
                       forCellReuseIdentifier: CustomTableViewCell.identifier)
    return tableView
  }()
  
  let viewModel: PersonDisplayLogic = PersonViewModel()
  var detailViewModel: [Person.ViewModel] = .init()
  lazy var emptyView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    viewModel.fetch()
    viewModel.delegate(output: self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  private func prepareUI() {
    view.addSubview(tableView)
    setupTableView()
    setupEmptyView()
  }
  
  func setupTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func setupEmptyView() {
    let emptyLabel = UILabel()
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.backgroundColor = .white
    emptyLabel.translatesAutoresizingMaskIntoConstraints = false
    emptyLabel.font = .systemFont(ofSize: 15)
    emptyLabel.text = Person.Constants.emptyString
    emptyView.addSubview(emptyLabel)
    view.addSubview(emptyView)
    emptyView.isHidden = true
    
    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: view.topAnchor),
      emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      emptyLabel.heightAnchor.constraint(equalToConstant: 100),
      emptyLabel.widthAnchor.constraint(equalToConstant: 100),
      emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
      emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor)
    ])
  }
  
  func displayTableView(viewModel: [Person.ViewModel]) {
    self.detailViewModel = viewModel
    tableView.reloadData()
  }
  
  func displayEmptyView() {
    tableView.isHidden = true
    emptyView.isHidden = false
  }
  
  func getNext(next: String) {
    
  }
}

