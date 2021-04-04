//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/03/21.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_rendersHeaderTest() {
        XCTAssertEqual(makeSUT(question: "Q1", options: [], allowsMultipleSelection: false).headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_renderOptions() {
        XCTAssertEqual(makeSUT(options: [], allowsMultipleSelection: false).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"], allowsMultipleSelection: false).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_withOneOptions_renderOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"],allowsMultipleSelection: false).tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_withTwoOptions_notifiesDelegateWithLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) {
            receivedAnswer = $0
        }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionSelected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { _ in
            callbackCount += 1
        }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(row: 1)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) {
            receivedAnswer = $0
        }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1","A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) {
            receivedAnswer = $0
        }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    
    func test_viewDidLoad_withSingleSelection_configuresTableView() {
        XCTAssertFalse(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false).tableView.allowsMultipleSelection)
    }
    
    func test_viewDidLoad_withMultipleSelection_configuresTableView() {
        XCTAssertTrue(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true).tableView.allowsMultipleSelection)
    }
    
    // MARK: - Helpers
    
    func makeSUT(question: String = "",
                 options: [String],
                 allowsMultipleSelection: Bool = false,
                 selection: @escaping (([String])-> Void) = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: selection)
        _ = sut.view
        return sut
    }
}
