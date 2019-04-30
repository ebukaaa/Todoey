//
//  Data.swift
//  Todoey
//
//  Created by ebuks on 23/04/2019.
//  Copyright © 2019 ebukaa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    
//    each item has a parent category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
