//
//  ViewController.swift
//  Project1
//
//  Created by Domagoj Sutalo on 25.07.2021..
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        importPictures()
        pictures.sort()
        setupBarButton()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            vc.currentPicture  = indexPath.row + 1
            vc.numberOfPictures = pictures.count
            navigationController?.pushViewController(vc,animated: true)
        }
    }
    
    @objc func recomendApp(){
        let vc = UIActivityViewController(activityItems: ["This app is awesome!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func setupTitle(){
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func importPictures(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
    }
    
    func setupBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recomendApp))
    }
    
}

