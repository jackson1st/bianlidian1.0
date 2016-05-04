//
//  SortViewController.swift
//  webDemo
//
//  Created by Jason on 15/11/8.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class SortViewController: UIViewController{

    var tableViewLeft: UITableView!
    var collectionViewRight: UICollectionView!
    lazy var bigClass = [smallClass]()
    var smallCalsses = [smallClass]()
    var address: String!
    var userDefault = NSUserDefaults()
    var lastCell:UITableViewCell?
    private var ti: NSTimer?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor.colorWith(242, green: 50, blue: 65, alpha: 1)
        let appAddress = UserAccountTool.getAppAddressInfo()
        address = "\(appAddress![0])-\(appAddress![1])-\(appAddress![2])"
        initAll()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if bigClass.count == 0 {
            restartData(nil)
        }
    }
    
    lazy var searchVC:SearcherViewController = {
        let vc = mainStoryBoard.instantiateViewControllerWithIdentifier("searchView") as! SearcherViewController
        vc.delegate = self
        return vc
    }()
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    //响应搜索按钮的方法
    func pushSearchViewController(){
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func restartData(index:NSIndexPath?) {
        registerNetObserve(4)
        SVProgressHUD.showWithStatus("加载中啊..", maskType: SVProgressHUDMaskType.Clear)
        initData(index)
    }
}
//MARK:-一些初始化
extension SortViewController{
    
    func initAll(){
        initSearch()
        initTableview()
        initCollectionView()
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    
    func initSearch(){
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "输入便利店或商品名称"
        navigationItem.titleView = searchBar
    }
    
    func initData(index:NSIndexPath?){
        weak var tmpSelf = self
        HTTPManager.POST(ContentType.ItemBigClass, params: nil).responseJSON({ (json) -> Void in
            tmpSelf?.bigClass.removeAll()
            let bigclass = json["bigClass"] as? NSArray
            var tg = true
            for(var i=1; i<bigclass?.count; i++){
                tmpSelf!.bigClass.append(smallClass(dict: bigclass![i] as! [String:AnyObject]))
                if tg {
                    let properties = bigclass![i]["classList"] as? NSArray
                    for  y in properties!{
                        tmpSelf!.smallCalsses.append(smallClass(dict: y as! [String:AnyObject]))
                    }
                    tg = false
                }
            }
            tmpSelf!.tableViewLeft.reloadData()
            tmpSelf!.collectionViewRight.reloadData()
            if index != nil{
                tmpSelf!.tableView(tmpSelf!.tableViewLeft, didSelectRowAtIndexPath: index!)
            }
            else {
                tmpSelf!.tableView(tmpSelf!.tableViewLeft, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            }
            SVProgressHUD.dismiss()
            }) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("发生了错误")
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
    
    func initTableview(){
        tableViewLeft = UITableView()
        tableViewLeft.delegate = self
        tableViewLeft.dataSource = self
        tableViewLeft.rowHeight = 40
        tableViewLeft.separatorStyle = .None
        tableViewLeft.backgroundColor = UIColor.colorWithCustom(239, g: 239, b: 239)
        self.view.addSubview(tableViewLeft)
        tableViewLeft.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(90)
            make.left.equalTo(view)
            make.top.equalTo(view).offset(0)
            make.bottom.equalTo(view.snp_bottom)
        }
    }
    
    func initCollectionView(){
        let flowLayout =  UICollectionViewFlowLayout()
        
        //        flowLayout.itemSize = self.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewRight = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionViewRight.delegate = self
        collectionViewRight.dataSource = self
        collectionViewRight.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionViewRight)
        collectionViewRight.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(tableViewLeft.snp_right)
            make.top.equalTo(view).offset(64)
            make.right.equalTo(view)
            make.bottom.equalTo(view.snp_bottom)
        }
        var nib = UINib(nibName: "smallClassCell", bundle: nil)
        collectionViewRight.registerNib(nib, forCellWithReuseIdentifier: "cell")
    }
    
}

// MARK: - UISearchBarDelegate
extension SortViewController: UISearchBarDelegate{
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        pushSearchViewController()
        return false
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension SortViewController: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bigClass.count > 0  {
            return bigClass.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = CategoryCell.cellWithTableView(tableView)
        cell.categorie = bigClass[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        updateSmallCell(indexPath)
    
    }
    
    func updateSmallCell(indexPath: NSIndexPath){
        let cell = tableViewLeft.cellForRowAtIndexPath(indexPath)
        if(cell?.backgroundColor == UIColor.whiteColor()){
            return
        }
        smallCalsses.removeAll()
        lastCell?.backgroundColor = UIColor.colorWithCustom(239, g: 239, b: 239)
        cell?.backgroundColor = UIColor.whiteColor()
        lastCell = cell
        weak var tempSelf = self
        SVProgressHUD.showWithStatus(nil)
        HTTPManager.POST(ContentType.ItemSmallClass, params: ["classno": bigClass[indexPath.row].itemclass!]).responseJSON({ (json) -> Void in
            let properties = json["property"]!["classList"] as! NSArray
            for  y in properties{
                self.smallCalsses.append(smallClass(dict: y as! [String:AnyObject]))
            }
            tempSelf!.collectionViewRight.reloadData()
            self.tableViewLeft.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
            SVProgressHUD.dismiss()
        }) { (error) -> Void in
            print("发生了错误: " + (error?.localizedDescription)!)
            SVProgressTool.showErrorSVProgress("出错了")
        }
    }
    
}

// MARK: - SearcherViewControllerDelegate
extension SortViewController: SearcherViewControllerDelegate{
    func pushResultViewController(resultV: SearcherResultViewController) {
        resultV.hidesBottomBarWhenPushed = true
        self.navigationController?.popViewControllerAnimated(false)
        self.navigationController?.pushViewController(resultV, animated: true)
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension SortViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallCalsses.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionViewRight.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! smallClassCell
        cell.cellData = smallCalsses[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SearcherResultViewController()
        vc.address = address
        vc.findByClass = true
        vc.keyForSearchResult = smallCalsses[indexPath.row].itemclass
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((AppWidth - tableViewLeft.width)/3, 120)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    
}
