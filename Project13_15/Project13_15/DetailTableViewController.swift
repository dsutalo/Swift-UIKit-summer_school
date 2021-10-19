//
//  DetailTableViewController.swift
//  Project13_15
//
//  Created by Domagoj Sutalo on 13.08.2021..
//

import UIKit

class DetailTableViewController: UITableViewController {
    var currentCountry: Country!
    var flagOrTextDetail = ["flag", "text"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return flagOrTextDetail.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if flagOrTextDetail[section] == "text"{
            return "General"
        }
        return "Flag of \(currentCountry.name)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagOrTextDetail[section] == "flag"{
            return 1
        } else if flagOrTextDetail[section] == "text"{
            return 4
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 185
        }
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch flagOrTextDetail[indexPath.section] {
        case "flag":
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            if let cell = cell as? FlagCell{
                loadFlag(cell: cell)
            }
            return cell

        case "text":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Country name:  \(currentCountry.name)"
            case 1:
                cell.textLabel?.text = "Capital city:  \(currentCountry.capital)"
            case 2:
                cell.textLabel?.text = "Region:  \(currentCountry.region)"
            case 3:
                cell.textLabel?.text = "Population:  \(currentCountry.population)"
            default:
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = "Unknown"
            }
            return cell
        default:
            break
        }
       return UITableViewCell()
    }
    
    func loadFlag(cell: FlagCell){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let imageURL = URL(string: "https://flagcdn.com/w1280/\(self?.currentCountry?.alpha2Code.lowercased() ?? "be").png"){
                if let data = try? Data(contentsOf: imageURL){
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.countryFlagBig.image = image
                    }
                }
            }
        }
    }
    
    func setupTitle(){
        title = currentCountry.name
        navigationItem.largeTitleDisplayMode = .never
    }
}
