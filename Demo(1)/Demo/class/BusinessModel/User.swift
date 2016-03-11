//
//  User.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/8.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import Foundation

class User: NSObject {
    var collect: Int!
    var integral: Int!
    var coupon: Int!
    override init() {
        self.collect = 0
        self.integral = 0
        self.coupon = 0
    }
    
}