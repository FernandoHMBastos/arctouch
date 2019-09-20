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
    
    func getRequest(completionHandler: @escaping CompletionHandler) {
        if let url = URL(string: "https://codechallenge.arctouch.com/quiz/1") {
            URLSession.shared.dataTask(with: url) { data, response, error in

                if (response != nil){
                    if let data = data {
                        do {
                            let res = try JSONDecoder().decode(Quiz.self, from: data)
                            DispatchQueue.main.async {
                                self.question = res.question
                                self.answer = res.answer

                                completionHandler(true)
                            }
                        } catch let error {
                            print(error)
                            completionHandler(false)
                        }
                    }
                }
                else {
                    self.question = "Loading Error"
                    self.answer = []
                    completionHandler(false)
                }

                }.resume()
        }
    }
}

