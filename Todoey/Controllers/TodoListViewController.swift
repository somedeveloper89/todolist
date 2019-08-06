//
//  ViewController.swift
//  Todoey
//
//  Created by Mustafa Kabaktepe on 05/08/2019.
//  Copyright © 2019 Mustafa Kabaktepe. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadData()
    }
    
    private func addItem(name: String, done: Bool) {
        let newItem = Item(context: context)
        newItem.title = name
        newItem.done = done
        itemArray.append(newItem)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            if textField.text != "" {
                let item = Item(context: self.context)
                item.title = textField.text!
                item.done = false
                self.itemArray.append(item)
                self.saveData()
            }
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveData() {
        
        do {
            try context.save()
        }
        catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    private func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()){
            do {
                itemArray = try context.fetch(request)
            } catch {
                print("Error decoding item array, \(error)")
            }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
    
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.predicate = predicate
            let sortDescr = NSSortDescriptor(key: "title", ascending: true)
             request.sortDescriptors = [sortDescr]
        
        
        loadData(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
    }
}

