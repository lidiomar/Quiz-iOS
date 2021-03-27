//
//  Router.swift
//  QuizEngine
//
//  Created by Lidiomar Fernando dos Santos Machado on 26/03/21.
//

import Foundation

public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer: Equatable
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
