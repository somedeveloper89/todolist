//
//  Item.swift
//  Todoey
//
//  Created by Mustafa Kabaktepe on 06/08/2019.
//  Copyright © 2019 Mustafa Kabaktepe. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
