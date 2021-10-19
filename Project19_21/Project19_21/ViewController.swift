//
//  ViewController.swift
//  Project19_21
//
//  Created by Domagoj Sutalo on 19.08.2021..
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    let backgroundImage = UIImage(named: "notes_background")

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setDefaults()
        setupToolbar()
        view.backgroundColor = UIColor(patternImage: backgroundImage!)
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.backgroundColor = UIColor(patternImage: backgroundImage!)
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Note") as? DetailViewController {
            vc.note = notes[indexPath.row]
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notes.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            save()
            self.tableView.endUpdates()
        }
    }
    
    
    func setTitle(){
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "newNotes")
        } else{
            print("Failed to save notes")
        }
    }
    
    func setDefaults(){
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "newNotes") as? Data{
            let jsonDecoder = JSONDecoder()
            
            do{
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch{
                print("Failed to load notes")
            }
        }
        tableView.reloadData()
    }
    
    func setupToolbar(){
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [spacer, compose]
        navigationController?.isToolbarHidden = false
        
        navigationController?.toolbar.tintColor = .orange
        navigationController?.toolbar.setBackgroundImage(backgroundImage!, forToolbarPosition: .any, barMetrics: .default)
        navigationController?.navigationBar.tintColor = .orange
    }
    
    @objc func addNote(){
        let newNote = Note(id: UUID().uuidString ,title: "", body: "")
        if let vc = storyboard?.instantiateViewController(identifier: "Note") as? DetailViewController {
            vc.note = newNote
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func createNewNote(newNote: Note){
        if let note = notes.enumerated().first(where: {$0.element.id == newNote.id}) {
            notes[note.offset].body = newNote.body
            notes[note.offset].title = newNote.title
        } else {
            notes.append(newNote)
        }
        save()
        tableView.reloadData()
    }
    
    func deleteCell(id: String){
        for (index,_) in notes.enumerated(){
            if notes[index].id == id{
                notes.remove(at: index)
            }
        }
        save()
        tableView.reloadData()
    }
}


