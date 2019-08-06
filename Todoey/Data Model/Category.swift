//
//  Category.swift
//  Todoey
//
//  Created by Mustafa Kabaktepe on 06/08/2019.
//  Copyright © 2019 Mustafa Kabaktepe. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
