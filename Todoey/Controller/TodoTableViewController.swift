//
//  ViewController.swift
//  Todoey
//
//  Created by ebuks on 24/04/2019.
//  Copyright © 2019 ebukaa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoTableViewController: SwipeTableViewController {

    //    MARK: Variables
    var realm = try! Realm()
    var defaultColor: String?
    var todoItems: Results<Item>?
    var category: Category? {
        
        didSet {
            
            loadItems()
        }
    }
    
    //    MARK: Outlet variables
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //    MARK: Action outlets
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        //        Close alert view
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            guard let text = textField.text,
                let currentCategory = self.category else {
                return
            }
            do {
                try self.realm.write {
                    let newItem = Item()
                    
                    newItem.title = text
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
            self.tableView.reloadData()
        }
        
        //        Open alert view
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            print("Open alert view")
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil      )
    }
    
    //    MARK: Override (start)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 115
        tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        
//        set the bar color of the category to the item cell
        guard let colorHexValue = category?.colorHexValue,
            let categoryName = category?.name
        else {
                return
        }
        title = categoryName
        
        updateNavigationBar(withHexValue: colorHexValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let colorHexValue = defaultColor else {
            return
        }
        updateNavigationBar(withHexValue: colorHexValue)
    }
}

// MARK: Helper functions
extension TodoTableViewController {
    func loadItems() {
        
        todoItems = category?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    func saveItems() {
        
    }
    
    func updateNavigationBar(withHexValue colorHexValue: String) {
        
        guard
            let barColor = UIColor(hexString: colorHexValue),
            let navigationBar = navigationController?.navigationBar
            else {
                return
        }
        let contrastColor = ContrastColorOf(barColor, returnFlat: true)

        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
        navigationBar.tintColor = contrastColor
        navigationBar.barTintColor = barColor
        
        searchBar.barTintColor = barColor
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        guard let item = self.todoItems?[indexPath.row] else {
            return
        }
        do {
            try self.realm.write {
                self.realm.delete(item)
            }
        } catch {
            print("Error deleting category, \(error)")
        }
    }
}


// MARK: UItableView delegate functions
extension TodoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        table row cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        guard let item = todoItems?[indexPath.row],
            let totalItems = todoItems?.count,
            let colorHexValue = category?.colorHexValue,
            let categoryColor = UIColor(hexString: colorHexValue),
            let cellBackgroundColor = categoryColor.darken(byPercentage:
                
                CGFloat(indexPath.row) / CGFloat(totalItems)
            )
        else {
            
            let cellBackgroundColor = UIColor.randomFlat
            
            cell.textLabel?.text = "No items added"
            cell.backgroundColor = cellBackgroundColor
            cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
            
            return cell
        }
        cell.backgroundColor = cellBackgroundColor
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
        
        //        check accessory type depending on the item done property
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        check if item is checked
        guard let item = todoItems?[indexPath.row] else {
            return
        }
        do {
            try realm.write {
                item.done = !item.done
            }
        } catch {
            print("Error saving checkmark status, \(error)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

// MARK: UISearchBarDelegate functions
extension TodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchBarText = searchBar.text else {
            return
        }
        
//        query realm database
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBarText).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

//            runs in the foreground
            DispatchQueue.main.async {

//                removes keyboard after clicking the 'x'
                searchBar.resignFirstResponder()
            }
        }
    }
}
