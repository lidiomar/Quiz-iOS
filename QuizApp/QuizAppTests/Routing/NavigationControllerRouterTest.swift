//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 27/03/21.
//

import Foundation
import XCTest
import UIKit
@testable import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
    let singleAnswer = Question.singleAnswer("Q1")
    let multipleAnswer = Question.multipleAnswer("Q1")
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), viewController: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), viewController: secondViewController)
        
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }
    
    func test_routeToQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        var callbackWasFired = false
        sut.routeTo(question: singleAnswer, answerCallback: { _ in callbackWasFired = true})
        factory.answerCallbacks[singleAnswer]!(["anything"])
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToQuestion_multipleAnswer_answerCallback_doesNotProgressToNextQuestion() {
        var callbackWasFired = false
        sut.routeTo(question: multipleAnswer, answerCallback: { _ in callbackWasFired = true})
        factory.answerCallbacks[multipleAnswer]!(["anything"])
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_routeToQuestion_multipleAnswer_doesNotConfiguresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswer, viewController: viewController)
        
        sut.routeTo(question: singleAnswer, answerCallback: { _ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswer, viewController: viewController)
        
        sut.routeTo(question: multipleAnswer, answerCallback: { _ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_isDisableWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswer, viewController: viewController)
        
        sut.routeTo(question: multipleAnswer, answerCallback: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleAnswer]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleAnswer]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_progressToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswer, viewController: viewController)
        
        var callbackWasFired = false
        sut.routeTo(question: multipleAnswer, answerCallback: { _ in callbackWasFired = true})
        
        factory.answerCallbacks[multipleAnswer]!(["A1"])
        let button = viewController.navigationItem.rightBarButtonItem!
        
        button.simulateTap()
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsResultController() {
        let viewController = UIViewController()
        let result = Result(answers: [singleAnswer: ["A1"]], score: 10)
        
        let secondViewController = UIViewController()
        let secondResult = Result(answers: [singleAnswer: ["A1"]], score: 20)
        
        
        factory.stub(result: result, viewController: viewController)
        factory.stub(result: secondResult, viewController: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
}

class NonAnimatedNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}

class ViewControllerFactoryStub: ViewControllerFactory {
    private var stubbedViewControllers = [Question<String>: UIViewController]()
    private var stubbedResults = [Result<Question<String>, [String]>: UIViewController]()
    var answerCallbacks = [Question<String>: ([String])->Void]()
    
    func stub(question: Question<String>, viewController: UIViewController) {
        stubbedViewControllers[question] = viewController
    }
    
    func stub(result: Result<Question<String>, [String]>, viewController: UIViewController) {
        stubbedResults[result] = viewController
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        answerCallbacks[question] = answerCallback
        return stubbedViewControllers[question] ?? UIViewController()
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return stubbedResults[result] ?? UIViewController()
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        self.target!.performSelector(onMainThread: self.action!, with: nil, waitUntilDone: true)
    }
}
