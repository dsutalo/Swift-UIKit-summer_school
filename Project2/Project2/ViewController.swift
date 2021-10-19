//
//  ViewController.swift
//  Project2
//
//  Created by Domagoj Sutalo on 27.07.2021..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button2: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var currentAnimation = 0
    
    //make custom bar button item
    let infoButton = UIButton(type: .infoLight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCountries()
        configureButtons()
        setupCustomButton()
        
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Flag to guess: \(countries[correctAnswer].uppercased())"
            +   ", Score: \(score)"
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        //Project15 changes - scale down button and add bounce when pressed
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { finished in
            sender.transform = .identity
        }

        
        if sender.tag == correctAnswer{
            title = "Correct"
            score += 1
            
        }else{
            title = "Wrong"
            score -= 1
        }
        questionsAsked += 1
        if questionsAsked < 5 {
            if title == "Wrong" {
                let ac = UIAlertController(title: title, message: "That is flag of: \(countries[sender.tag].uppercased())", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: title, message: "Final score is: \(score)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            present(ac, animated: true)
            
            //Disable buttons after 5th round
            button1.isEnabled = false
            button2.isEnabled = false
            button3.isEnabled = false
        }
    }
    
    @objc func showScore(){
        if questionsAsked < 5 {
            let ac = UIAlertController(title: "Score counter", message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Score counter", message: "Your Final score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    func configureButtons(){
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupCountries(){
        countries += ["estonia","france","germany","ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    func setupCustomButton(){
        infoButton.addTarget(self, action: #selector(showScore), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }

}

