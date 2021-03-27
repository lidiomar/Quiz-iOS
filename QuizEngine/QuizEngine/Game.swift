//
//  Game.swift
//  QuizEngine
//
//  Created by Lidiomar Fernando dos Santos Machado on 26/03/21.
//

import Foundation

public class Game<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Flow<Question, Answer, R>
    
    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, router: router, scoring: { scoring(answers: $0, correctAnswers: correctAnswers) })
    flow.start()
    return Game(flow: flow)
}


private func scoring<Question, Answer: Equatable>(answers: [Question: Answer], correctAnswers: [Question:  Answer]) -> Int {
    answers.reduce(0) { (score, tuple) in
        score + (tuple.value == correctAnswers[tuple.key] ? 1 : 0)
    }
}
