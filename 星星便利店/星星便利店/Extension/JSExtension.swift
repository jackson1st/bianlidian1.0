//
//  ViewController+JS.swift
//  Demo
//
//  Created by 黄人煌 on 16/1/29.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import Foundation
import SVProgressHUD
let CloseVC:Selector = "closeVC"

extension UIViewController{
    
    
    
    func isActived() -> Bool{
        return (self.isViewLoaded() && self.view.window != nil)
    }
    
    func closeVC(){

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pushViewController(VC:UIViewController, animated: Bool, completion: (()->Void)?){
        let VC2 = UINavigationController(rootViewController: VC)
        self.presentViewController(VC2, animated: animated, completion: completion)
    }
    
    func registerNetObserve(y: CGFloat){
        self.view.addNetWorkErrorView(y)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "netWorkOk", name: "netWorkOk", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "netWorkbad", name: "netWorkbad", object: nil)
    }
    
    func netWorkOk(){
        
        if(self.isActived() == false){
            
            return
            
        }
        print("被调用了 网络正常")
        
        let view = self.view.viewWithTag(120)
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            view?.hidden = true
            
            self.viewDidLoad()
            
        }
        
        
    }
    
    func netWorkbad(){
        
        
        if(self.isActived() == false){
            
            return
            
        }
        print(self.isViewLoaded())
        print(self.view.window)
        print("被调用了 网络不正常")
        
        let view = self.view.viewWithTag(120)
              SVProgressHUD.dismiss()
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.view.bringSubviewToFront(view!)
            view?.hidden = false
            if(HTTPManager.HUDCount > 0){
                
                HTTPManager.HUDCount = 0
            }
        }
        
        
    }
    
}
extension UIView{
        
        /**
         在view的底部加一条线
         
         - parameter height:      线的厚度
         - parameter offsetLeft:  到左端的距离，大于等于0有效
         - parameter offsetRight: 到右端的距离，小于等于0有效
         */
        func addBottomLine(height: CGFloat,offsetLeft:CGFloat,offsetRight:CGFloat){
            let view = UIView()
            view.backgroundColor = UIColor.lightGrayColor()
            self.addSubview(view)
            view.snp_makeConstraints { (make) -> Void in
                make.height.equalTo(height)
                make.left.equalTo(self).offset(offsetLeft)
                make.right.equalTo(self).offset(offsetRight)
                make.bottom.equalTo(self)
            }
        }
        
        
        /**
         在view的顶部加一条线
         
         - parameter height:      线的厚度
         - parameter offsetLeft:  到左端的距离，大于等于0有效
         - parameter offsetRight: 到右端的距离，小于等于0有效
         */
        func addTopLine(height: CGFloat,offsetLeft:CGFloat,offsetRight:CGFloat){
            let view = UIView()
            view.backgroundColor = UIColor.lightGrayColor()
            self.addSubview(view)
            view.snp_makeConstraints { (make) -> Void in
                make.height.equalTo(height)
                make.left.equalTo(self).offset(offsetLeft)
                make.right.equalTo(self).offset(offsetRight)
                make.top.equalTo(self)
            }
        }
        
        
        func addNetWorkErrorView(y: CGFloat){
            let view = UIView(frame: self.frame)
            view.frame.origin.y = y
            view.backgroundColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
            let imgView = UIImageView(image: UIImage(named: "icon_loadfail"))
            view.addSubview(imgView)
            imgView.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(view)
                make.centerY.equalTo(view).offset(-70)
                make.width.equalTo(80)
                make.height.equalTo(80)
            }
            let label = UILabel()
            label.textColor = UIColor.lightGrayColor()
            label.text = "加载失败，请检查您的网络设置"
            let click = UIButton()
            click.layer.borderColor = UIColor.lightGrayColor().CGColor
            click.layer.borderWidth = 1
            click.layer.cornerRadius = 5
            click.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            click.setTitle("点击重试", forState: UIControlState.Normal)
            click.addTarget(self, action: "reLoad", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(label)
            view.addSubview(click)
            label.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(view)
                make.top.equalTo(imgView.snp_bottom).offset(20)
            }
            click.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(label.snp_bottom).offset(20)
                make.centerX.equalTo(label.snp_centerX)
                make.width.equalTo(120)
                make.height.equalTo(40)
            }
            view.tag = 120
            view.hidden = true
            self.addSubview(view)
        }
    func reLoad(){
        NSNotificationCenter.defaultCenter().postNotificationName("netWorkOk", object: nil)
    }
}
protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(Self) }
    static var nib: UINib? { return nil }
}


extension UITableView{
    
    func registerReusableCell<T: UITableViewCell where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }

    
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
    func clearBottomLine(){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        self.tableFooterView = view
    }
}
