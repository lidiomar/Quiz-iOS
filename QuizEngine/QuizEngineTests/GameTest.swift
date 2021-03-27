//
//  GameTest.swift
//  QuizEngineTests
//
//  Created by Lidiomar Fernando dos Santos Machado on 26/03/21.
//

import Foundation
import XCTest
import QuizEngine

class GameTest: XCTestCase {
    
    let router = RouterSpy()
    var game: Game<String, String, RouterSpy>!
    
    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1", "Q2"], router:  router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startGame_answerOneofTwoCorrectly_scoresOne() {
        router.answerCallback("A1")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResults!.score, 1)
    }
    
    func test_startGame_answerTwoOfTwoCorrectly_scoresTwo() {
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResults!.score, 2)
    }
    
    func test_startGame_answerZeroOfTwoCorrectly_scoresZero() {
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResults!.score, 0)
    }
}
