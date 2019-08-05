//
//  ViewController.swift
//  Todoey
//
//  Created by Mustafa Kabaktepe on 05/08/2019.
//  Copyright © 2019 Mustafa Kabaktepe. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItem(name: "Find Mike", done: false)
        addItem(name: "Buy Eggos", done: false)
        addItem(name: "Destroy Demogorgon", done: false)
        addItem(name: "1", done: false)
        addItem(name: "2", done: false)
        addItem(name: "3", done: false)
        addItem(name: "4", done: false)
        addItem(name: "5", done: false)
        addItem(name: "6", done: false)
        addItem(name: "7", done: false)
        addItem(name: "8", done: false)
        addItem(name: "9", done: false)
        addItem(name: "Find Mike", done: false)
        addItem(name: "Buy Eggos", done: false)
        addItem(name: "Destroy Demogorgon", done: false)
        addItem(name: "1", done: false)
        addItem(name: "2", done: false)
        addItem(name: "3", done: false)
        addItem(name: "4", done: false)
        addItem(name: "5", done: false)
        addItem(name: "6", done: false)
        addItem(name: "7", done: false)
        addItem(name: "8", done: false)
        addItem(name: "9", done: false)

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    private func addItem(name: String, done: Bool) {
        let newItem = Item()
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

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            if textField.text != "" {
                let item = Item()
                item.title = textField.text!
                self.itemArray.append(item)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
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
}

