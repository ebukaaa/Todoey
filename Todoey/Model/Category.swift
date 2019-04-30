//
//  Category.swift
//  Todoey
//
//  Created by ebuks on 23/04/2019.
//  Copyright © 2019 ebukaa. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var colorHexValue = ""
    
    let items = List<Item>()
}
