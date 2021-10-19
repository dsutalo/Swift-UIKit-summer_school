//
//  ViewController.swift
//  Project28
//
//  Created by Domagoj Sutalo on 27.08.2021..
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        callNotificationCenterObservers()
        setNavigationButton()
        setDefaultPassword()
        title = "Nothing to see here"
    }
    //challenge 1
    func setNavigationButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(lockScreen))
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    @objc func lockScreen(){
        if secret.isHidden == false{
            saveSecretMessage()
        }
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    //challange 2 - setting password
    func setDefaultPassword(){
        KeychainWrapper.standard.set("test123", forKey: "password")
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else{
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addTextField { textField in
                textField.placeholder = "Enter password"
                textField.isSecureTextEntry = true
            }
            ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
                [weak self, weak ac] _ in
                guard let inputText = ac?.textFields?[0].text else {return}
                self?.checkPassword(inputPassword: inputText)
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(ac, animated: true)
        }
        
    }
    //challenge2
    func checkPassword(inputPassword: String){
        guard let password = KeychainWrapper.standard.string(forKey: "password") else {return}
        if password == inputPassword{
            unlockSecretMessage()
        } else{
            callAC(title: "Wrong password!", message: nil)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

            if notification.name == UIResponder.keyboardWillHideNotification {
                secret.contentInset = .zero
            } else {
                secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            }
            secret.scrollIndicatorInsets = secret.contentInset
            let selectedRange = secret.selectedRange
            secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
        navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    func callAC(title: String?, message: String?){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func callNotificationCenterObservers(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
}

