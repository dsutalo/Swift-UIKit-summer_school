//
//  ViewController.swift
//  Project25_27
//
//  Created by Domagoj Sutalo on 26.08.2021..
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var topButton: UIButton!
    @IBOutlet var importPictureButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var topLabel: UILabel!
    
    @IBOutlet var bottomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }

    @IBAction func importPictureTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        imageView.image = image
        
    }
    
    @IBAction func setTopTextTapped(_ sender: Any) {
        callAC(title: "Set Top text", position: "top")
    }
    @IBAction func setBottomTextTapped(_ sender: Any) {
        callAC(title: "Set Bottom text", position: "bottom")
    }
    
    func callAC(title: String?, position: String){
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Enter text"
        }
        ac.addAction(UIAlertAction(title: "Set", style: .default, handler: { [weak ac, weak self] _ in
            guard let inputText = ac?.textFields?[0].text else {return}
            self?.setText(inputText: inputText,position: position)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setText(inputText: String,position: String){
        
        
        let size = imageView.frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { ctx in
            
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17),
                .paragraphStyle: paragraphStyle
                
            ]
            guard let memeImage = imageView.image else{return}
            
            let attributedString = NSAttributedString(string: inputText, attributes: attrs)
            if position == "top"{
                attributedString.draw(with: CGRect(x: 174, y: 130, width: memeImage.size.width - 40, height: 30), options: .usesLineFragmentOrigin, context: nil)
            }else if position == "bottom"{
                attributedString.draw(with: CGRect(x: 174, y: 510, width: memeImage.size.width - 40, height: 30), options: .usesLineFragmentOrigin, context: nil)
            }
            let meme = imageView.image
            meme?.draw(at: CGPoint(x: 0, y: 32))
        
//        if position == "top"{
//            topLabel.attributedText = attributedString
//
//
//        } else if position == "bottom"{
//            bottomLabel.attributedText = attributedString
            
            
        }
        imageView.image = image
    }
    
    func setConstraints(){
        
        importPictureButton.backgroundColor = .cyan
        topButton.backgroundColor = .cyan
        bottomButton.backgroundColor = .cyan
        importPictureButton.layer.cornerRadius = 5
        topButton.layer.cornerRadius = 5
        bottomButton.layer.cornerRadius = 5
        importPictureButton.layer.borderWidth = 1
        topButton.layer.borderWidth = 1
        bottomButton.layer.borderWidth = 1
        importPictureButton.layer.borderColor = UIColor.black.cgColor
        topButton.layer.borderColor = UIColor.black.cgColor
        bottomButton.layer.borderColor = UIColor.black.cgColor
        
        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.heightAnchor.constraint(equalToConstant: 415).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 375).isActive = true
//        imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 30).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
//        bottomButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
//        topButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
//        importPictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9).isActive = true
        
        
    }
}

