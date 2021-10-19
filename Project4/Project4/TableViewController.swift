//
//  TableTableViewController.swift
//  Project4
//
//  Created by Domagoj Sutalo on 30.07.2021..
//

import UIKit

class TableViewController: UITableViewController {
    var websites = ["apple.com", "hackingwithswift.com"]
    let cellIdentifier = "Page"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List of safe websites"
        navigationController?.navigationBar.prefersLargeTitles = true
  
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Page", for: indexPath)
            cell.textLabel?.text = websites[indexPath.row]
            return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Webpage") as? WebViewController{
            vc.selectedPage = websites[indexPath.row]
            navigationController?.pushViewController(vc,animated: true)
            }
        }
}
