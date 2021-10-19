//
//  ViewController.swift
//  Project13_15
//
//  Created by Domagoj Sutalo on 13.08.2021..
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setURL()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CountryCell else {
            fatalError("Unable to dequeue cell as CountryCell")
        }
        let country = countries[indexPath.row]
        cell.countryName.text = country.name
        loadImage(cell: cell, indexPath: indexPath)
        cell.countryFlag.layer.borderWidth = 1
        cell.countryFlag.layer.borderColor = UIColor.cyan.cgColor
        cell.countryFlag.layer.cornerRadius = 10
        cell.layer.cornerRadius = 7
        return cell
    }
    
    func loadImage(cell: CountryCell, indexPath: IndexPath){
        let country = countries[indexPath.row]
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: "https://flagcdn.com/w80/\(country.alpha2Code.lowercased()).png"){
                if let data = try? Data(contentsOf: imageURL){
                    DispatchQueue.main.async {
                        cell.countryFlag.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailTableViewController{
            vc.currentCountry = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func setURL(){
        let stringURL = "https://restcountries.eu/rest/v2/all"
        
        if let url = URL(string: stringURL){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode([Country].self, from: json){
            countries = jsonCountries
            tableView.reloadData()
        }
    }
}

