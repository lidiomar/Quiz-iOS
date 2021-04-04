//
//  QuestionPresenterTest.swift
//  QuizAppTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 03/04/21.
//

import Foundation
import XCTest
@testable import QuizApp
import QuizEngine

class QuestionPresenterTest: XCTestCase {
    
    let question1 = Question.singleAnswer("Q1")
    let question2 = Question.multipleAnswer("Q2")
    
    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)
        
        XCTAssertEqual(sut.title, "Question #1")
    }
    
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        
        XCTAssertEqual(sut.title, "Question #2")
    }
    
    func test_title_forUnexistantQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: Question.singleAnswer("Q1"))
        
        XCTAssertEqual(sut.title, "")
    }
    
}
