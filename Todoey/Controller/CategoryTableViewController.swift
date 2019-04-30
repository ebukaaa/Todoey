//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by ebuks on 24/04/2019.
//  Copyright © 2019 ebukaa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    //    MARK: Variables
    var realm = try! Realm()
    var categories: Results<Category>?
    let defaultColor = "37A8FF"
    
    //    MARK: Action outlets
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            guard let text = textField.text else {
                return
            }
            newCategory.name = text
            newCategory.colorHexValue = UIColor.randomFlat.hexValue()
            print()
            print(newCategory.colorHexValue)
            print()
            self.save(newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            
            textField.placeholder = "Add a new category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //    MARK: (Start) override
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        read from database
        loadCategories()
        
        tableView.rowHeight = 115
    }
    
//    Navigate to new screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let todoList = segue.destination as! TodoTableViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow,
            let category = categories?[indexPath.row] else {
                return
        }
        todoList.category = category
        todoList.defaultColor = defaultColor
    }
}

// MARK: Helper functions
extension CategoryTableViewController {
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(_ category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        guard let category = self.categories?[indexPath.row] else {
            return
        }
        do {
            try self.realm.write {
                self.realm.delete(category)
            }
        } catch {
            print("Error deleting category, \(error)")
        }
    }
}

// MARK: UITableViewController delegate functions
extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if categories isn't nil return its count else return 1 - Nil coalescing operator
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let category = categories?[indexPath.row],
            let cellColor = UIColor(hexString: category.colorHexValue)
        else {
            
            let cellColor = UIColor(hexString: defaultColor) ??  UIColor.randomFlat
                
            cell.textLabel?.text = "No category added yet"
            cell.backgroundColor = cellColor
            cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
            
            return cell
        }
        cell.textLabel?.text = category.name
        cell.backgroundColor = cellColor
        cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}

