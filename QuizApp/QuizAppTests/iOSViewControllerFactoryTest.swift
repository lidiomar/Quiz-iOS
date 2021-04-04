//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 01/04/21.
//

import Foundation
import XCTest
@testable import QuizApp
@testable import QuizEngine

class iOSViewControllerFactoryTest: XCTestCase {
    
    let options = ["A1", "A2"]
    let singleAnswer = Question.singleAnswer("Q1")
    let multipleAnswer = Question.multipleAnswer("Q1")
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswer, multipleAnswer], question: singleAnswer)
        XCTAssertEqual(makeQuestionController(question: singleAnswer).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswer).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswer).options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerSingleSelection() {
        XCTAssertFalse(makeQuestionController(question: singleAnswer).allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswer, multipleAnswer], question: multipleAnswer)
        XCTAssertEqual(makeQuestionController(question: multipleAnswer).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswer).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswer).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerSingleSelection() {
        XCTAssertTrue(makeQuestionController(question: multipleAnswer).allowsMultipleSelection)
    }
    
    func test_resultsViewController_createsControllerWithSummary() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }
    
    // MARK: - Helpers
    
    func makeSUT(options: [Question<String>: [String]] = [:],
                 correctAnswers: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswer, multipleAnswer], options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        let controller = makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
        return controller
    }
    
    func makeResults() -> (controller: ResultsViewController, presenter: ResultPresenter) {
        let userAnswers = [singleAnswer: ["A1"], multipleAnswer: ["A1, A2"]]
        let correctAnswer = [singleAnswer: ["A1"], multipleAnswer: ["A1, A2"]]
        let result = Result(answers: userAnswers, score: 0)
        let questions = [singleAnswer, multipleAnswer]
        
        let presenter = ResultPresenter(result: result, questions: questions, correctAnswers: correctAnswer)
        let sut = makeSUT(correctAnswers: correctAnswer)
        
        let controller = sut.resultViewController(for: result) as! ResultsViewController
        
        return (controller, presenter)
    }
}
