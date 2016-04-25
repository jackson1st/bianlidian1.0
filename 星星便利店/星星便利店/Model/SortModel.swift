//
//  SortModel.swift
//  Demo
//
//  Created by Jason on 15/12/18.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class smallClass: NSObject {

    var name: String?
    var url: String?
    var itemclass: String?

    convenience init(dict: [String:AnyObject]) {
        self.init()
        self.name = dict["className"] as? String
        self.url = dict["url"] as? String
        self.itemclass = dict["itemClass"] as? String
    }
}
