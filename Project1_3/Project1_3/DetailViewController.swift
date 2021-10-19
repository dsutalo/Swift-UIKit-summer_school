//
//  DetailViewController.swift
//  Project1_3
//
//  Created by Domagoj Sutalo on 29.07.2021..
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var currentPicture  = 0
    var numberOfPictures = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        loadImage()
        setupNavigationBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func setupTitle(){
        let imageNameWithSuffix = selectedImage ?? "Unknown.png"
        let imageName = (imageNameWithSuffix as NSString).deletingPathExtension.capitalized
        title = "Flag of \(imageName)"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func loadImage(){
        if let imageToLoad = selectedImage{
            imageView.image = UIImage(named: imageToLoad)
        }
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupNavigationBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else{
            print("No image found")
            return
        }
        let imageName = selectedImage ?? "Unknown"
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
