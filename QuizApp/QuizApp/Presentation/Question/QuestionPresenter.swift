//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Lidiomar Fernando dos Santos Machado on 03/04/21.
//

import Foundation
import QuizEngine

struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>
    
    var title: String {
        guard let index = questions.firstIndex(of: question) else { return "" }
        return "Question #\(index + 1)"
    }
}
