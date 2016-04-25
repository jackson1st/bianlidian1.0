//
//  MyLikeViewController.swift
//  Demo
//
//  Created by Jason on 1/27/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
class MyLikeViewController: UITableViewController {

    var index = 1
    var count = 10
    var Likes: [LikedModel]? {
        didSet {
            if Likes?.count == 0{
                lackOfInformation.hidden = false
                tableView.mj_footer.hidden = true
            }
            else {
                lackOfInformation.hidden = true
                tableView.mj_footer.hidden = false
            }
        }
    }
    var itemVC: OtherViewController?
    private var lackOfInformation: LackOfInformationView!
    var address: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNetObserve(64)
        
        let appAddress = UserAccountTool.getAppAddressInfo()
        address = "\(appAddress![0])-\(appAddress![1])-\(appAddress![2])"
        initAll()
        tableView.backgroundColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
        navigationItem.title = "我的收藏"
        lackOfInformation = LackOfInformationView(frame: CGRectMake(0, 0, AppWidth, AppHeight), imageName: "noorders", title: "暂无收藏")
        self.tableView.addSubview(lackOfInformation)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(Likes == nil){
            CollectionModel.CollectionCenter.loadDataFromNet(index, count: count, success: nil, callback: { () -> Void in
                self.index++
                self.Likes =  CollectionModel.CollectionCenter.Likes
                self.tableView.reloadData()
            })
            return 0
        }else{
            return Likes!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! LikeTableViewCell
        cell.model = Likes![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(itemVC == nil){
            itemVC = mainStoryBoard.instantiateViewControllerWithIdentifier("itemDetail") as! OtherViewController
            itemVC?.address = address
        }
        itemVC?.itemNo = Likes![indexPath.row].no
        self.navigationController?.pushViewController(itemVC!, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        CollectionModel.CollectionCenter.removeAtNo(Likes![indexPath.row].no) { () -> Void in
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
}
extension MyLikeViewController{
    
    func initAll(){
        initHeaderRefresh()
        initFootRefresh()
        initTableview()
    }
    
    func initTableview(){
        tableView.registerNib(UINib(nibName: "LikeTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")
        tableView.rowHeight = 103
    }
    
    func initHeaderRefresh(){
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.getNewData({ () -> Void in
                self.tableView.mj_header.endRefreshing()
                self.tableView.reloadData()
            })
            
        })
    }
    
    func getNewData(callback: (() -> Void)){
        CollectionModel.CollectionCenter.loadDataFromNet(1, count: 100, success: { (data) -> Void in
            
            let model:LikedModel!
            if(self.Likes!.count>0){
                model = self.Likes![0]
            }else{
                model = LikedModel(No: "-1", price: nil, name: "xx", url: "xx", unitNo: nil, size: nil, pack: nil)
            }
            
            for(var i = 0;i < data.count;i++){
                if(data[i].no == model.no){
                    break
                }else{
                    self.Likes!.insert(data[i], atIndex: i)
                }
            }
            var i = 0
            for var x in self.Likes!{
                CollectionModel.CollectionCenter.dict[x.no] = i
                i++
            }
            }) { () -> Void in
                callback()
        }
    }
    
    func initFootRefresh(){
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadNetData({ () -> Void in
                self.index++
                self.tableView.mj_footer.endRefreshing()
                self.tableView.reloadData()
            })
        })
        
        //清楚多余的线
        let iview = UIView()
        iview.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = iview
    }
    
    func loadNetData(callback: () -> Void){
        CollectionModel.CollectionCenter.loadDataFromNet(index, count: count, success: { (data) -> Void in
            if(data.count == 0){
                SVProgressHUD.showInfoWithStatus("已经没有更多数据了")
            }
            for var x in data{
                CollectionModel.CollectionCenter.dict[x.no] = self.Likes!.count
                self.Likes!.append(x)
            }
            
            }) { () -> Void in
                callback()
        }
        
    }
    
}
