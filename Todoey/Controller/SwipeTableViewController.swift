//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by ebuks on 24/04/2019.
//  Copyright © 2019 ebukaa. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {
    
    //    MARK: (Start) override
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: Helper function
extension SwipeTableViewController {
    @objc func updateModel(at indexPath: IndexPath) {
//        update data model
    }
}

// MARK: SwipeTableViewCellDelegate functions
extension SwipeTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.updateModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
    }
}

// MARK: UITableViewController delegate functions
extension SwipeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
}
