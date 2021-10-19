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
        //project 9 changes
        performSelector(inBackground: #selector(importPictures), with: nil)
        setupBarButton()
        pictures.sort()
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
        let recommend = "This app is awesome, download Project1 to see why!"
        
        let vc = UIActivityViewController(activityItems: [recommend], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func setupTitle(){
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    //project 9 changes
    @objc func importPictures(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items{
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        tableView.performSelector(onMainThread:#selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func setupBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recomendApp))
    }

}

