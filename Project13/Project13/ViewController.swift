//
//  ViewController.swift
//  Project13
//
//  Created by Domagoj Sutalo on 11.08.2021..
//
import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var changeFilter: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intesity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var changeFilterButtonn: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext! // core image component that handles rendering
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftBarButton()
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        changeFilterButtonn.setTitle("CISpepiaTone", for: .normal)
    }
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
        if let popoverController = ac.popoverPresentationController{
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { intesity.isEnabled = true } else { intesity.isEnabled = false }
        if inputKeys.contains(kCIInputRadiusKey) { radius.isEnabled = true } else { radius.isEnabled = false }
    }
    
    func setFilter(action: UIAlertAction){
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else {return}
        
        currentFilter = CIFilter(name: actionTitle)
        //challenge 2
        changeFilterButtonn.setTitle(actionTitle, for: .normal)
        
        let beginImage = CIImage(image:currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            //challenge 1
            let ac = UIAlertController(title: "You didn't load image!", message: "Load image and try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    //challenge 3
    @IBAction func radiusChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}
        
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(intesity.value, forKey: kCIInputIntensityKey)
        }

        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }

        if inputKeys.contains(kCIInputCenterKey){
            currentFilter.setValue(CIVector(x: currentImage.size.width, y: currentImage.size.height), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
            
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else{
            let ac = UIAlertController(title: "Saved!", message: "Your alerted image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    func setupLeftBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
}

