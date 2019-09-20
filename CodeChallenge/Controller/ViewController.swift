//
//  ViewController.swift
//  CodeChallenge
//
//  Created by Fernando H M Bastos on 18/09/19.
//  Copyright © 2019 Fernando H M Bastos. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var sessionQuiz = Quiz()
    var userAnswers = UserAnswers()
    var seconds = 300
    var timer = Timer()
    var isTimeRunning = false
    var points = 0

    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var answersTable: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotifications()
        let t = UITapGestureRecognizer(target: self, action: #selector(clearKeyboard))
        view.addGestureRecognizer(t)
        t.cancelsTouchesInView = false

        answersTable.register(UITableViewCell.self,
                              forCellReuseIdentifier: "answerCell")
        answersTable.isHidden = true
        timerButton.setTitle("Start", for: .normal)

        self.sessionQuiz.getQuizFromAPI(completionHandler: {(success) -> Void in
            print(success)

            if success {
                self.questionLabel.text = self.sessionQuiz.question

            } else {
                DispatchQueue.main.async {
                    self.questionLabel.text = self.sessionQuiz.question
                    self.timerButton.isEnabled = false
                }
            }
        })

        self.answerField.isEnabled = false
    }


    @IBAction func timerButtonPressed(_ sender: UIButton) {
        if(isTimeRunning){
            timer.invalidate()
            clear()
        }
        else{
            self.answerField.isEnabled = true
            runTimer()
        }
        answersTable.reloadData()

    }

    @IBAction func answerField(_ sender: Any) {

        if(sessionQuiz.answer.contains(self.answerField.text!) && !userAnswers.answers.contains(self.answerField.text!)){
            points+=1
            pointLabel.text = String(format:"%02i/%02i", points, sessionQuiz.answer.count)
            self.userAnswers.answers.append(self.answerField.text!)
            answersTable.reloadData()
            self.answerField.text = ""
        }

        if(userAnswers.answers.count != 0){
            answersTable.isHidden = false
        }

        if(sessionQuiz.answer.count == userAnswers.answers.count){
            showGameOverAlert(timeout: false)
        }
    }

    func clear(){
        answersTable.isHidden = true
        self.answerField.isEnabled = false
        self.answerField.text = ""
        seconds = 300
        timerLabel.text = timeString(time: TimeInterval(seconds))
        timerButton.setTitle("Start", for: .normal)
        isTimeRunning = false
        points = 0
        userAnswers.answers = []
        pointLabel.text = String(format:"%02i/%02i", points, sessionQuiz.answer.count)
        self.answersTable.reloadData()
    }

    func runTimer(){
        isTimeRunning = true
        timerButton.setTitle("Restart", for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if(seconds > 0){
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
        else{
            showGameOverAlert(timeout: true)
        }
    }

    func showGameOverAlert(timeout: Bool){

        timer.invalidate()

        var messageTitle = ""
        var messageBody = ""
        var buttonTitle = ""

        if(!timeout){
            messageTitle = "Congratulations!"
            messageBody = "Good job! You found all the answers on time. Keep up with the great work."
            buttonTitle = "Play Again"
        }
        else if(timeout){
            messageTitle = "Time Finished"
            messageBody = String(format:"Sorry time is up! You got %02i out of %02i answers", points, sessionQuiz.answer.count)
            buttonTitle = "Try Again"
        }

        let gameOverAlert = UIAlertController(title: messageTitle, message: messageBody, preferredStyle: .alert)
        let gameOverAction = UIAlertAction(title: buttonTitle, style: .default) { [unowned self] action in
            self.clear()
        }
        
        gameOverAlert.addAction(gameOverAction)
        present(gameOverAlert, animated: true)
    }

    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }

    @IBOutlet var bottomConstraintForKeyboard: NSLayoutConstraint!

    @objc func keyboardWillShow(sender: NSNotification) {
        let i = sender.userInfo!
        let k = (i[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraintForKeyboard.constant = k - bottomLayoutGuide.length
        let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        bottomConstraintForKeyboard.constant = 16
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }

    @objc func clearKeyboard() {
        view.endEditing(true)
    }

    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

//
// MARK: - Table View Data Source
//
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAnswers.answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        answerCell.textLabel?.text = userAnswers.answers[indexPath.row]
        return answerCell
    }
}
