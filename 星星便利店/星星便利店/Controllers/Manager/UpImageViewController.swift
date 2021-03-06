//
//  UpImageViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/4/22.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import MJRefresh

class UpImageViewController: UIViewController {
    
    private var pageIndex = 1
    private var data: [UpImageModel] = []
    private var searchType = ["itemname","itemno","barcode"]
    
    
    private lazy var search: UISearchBar = {
        let search: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: NavigationH, width: AppWidth, height: 40))
        search.backgroundImage = UIImage(named: "v2_background")
        search.placeholder = "按名称/条形码/编码 搜索商品信息"
        search.delegate = self 
        return search
    }()
    
    private lazy var searchSegment: UISegmentedControl = {
        
        let searchSegment = UISegmentedControl(items: ["按名称","按编码","按条形码"])
        searchSegment.selectedSegmentIndex = 0
        searchSegment.frame = CGRectMake(0, NavigationH + 40, AppWidth, 30)
        searchSegment.addTarget(self, action: #selector(UpImageViewController.segChange), forControlEvents: UIControlEvents.ValueChanged)
        return searchSegment
    }()
    
    private lazy var searchTableView: UITableView = {
        
        let searchTableView = UITableView(frame: CGRect(x: 0, y: NavigationH + 40 + 30, width: AppWidth,height: AppHeight - NavigationH - 70), style: UITableViewStyle.Plain)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.registerNib(UINib(nibName: "upImageCell", bundle: nil), forCellReuseIdentifier: "cell")
        searchTableView.rowHeight = 70
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(UpImageViewController.keyboardHide))
        tapGestureRecognizer.cancelsTouchesInView = false
        searchTableView.addGestureRecognizer(tapGestureRecognizer)
        searchTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            self.loadData(true)
            searchTableView.mj_header.endRefreshing()
        })
        searchTableView.mj_footer = MJRefreshBackFooter(refreshingBlock: { 
            self.loadData(false)
            searchTableView.mj_footer.endRefreshing()
        })
        
        return searchTableView
        
    }()
    
    override func viewDidLoad() {
        
        bulidUI()
    }
    
    
    func bulidUI() {
        
        title = "图片管理"
        
        
        view.addSubview(search)
        view.addSubview(searchSegment)
        view.addSubview(searchTableView)
    }
    
    func segChange(){
        search.text = nil
    }
    
    func keyboardHide(){
        search.resignFirstResponder()
    }
    
    func loadData(isRefresh:Bool){
        
        if isRefresh == true {
            let mbp = MBProgressHUD(view: view)
            let param = ["pageindex":"\(pageIndex)","pagecount":"10","\(searchType[searchSegment.selectedSegmentIndex])":search.text!]
            HTTPManager.POST(ContentType.MobileItem, params: param).responseJSON({ (json) in
                
                var model:[UpImageModel] = []
                
                let array = json["itemList"]!["list"] as! NSArray
                
                
                for x in array {
                    
                    model.append(UpImageModel(dict: x as! NSDictionary))
                    
                }
                self.pageIndex = 1
                self.data = model
                self.searchTableView.reloadData()
                self.search.resignFirstResponder()
                
            }, hud: mbp) { (error) in
                SVProgressTool.showErrorSVProgress("发生错误了")
            }
        }
        else {
            self.pageIndex += 1
            let mbp = MBProgressHUD(view: view)
            let param = ["pageindex":"\(pageIndex)","pagecount":"10","\(searchType[searchSegment.selectedSegmentIndex])":search.text!]
            HTTPManager.POST(ContentType.MobileItem, params: param).responseJSON({ (json) in
                
                let array = json["itemList"]!["list"] as! NSArray
                
                
                for x in array {
                    
                    self.data.append(UpImageModel(dict: x as! NSDictionary))
                    
                }
    
                self.searchTableView.reloadData()
                self.search.resignFirstResponder()
                
            }, hud: mbp) { (error) in
                SVProgressTool.showErrorSVProgress("发生错误了")
            }
        }
        
    }
    
    
}

extension UpImageViewController: UISearchBarDelegate{
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        search.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
         loadData(true)
        
    }
    
}

extension UpImageViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! upImageCell
        cell.data = data[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let story = UIStoryboard.init(name: "ManagerStoryboard", bundle: nil)
        let vc = story.instantiateViewControllerWithIdentifier("UpImageController") as! UpImageController
        vc.data = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}