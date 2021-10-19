//
//  ViewController.swift
//  Project7
//
//  Created by Domagoj Sutalo on 04.08.2021..
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setURL()
        setupRightBarButton()
        setupLeftBarButton()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        cell.textLabel?.font = UIFont(name: "San Francisco",size: 20)
        cell.detailTextLabel?.font = UIFont(name: "San Francisco",size: 18)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func showCredits(){
        let ac = UIAlertController(title: "Credits", message: "All credits go to We the people API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions(){
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchAction = UIAlertAction(title: "Search", style: .default){
            [weak self, weak ac] _ in
            guard let userInput = ac?.textFields![0].text else{return}
            self?.submit(userInput)
            
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(searchAction)
        present(ac, animated: true)
        
    }
    func submit(_ userInput: String){
        //Project 9 changes
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.filteredPetitions.removeAll(keepingCapacity: true)
            let input = userInput.lowercased()
            
            if input == ""{
                self?.filteredPetitions = self!.petitions
                self?.title = "Petitions"
            }else {
                for petition in self!.petitions{
                    if petition.title.lowercased().contains(input) || petition.body.lowercased().contains(input){
                        self?.filteredPetitions.append(petition)
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.title = "Filtered by: \(input)"
                }
            }
        }
        //project 9 changes
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setupTitle(){
        title = "Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setURL(){
        let urlString: String
        
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func setupRightBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    }
    
    func setupLeftBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
    }
}



