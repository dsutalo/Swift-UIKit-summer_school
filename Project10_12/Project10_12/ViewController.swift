//
//  ViewController.swift
//  Project10_12
//
//  Created by Domagoj Sutalo on 10.08.2021..
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftBarButton()
        setDefaults()
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Person",for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        let picture = pictures[indexPath.row]
        cell.pictureName.text = picture.name
        let path = Directory.getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.pictureImage.image = UIImage(contentsOfFile: path.path)
        cell.pictureImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.pictureImage.layer.borderWidth = 2
        cell.pictureImage.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        161
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    //added delete swipe
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("Deleted")
            
            self.pictures.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.save()
            self.tableView.endUpdates()
        }
    }
    
    @objc func addNewPicture(){
        let picker = UIImagePickerController()
        //print(UIImagePickerController.isSourceTypeAvailable(.camera))
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else{ picker.sourceType = .photoLibrary }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}
        let imageName = UUID().uuidString
        let imagePath = Directory.getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
        
        callAC(imageName: imageName)
    }
    
    func callAC(imageName: String){
        let ac = UIAlertController(title: "Add picture name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            let picture = Picture(name: newName, image: imageName)
            self?.pictures.append(picture)
            self?.save()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else{
            print("Failed to save pictures")
        }
    }
    
    func setLeftBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
    }
    
    func setDefaults(){
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do{
                pictures = try jsonDecoder.decode([Picture].self,from: savedPictures)
            } catch{
                print("Failed to load pictures")
            }
        }
    }
}

