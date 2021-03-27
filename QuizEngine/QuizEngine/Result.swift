//
//  Result.swift
//  QuizEngine
//
//  Created by Lidiomar Fernando dos Santos Machado on 26/03/21.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}
