//
//  ViewController.swift
//  Project7_9
//
//  Created by Domagoj Sutalo on 05.08.2021..
//

import UIKit

class ViewController : UIViewController {
    
    var allWords = [String]()
    var currentWord: String!
    var currentAnswer: UITextField!
    var wordLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var usedLetters = [Character]()
    var guessesLabel: UILabel!
    var guesses = 7 {
        didSet {
            guessesLabel.text = "Guesses left:\(guesses)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
 
        guessesLabel = UILabel()
        guessesLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLabel.textAlignment = .center
        guessesLabel.text = "Guesses left: 7"
        view.addSubview(guessesLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "???????"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer .isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            guessesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 10),
            guessesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: guessesLabel.bottomAnchor, constant: 30),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor,constant: 50),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30)
        ])
        
        let width = 50
        let height = 60
        
        for row in 0..<5{
            for column in 0..<6{
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                letterButton.setTitle("0", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        let allLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for (index, char) in allLetters.enumerated() {
            letterButtons[index].setTitle(String(char), for: .normal)
        }
        //remaining buttons that don't have letter value
        for button in letterButtons {
            if button.titleLabel?.text == "0" {
                button.isHidden = true
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(loadLevel), with: nil)
        
    }
    
    @objc func loadLevel(){
       
        if let playersFileURL = Bundle.main.url(forResource: "players", withExtension: "txt"){
            if let playersContents = try? String(contentsOf: playersFileURL){
                allWords = playersContents.components(separatedBy: "\n")
            }
        }
        
        performSelector(onMainThread: #selector(startNewGame), with: nil, waitUntilDone: false)
        
    }
    
    @objc func startNewGame(){
        for button in letterButtons{
            button.isEnabled = true
        }
        usedLetters.removeAll(keepingCapacity: true)
        guesses = 7
        currentWord = allWords.randomElement()
        
        var i = 1
        var questionMarksAnswer = ""
        while i <= currentWord.count{
            questionMarksAnswer += "?"
            i += 1
        }
        
        currentAnswer.text = questionMarksAnswer
        print(currentWord ?? "unlucky")
    }
    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else{return}
        usedLetters.append(Character(buttonTitle))
        sender.isEnabled = false
        
        if currentWord.contains(buttonTitle){
            var newAnswerText = currentAnswer!.text
            for(index,char) in currentWord.enumerated(){
                if char == Character(buttonTitle){
                    newAnswerText = String(newAnswerText!.prefix(index) + String(char) +  newAnswerText!.dropFirst(index + 1))
                }
            }
            currentAnswer.text = newAnswerText
            
            if !currentAnswer!.text!.contains("?"){
                let ac = UIAlertController(title: "You guessed the word", message: "Do you want to guess next word?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sure", style: .default, handler: newLevel))
                ac.addAction(UIAlertAction(title: "Nah", style: .default, handler: stopGame))
                present(ac, animated: true)
            }
        }
        else{
            wrongLetter()
        }
    }
    func newLevel(action: UIAlertAction){
        startNewGame()
    }
    func stopGame(action: UIAlertAction){
        for button in letterButtons{
            button.isEnabled = false
        }
    }
    
    func wrongLetter(){
        guesses -= 1
        if guesses <= 0{
            let ac = UIAlertController(title: "You lost!", message: "Do you want to guess next word?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Sure", style: .default, handler: newLevel))
            ac.addAction(UIAlertAction(title: "Nah", style: .default,handler: stopGame))
            present(ac, animated: true)
        }
    }
}

