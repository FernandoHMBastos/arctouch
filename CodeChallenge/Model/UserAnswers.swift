//
//  UserAnswers.swift
//  CodeChallenge
//
//  Created by Fernando H M Bastos on 19/09/19.
//  Copyright © 2019 Fernando H M Bastos. All rights reserved.
//

import Foundation

class UserAnswers {

    var answers: [String]

    init(){
        self.answers = []
    }

    func clearAnswers(){
        self.answers = []
    }
}
