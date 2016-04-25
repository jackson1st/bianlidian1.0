//
//  LocationViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class LocationViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var chooseLocation: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var firstTableView: UITableView?
    var secondTableView: UITableView?
    var thirdTableView: UITableView?
    var width = UIScreen.mainScreen().bounds.width
    var dict: NSDictionary?
    var firstArry: NSArray?,secondArry:NSArray?,thirdArry: NSArray?,selectArr:NSArray?
    var first: String?, second: String?, third: String?
    var cur: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNetObserve(64)
        textLable.text = "请选择您所在的地区"
        initArr()
        initView()
        initTitle()
        leftButton.setTitle("关闭", forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - 一些初始化操作
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func initArr(){
        //manager2.responseSerializer.acceptableContentTypes = NSSet(object: "appliaction/json") as Set<NSObject>
        let parameter = ["city":"Null","county":"Null"]
        
        HTTPManager.POST(ContentType.Location, params: parameter).responseJSON({ (json) -> Void in
            
            self.firstArry = json["citys"] as? NSArray
            self.firstTableView?.reloadData()
            
            }) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("出错了")
                dPrint("发生了错误: " + (error?.localizedDescription)!)
        }
    }
    
    func initTitle(){
        textLable.textColor = UIColor.whiteColor()
        if(UserAccountTool.judgeIsAppAddress()){
            let appAddress = UserAccountTool.getAppAddressInfo()
            first = appAddress![0]
            second = appAddress![1]
            third = appAddress![2]
            chooseLocation.text = first! + "-" + second! + "-" + third!
            textLable.text = "请选择您所在的市"
        }
    }
    //MARK: 初始化一些视图
    func initView(){
        let frame = CGRect(x: 0, y: -65, width: width, height: UIScreen.mainScreen().bounds.height)
        scrollView.frame = CGRect(x: 0, y: 25, width: width, height: UIScreen.mainScreen().bounds.height)
        scrollView.contentSize = CGSize(width: CGFloat(width*3), height: CGFloat(frame.height))
        scrollView.backgroundColor = UIColor.blackColor()
        firstTableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        firstTableView?.delegate = self
        firstTableView?.dataSource = self
        firstTableView?.tag = 101
        scrollView.addSubview(firstTableView!)
        
        secondTableView = UITableView(frame: CGRect(x: width, y: -65, width: width, height: UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        secondTableView?.delegate = self
        secondTableView?.dataSource = self
        secondTableView?.tag = 102
        scrollView.addSubview(secondTableView!)
        thirdTableView = UITableView(frame: CGRect(x: 2*width, y: -65, width: width+10, height: UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        thirdTableView?.delegate = self
        thirdTableView?.dataSource = self
        thirdTableView?.tag = 103
        scrollView.addSubview(thirdTableView!)
        
        let view1 = UIView()
        view1.backgroundColor = UIColor.clearColor()
        firstTableView?.tableFooterView = view1
        
        let view2 = UIView()
        view2.backgroundColor = UIColor.clearColor()
        secondTableView?.tableFooterView = view2
        
        let view3 = UIView()
        view3.backgroundColor = UIColor.clearColor()
        thirdTableView?.tableFooterView = view3
    }
    
    //MARK: - 实现代理
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = firstTableView!.dequeueReusableCellWithIdentifier("proCell")
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "proCell")
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        switch(tableView.tag){
        case 101:  cell?.textLabel?.text = firstArry![indexPath.row] as! String;
        case 102:  if(cur==2){ cell?.textLabel?.text = secondArry![indexPath.row] as! String}
        case 103:  if(cur==3){ cell?.textLabel?.text = thirdArry![indexPath.row] as! String}
        default:   break
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(cur){
        case 1: (firstArry?.count); return firstArry == nil ? 0 : (firstArry?.count)!
        case 2: return secondArry == nil ? 0 : (secondArry?.count)!
        case 3: return thirdArry == nil ? 0 : (thirdArry?.count)!
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(cur == 1){

            let parameter = ["city":firstArry![indexPath.row],"county":"Null"]
            
            HTTPManager.POST(ContentType.Location, params: parameter).responseJSON({ (json) -> Void in
                self.secondArry = json["countys"] as? NSArray
                //print(self.firstArry?.count)
                self.loadData()
                }, error: { (error) -> Void in
                    SVProgressTool.showErrorSVProgress("出错了")
                    dPrint("发生了错误: " + (error?.localizedDescription)!)
            })
            first = firstArry![indexPath.row] as?
            String
            
        }
        if(cur == 2){

            let parameter = ["city":first!,"county":secondArry![indexPath.row]]
            
            HTTPManager.POST(ContentType.Location, params: parameter).responseJSON({ (json) -> Void in
                self.thirdArry = json["shops"] as? NSArray
                
                self.loadData()
                }, error: { (error) -> Void in
                    SVProgressTool.showErrorSVProgress("出错了")
                    dPrint("发生了错误: " + (error?.localizedDescription)!)
            })
            
            
            second = secondArry![indexPath.row] as? String
        }
        if(cur == 3){
            third = thirdArry![indexPath.row] as? String
            UserAccountTool.setAppAddressInfo(first!, area: second!, shopName: third!, callBack: { () -> () in
                NSNotificationCenter.defaultCenter().postNotificationName("reloadMainView", object: self)
                 self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        }
        cur++
    }
    //MARK: - 返回或者关闭
    @IBAction func leftButtonClicked() {
        if(cur == 1){
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            cur--
        }
        loadData()
    }
    //MARK: 重新加载数据
    func loadData(){
        switch(cur){
        case 1:
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.scrollView.contentOffset.x = 0
                }, completion: nil)
            leftButton.setTitle("关闭", forState: UIControlState.Normal)
            textLable.text = "请选择您所在的市"
            chooseLocation.text = " "
            break
        case 2:
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.scrollView.contentOffset.x = self.width
                }, completion: nil)
            leftButton.setTitle("返回", forState: UIControlState.Normal)
            textLable.text = "请选择您所在的区"
            chooseLocation.text = first!
            secondTableView!.reloadData()
            break
        case 3:
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.scrollView.contentOffset.x = self.width + self.width
                }, completion: nil)
            leftButton.setTitle("返回", forState: UIControlState.Normal)
            textLable.text = "请选择您附近的便利店"
            chooseLocation.text = first! + "-" + second!
            thirdTableView!.reloadData()
            break
        default: break
        }
    }
    
}