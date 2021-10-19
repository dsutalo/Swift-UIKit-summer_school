//
//  ViewController.swift
//  Project1_3
//
//  Created by Domagoj Sutalo on 28.07.2021..
//

import UIKit

class ViewController: UITableViewController {
    var flags = [String]()
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        importPictures()
        setupTitle()
        flags.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row]
        cell.imageView?.image = UIImage(named: flags[indexPath.row] + ".png")
        cell.imageView?.layer.borderWidth = 1.75
        cell.imageView?.layer.borderColor = UIColor.cyan.cgColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = flags[indexPath.row]
            vc.currentPicture  = indexPath.row + 1
            vc.numberOfPictures = flags.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupTitle(){
        title = "Flag Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func importPictures(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items{
            if item.hasSuffix(".png"){
                flags.append(item)
            }
        }
    }
}
