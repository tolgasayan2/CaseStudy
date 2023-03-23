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
  private let refreshController: UIRefreshControl = UIRefreshControl()
  
  // MARK: initiliazers
  
  let viewModel: PersonDisplayLogic = PersonViewModel()
  var detailViewModel: [Person.ViewModel] = .init()
  private var nextCounter: String? = nil
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    viewModel.fetch(next: nextCounter)
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
    viewModel.fetch(next: nextCounter)
  }
}

// MARK: DisplayLogic
extension HomeViewController: DisplayLogic {
  func displayTableView(viewModel: [Person.ViewModel]) {
    self.detailViewModel = viewModel
    refreshController.endRefreshing()
    self.tableView.reloadData()
  }
  
  func displayEmptyView() {
    tableView.isHidden = true
    emptyView.isHidden = false
    refreshController.endRefreshing()
  }
  
  func displayAlert(error: FetchError) {
    switch error {
    case .internalError:
      let alertMessage = "Lütfen internet bağlantınızı kontrol edip tekrar deneyin"
      let alertTitle = "Bilgilendirme"
      let alert = UIAlertController(title: alertTitle,
                                    message: alertMessage,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .cancel, handler: { _ in
        self.viewModel.fetch(next: self.nextCounter)
      }))
      self.present(alert, animated: true, completion: nil)
    case .parameterError:
      let alertMessage = "Beklenmeyen bir hata oluştu"
      let alertTitle = "Bilgilendirme"
      let alert = UIAlertController(title: alertTitle,
                                    message: alertMessage,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .cancel, handler: { _ in
        self.viewModel.fetch(next: self.nextCounter)
      }))
      
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func getNext(next: String) {
    self.nextCounter = next
  }
}

