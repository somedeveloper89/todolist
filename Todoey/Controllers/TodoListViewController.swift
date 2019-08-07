//
//  ViewController.swift
//  Todoey
//
//  Created by Mustafa Kabaktepe on 05/08/2019.
//  Copyright © 2019 Mustafa Kabaktepe. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var itemArray: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.hexColor else { fatalError()}
        updateNavBarCollor(hexString: colourHex)
        title = selectedCategory?.name
        searchBar.barTintColor = UIColor(hexString: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBarCollor(hexString: "FF9300")
    }
    
    private func updateNavBarCollor(hexString: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Nav contr not existing")}
        guard let navBarColor = UIColor.init(hexString: hexString) else {fatalError()}
        navBar.barTintColor = UIColor.init(hexString: hexString)
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :
            ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedCategory!.hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        }
        else {
            cell.textLabel?.text = "No items added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) {
            action in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.done = false
                        item.creationDate = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveData(item: Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        }
        catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    private func loadData(){
       itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func deleteListItem(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            
            do {
                try self.realm.write {
                    realm.delete(item)
                }
            }
            catch {
                print("Error occured while deleting item")
            }
            
        }
    }
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "creationDate", ascending: true)
        tableView.reloadData()
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

