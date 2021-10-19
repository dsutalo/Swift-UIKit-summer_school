//
//  DetailViewController.swift
//  Project19_21
//
//  Created by Domagoj Sutalo on 19.08.2021..
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var notesBody: UITextView!
    @IBOutlet var notesTitle: UITextField!
    
    var note: Note!
    weak var delegate: ViewController!
    var delete: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupNote()
        setupToolbar()
        setupKeyboard()
        setupBarButton()
        view.backgroundColor = UIColor(patternImage: delegate.backgroundImage!)
    }
    override func viewDidAppear(_ animated: Bool) {
        setupToolbar()
    }
    
    
    func setupToolbar(){
        
        delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        delete.isEnabled = false
        if notesBody.text != "" || notesTitle.text != ""{
            delete.isEnabled = true
        }
    
        toolbarItems = [save,spacer, delete]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func saveNote(){
        note.title = notesTitle.text ?? ""
        note.body = notesBody.text ?? ""
        
        if notesBody.text != "" && notesTitle.text != ""{
            navigationItem.rightBarButtonItem?.isEnabled = true
            let newNote = Note(id: note.id,title: note.title, body: note.body)
            delegate.createNewNote(newNote: newNote)
            navigationItem.rightBarButtonItem?.isEnabled = true
            delete.isEnabled = true
        } else{
            callAC()
        }
    }
    
    func callAC(){
        let ac = UIAlertController(title: "Error", message: "Type in title and note!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func deleteNote(){
        delegate.deleteCell(id: note.id)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupTitle(){
        title = "note"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupNote(){
        notesTitle.placeholder = "Enter note title"
        notesBody.text = note.body
        notesTitle.text = note.title
    }
    
    func setupKeyboard(){
        let notificationnCenter = NotificationCenter.default
        notificationnCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationnCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        //this is triggered right before dismissal of keyboard
        if notification.name == UIResponder.keyboardWillHideNotification {
            notesBody.contentInset = .zero
        } else{
            notesBody.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        notesBody.scrollIndicatorInsets = notesBody.contentInset
        let selectedRange = notesBody.selectedRange
        notesBody.scrollRangeToVisible(selectedRange)

    }
    
    func setupBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.navigationBar.setBackgroundImage(delegate.backgroundImage, for: .default)
    }
    
    @objc func shareTapped(){
        let vc = UIActivityViewController(activityItems: [note.title,note.body], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
