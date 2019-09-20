//
//  Quiz.swift
//  CodeChallenge
//
//  Created by Fernando H M Bastos on 19/09/19.
//  Copyright © 2019 Fernando H M Bastos. All rights reserved.
//

import Foundation

//
// MARK: - Quiz
//
class Quiz: Decodable {
    //
    // MARK: - Variables And Properties
    //
    var question: String
    var answer: [String]

    //
    // MARK: - Initialization
    //
    init() {
        self.question = "Loading"
        self.answer = []
    }

    //
    // MARK: - API Request
    //
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    func getQuizFromAPI(completionHandler: @escaping CompletionHandler) {
        if let url = URL(string: "https://codechallenge.arctouch.com/quiz/1") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in

                guard let dataResponse = data,
                    error == nil else { print(error?.localizedDescription ?? "Response Error")
                        self.question = "Loading Error - Please check your connection"
                        self.answer = []
                        completionHandler(false)
                        return

                }
                do {
                    let jsonResponse = try JSONDecoder().decode(Quiz.self, from: dataResponse)
                    DispatchQueue.main.async {
                        self.question = jsonResponse.question
                        self.answer = jsonResponse.answer

                        completionHandler(true)
                    }
                } catch let parsingError {
                    print(parsingError)
                    completionHandler(false)
                }
            }
            task.resume()

        }

    }
}



