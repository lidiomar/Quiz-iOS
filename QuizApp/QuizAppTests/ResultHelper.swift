//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 02/04/21.
//

import Foundation
import QuizEngine

extension Result: Hashable {
    public var hashValue: Int { return 1 }
    
    public static func ==(lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
