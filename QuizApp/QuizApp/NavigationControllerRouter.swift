//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Lidiomar Fernando dos Santos Machado on 27/03/21.
//

import Foundation
import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: String, answerCallback: @escaping (String)-> Void) -> UIViewController
}

class NavigationControllerRouter: Router {
    var navigationController: UINavigationController
    var factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        let viewController = factory.questionViewController(for: question, answerCallback: answerCallback)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func routeTo(result: Result<String, String>) {}
}
