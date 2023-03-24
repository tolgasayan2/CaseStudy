//
//  ViewController.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import UIKit
protocol DisplayLogic: AnyObject {
  var detailViewModel: [Person.ViewModel] { get set }
  
  func displayTableView(viewModel: [Person.ViewModel])
  func getNext(next: String)
  func displayEmptyView()
  func displayAlert(error: FetchError)
}

final class HomeViewController: UIViewController {
  
  // MARK: Properties
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomTableViewCell.self,
                       forCellReuseIdentifier: CustomTableViewCell.identifier)
    return tableView
  }()
  
  lazy private var emptyView = UIView()
  private let alert: UIAlertController = UIAlertController()
  private lazy var refreshController: UIRefreshControl = UIRefreshControl()
  
  // MARK: initiliazers
  
  let viewModel: PersonDisplayLogic = PersonViewModel()
  var detailViewModel: [Person.ViewModel] = .init()
  var nextCounter: String? = nil
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    viewModel.fetch(next: nextCounter,
                    isPagination: false)
    viewModel.delegate(output: self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  // MARK: Setup Views
  
  private func prepareUI() {
    view.addSubview(tableView)
    setupTableView()
    setupEmptyView()
    setupRefreshControl()
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
  
  func setupRefreshControl() {
    /// if any component with same frame, refreshControl disappear z position
    refreshController.layer.zPosition = -1
    refreshController.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    tableView.refreshControl = refreshController
  }
  
  @objc
  private func didPullToRefresh() {
    viewModel.fetch(next: nextCounter,
                    isPagination: false)
  }
}

// MARK: DisplayLogic
extension HomeViewController: DisplayLogic {
  func displayTableView(viewModel: [Person.ViewModel]) {
    self.detailViewModel = viewModel.unique
    refreshController.endRefreshing()
    self.tableView.reloadData()
  }
  
  func displayEmptyView() {
    tableView.isHidden = true
    emptyView.isHidden = false
    refreshController.endRefreshing()
  }
  
  func displayAlert(error: FetchError) {
    let message = Person.Alert(error: error).rawValue
    let title = Person.Alert.message.rawValue
    let buttonTitle = Person.Alert.buttonTitle.rawValue
    let newAlert = alert.makeAlert(title: title, message: message)
    newAlert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { _ in
      self.viewModel.fetch(next: self.nextCounter,
                           isPagination: false)
    }))
    
    self.present(newAlert, animated: true, completion: nil)
  }
  
  func getNext(next: String) {
    self.nextCounter = next
  }
}

