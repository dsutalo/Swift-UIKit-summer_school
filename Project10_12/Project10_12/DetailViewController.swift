//
//  DetailViewController.swift
//  Project10_12
//
//  Created by Domagoj Sutalo on 10.08.2021..
//

import UIKit

class DetailViewController: UIViewController {
    var selectedImage: Picture?
    
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        loadImage()
        
    }
    func setupTitle(){
        title = "\(selectedImage?.name ?? "Picture")"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func loadImage(){
        if let imageToLoad = selectedImage?.image {
            let imagePath = Directory.getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: imagePath.path)
        } else{
            print("Failed to load image")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
}
