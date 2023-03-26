//
//  CaseStudyTests.swift
//  CaseStudyTests
//
//  Created by Tolga Sayan on 20.03.2023.
//

import XCTest
@testable import CaseStudy

class CaseStudyTests: XCTestCase {
  
    // MARK: Subject under test
  
  var sut: HomeViewController!
  var window: UIWindow!

  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupHomeViewController()
    loadView()
  }

  override func tearDown() {
    window = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: Test Setup
  
  func setupHomeViewController() {
    sut = HomeViewController()
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  private final class PersonDisplayLogicSpy: PersonDisplayLogic {
    var fetchCalled = false
    var delegateCalled = false
    
    func fetch(next: String?, isPagination: Bool) {
      fetchCalled = true
    }
    
    func delegate(output: DisplayLogic) {
      delegateCalled = true
    }
  }
  
  // MARK: Tests
  
  func testViewDidLoad_whenViewDidLoaded_shouldFetchCalled() {
    // Given
    let spy = PersonDisplayLogicSpy()
    sut.viewModel = spy
    
    // When
    sut.viewDidLoad()
    
    // Then
    XCTAssertTrue(spy.fetchCalled)
    XCTAssertTrue(spy.delegateCalled)
  }
  
  func testViewDidLoad_whenViewDidLoaded_shouldSetupViews() {
    // Given
    let tableView = sut.view.viewWithTag(Person.ViewKind.tableView.rawValue) as! UITableView
    let emptyView = sut.view.viewWithTag(Person.ViewKind.emptyView.rawValue) as! UIView
    let refreshControl = sut.view.viewWithTag(Person.ViewKind.refreshControl.rawValue) as! UIRefreshControl
    
    // When
    sut.viewDidLoad()
    
    // Then
    XCTAssertNotNil(tableView.delegate)
    XCTAssertNotNil(tableView.dataSource)
    XCTAssertNotEqual(tableView.rowHeight, 56)
    XCTAssertEqual(emptyView.backgroundColor, UIColor.systemBackground)
    XCTAssertTrue(emptyView.isHidden)
    XCTAssertEqual(refreshControl.layer.zPosition, -1)
    
  }
}
