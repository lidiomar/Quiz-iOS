//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Lidiomar Fernando dos Santos Machado on 01/04/21.
//

import Foundation
import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String])-> Void) -> UIViewController
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
