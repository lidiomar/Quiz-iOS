//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 27/03/21.
//

import Foundation
import XCTest
import UIKit
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: "Q1", viewController: viewController)
        factory.stub(question: "Q2", viewController: secondViewController)
        
        
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        sut.routeTo(question: "Q2", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }
    
    func test_routeToSecondQuestion_presentsQuestionControllerWithRightCallback() {
        var callbackWasFired = false
        sut.routeTo(question: "Q1", answerCallback: { _ in callbackWasFired = true})
        factory.answerCallbacks["Q1"]!("anything")
        
        XCTAssertTrue(callbackWasFired)
    }
}

class NonAnimatedNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}

class ViewControllerFactoryStub: ViewControllerFactory {
    
    private var stubbedViewControllers = [String: UIViewController]()
    var answerCallbacks = [String: (String)->Void]()
    
    func stub(question: String, viewController: UIViewController) {
        stubbedViewControllers[question] = viewController
    }
    
    func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
        answerCallbacks[question] = answerCallback
        return stubbedViewControllers[question] ?? UIViewController()
    }
}
