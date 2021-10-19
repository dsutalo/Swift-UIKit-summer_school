//
//  DetailViewController.swift
//  Project1
//
//  Created by Domagoj Sutalo on 26.07.2021..
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var numberOfPictures = 0
    var currentPicture = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        loadImage()
        setupBarButton()
        
        assert(selectedImage != nil, "No image detected")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)else{
            print("No image found")
            return
        }
        //added image name for sharing
        let vc = UIActivityViewController(activityItems: [image,selectedImage ?? "Unknown"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func setupTitle(){
        title = "Picture \(currentPicture) of \(numberOfPictures)"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func loadImage(){
        if let imageToLoad = selectedImage{
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    func setupBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
}
