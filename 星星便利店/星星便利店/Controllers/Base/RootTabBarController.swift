//
//  RootTabBarController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import SVProgressHUD
class RootTabBarController: UITabBarController,UITabBarControllerDelegate {
    private var fristLoadMainTabBarController: Bool = true
    
    
    private var adImageView: UIImageView?
    var adImage: UIImage? {
        didSet {
            weak var tmpSelf = self
            adImageView = UIImageView(frame: AppBounds)
            adImageView!.image = adImage!
            self.view.addSubview(adImageView!)
            
            UIImageView.animateWithDuration(2.0, animations: { () -> Void in
                tmpSelf!.adImageView!.transform = CGAffineTransformMakeScale(1.2, 1.2)
                tmpSelf!.adImageView!.alpha = 0
                }) { (finsch) -> Void in
                    tmpSelf!.adImageView!.removeFromSuperview()
                    tmpSelf!.adImageView = nil
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.translucent = false
        delegate = self
        tabBar.selectedImageTintColor = HRHNavigationBarRedBackgroundColor
        changeCarNum()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeCarNum", name: "CarNumChanged", object: nil)
        if UserAccountTool.userIsLogin() {
            updateAllData()
        }
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    func changeCarNum(){
        if UserAccountTool.userIsLogin() {
            if(Model.defaultModel.shopCart.count == 0) {
                self.tabBar.items![2].badgeValue = nil
            }
            else {
                self.tabBar.items![2].badgeValue = "\(Model.defaultModel.shopCart.count)"
            }
        }
        else {
            self.tabBar.items![2].badgeValue = nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if fristLoadMainTabBarController {
            fristLoadMainTabBarController = false
        }
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        let childArr = tabBarController.childViewControllers as NSArray
        let index = childArr.indexOfObject(viewController)
        
        if index == 2 {
            
            let vc = mainStoryBoard.instantiateViewControllerWithIdentifier("shoppingCart")
            presentViewController(BaseNavigationController(rootViewController: vc), animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    //进行数据的第一次总更新
    func updateAllData(){
        
        
        DataCenter.shareDataCenter.updateAllCoupons("", callBack: nil)
        CollectionModel.CollectionCenter.loadDataFromNet(1, count: 100, success: { (data) -> Void in
            DataCenter.shareDataCenter.user.collect = data.count
            }, callback: nil)
        DataCenter.shareDataCenter.updateIntegral()
        
    }
    
    func setSelectIndex(intoRow:Int){


        let vc1 = self.childViewControllers[1] as! BaseNavigationController
        let vc = vc1.viewControllers[0] as! SortViewController
        selectedIndex = 1
        let first = NSIndexPath.init(forItem: intoRow, inSection: 0)
        
        vc.tableViewLeft.selectRowAtIndexPath(first, animated: false, scrollPosition: UITableViewScrollPosition.None)
        vc.updateSmallCell(first)
        
    }
}
