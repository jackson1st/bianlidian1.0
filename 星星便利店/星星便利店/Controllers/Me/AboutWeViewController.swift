//
//  AboutWeViewController.swift

//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.

//  关于我们

import UIKit

class AboutWeViewController: BaseViewController {

    init() {
        super.init(nibName: "AboutWeViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "AboutWeViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关于我们"
//        self.tabBarController!.tabBar.hidden = true
    }
}
