//
//  SelectedAdressViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class SelectedAdressViewController: AnimationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!UserAccountTool.judgeIsAppAddress()){
            self.performSegueWithIdentifier("showLocation", sender: nil)
        }
        buildNavigationItem()
    }
    lazy var searchVC:SearcherViewController = {
        let vc = mainStoryBoard.instantiateViewControllerWithIdentifier("searchView") as! SearcherViewController
        vc.delegate = self
        return vc
    }()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserAccountTool.judgeIsAppAddress() {
            let address = UserAccountTool.getAppAddressInfo()
            dPrint(address!)
            let titleView = AdressTitleView(frame: CGRectMake(0, 0, 0, 30))
            titleView.setTitle(address![2])
            titleView.frame = CGRectMake(0, 0, titleView.adressWidth, 30)
            navigationItem.titleView = titleView
            
            let tap = UITapGestureRecognizer(target: self, action: "titleViewClick")
            navigationItem.titleView?.addGestureRecognizer(tap)
        }
        else {
            self.performSegueWithIdentifier("showLocation", sender: nil)
        }
    }
    
    // MARK: - Build UI
    private func buildNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("搜 索", titleColor: UIColor.whiteColor(),
            image: UIImage(named: "icon_search")!,hightLightImage: nil,
            target: self, action: "rightItemClick", type: ItemButtonType.Right)
        
        let titleView = AdressTitleView(frame: CGRectMake(0, 0, 0, 30))
        titleView.frame = CGRectMake(0, 0, titleView.adressWidth, 30)
        navigationItem.titleView = titleView
        let tap = UITapGestureRecognizer(target: self, action: "titleViewClick")
        navigationItem.titleView?.addGestureRecognizer(tap)
    }
    
    // MARK:- Action
    // MARK: 搜索Action
    
    func rightItemClick() {
//        let searchVC = SearchProductViewController()
//        navigationController!.pushViewController(searchVC, animated: false)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func titleViewClick() {
        weak var tmpSelf = self
        tmpSelf!.performSegueWithIdentifier("showLocation", sender: nil)

    }
}

// MARK: - SearcherViewControllerDelegate
extension SelectedAdressViewController: SearcherViewControllerDelegate{
    func pushResultViewController(resultV: SearcherResultViewController) {
        resultV.hidesBottomBarWhenPushed = true
        self.navigationController?.popViewControllerAnimated(false)
        self.navigationController?.pushViewController(resultV, animated: true)
    }
}
