//
//  makeUserNameController.swift
//  Demo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class makeUserNameController: UIViewController {
    
    @IBOutlet var makeUserName: UITextField!
    
    @IBOutlet var makeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "修改用户名"
        makeButton.layer.cornerRadius = 4
    }
}

extension makeUserNameController {
    
    @IBAction func makeAction(sender: AnyObject) {
        
        
        
    }
    
}