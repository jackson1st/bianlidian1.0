//
//  MainViewController.swift
//  webDemo
//
//  Created by jason on 15/11/7.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: UIViewController,WKNavigationDelegate,UISearchBarDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,UITextFieldDelegate,UIScrollViewDelegate{
    //一些变量的定义
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var ButtonGift: JSButton!
    var webView: WKWebView?
    var nextURLRequest: NSURLRequest?
    var rightBarButton:UIBarButtonItem?
    var leftBarButton: UIBarButtonItem?
    //设置相关
    let httpManager = AFHTTPRequestOperationManager()
    let userDefault = NSUserDefaults()
    //网页初始化相关
    var index: String?
    var content: NSDictionary?
    
    //搜索相关
    var TextFieldSearchBar: UITextField!
    var ViewSearch: UIView!
    @IBOutlet weak var ButtonSearch: UIButton!
    //定位按钮
    @IBOutlet weak var ButtonLocation: UIButton!
    var address:String?
    
    //商品model
    var itemno: String!
    //拥有一个SearcherResultViewController
    
    //礼券Model
    var giftModels = [GiftModel]()
    var giftVC:GiftViewController?
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "viewDidLoad", name: "reloadMainView", object: nil)
        
        self.registerNetObserve(62)
        
        let reachability = Reachability.reachabilityForInternetConnection()
        
        //判断连接状态
        if !reachability!.isReachable(){
            NSNotificationCenter.defaultCenter().postNotificationName("netWorkbad", object: self)
            return 
        }
        
        if(userDefault.boolForKey("needSetLocation") == false){
            self.performSegueWithIdentifier("showLocation", sender: nil)
        }else{
            initAll()
        }
        
        super.viewDidLoad()
//        let view = self.view.viewWithTag(120)
//        self.view.bringSubviewToFront(view!)
        ButtonLocation.sizeToFit()
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
//MARK: - 页面跳转操作
extension MainViewController{
    //隐藏tabBar的方法：在跳转之前调用self.hidesBottomBarWhenPushed = true
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let vc = segue.destinationViewController
        vc.hidesBottomBarWhenPushed = true
        if( vc.isKindOfClass(OtherViewController)){
            let vc2 = vc as! OtherViewController
            vc2.address = address
            vc2.itemNo = itemno
        }else{
            if(vc.isKindOfClass(SearcherViewController)){
                let vc2 = vc as! SearcherViewController
                vc2.delegate  = self
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        if(userDefault.boolForKey("needSetLocation") == false){
            self.performSegueWithIdentifier("showLocation", sender: nil)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
// MARK: - 临时解决点击搜索栏后，搜索栏会下移一个搜索栏高的距离
        webView?.scrollView.contentOffset.y = -40
        super.viewWillAppear(animated)
        self.ButtonGift.edge = String(DataCenter.shareDataCenter.canGetCoupons.count)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
}

extension MainViewController: SearcherViewControllerDelegate{
    func pushResultViewController(SearchResultVC: SearcherResultViewController) {
        self.navigationController?.popViewControllerAnimated(false)
        self.navigationController?.pushViewController(SearchResultVC, animated: true)
    }
}

//MARK: - 一些初始化操作
extension MainViewController{
    
    func initAll(){
        initWebView()
        initViewSearch()
        initGiftModel()
    }
    
    func initGiftModel(){
        self.ButtonGift.button.setTitle("券", forState: .Normal)
        weak var tmpSelf = self
        ButtonGift.buttonAction = {
            ()->() in
            if(tmpSelf!.giftVC == nil){
                tmpSelf!.giftVC = GiftViewController()
                tmpSelf!.giftVC?.mode = 0
                tmpSelf!.giftVC?.gifts = tmpSelf!.giftModels
            }
            tmpSelf!.pushViewController(self.giftVC!, animated: true, completion: nil)
        }
       DataCenter.shareDataCenter.updateCanGetCoupons { (couponCount) -> Void in
            self.giftModels = DataCenter.shareDataCenter.canGetCoupons
            print("我是优惠券数量\(couponCount)")
            self.ButtonGift.edge = String(couponCount)
        }
    }
    
    func initViewSearch(){
        
        ViewSearch = UIView(frame: CGRect(x: 0, y:-40, width: self.view.frame.width, height: 40))
        ViewSearch.backgroundColor = UIColor.colorWith(245, green: 77, blue: 86, alpha: 1)
        webView?.scrollView.addSubview(ViewSearch)
        
        TextFieldSearchBar = UITextField()
        TextFieldSearchBar.backgroundColor = UIColor.whiteColor()
        TextFieldSearchBar.placeholder = "输入便利店或商品名称"
        TextFieldSearchBar.font = UIFont.systemFontOfSize(15)
        TextFieldSearchBar.layer.cornerRadius = 4
        TextFieldSearchBar.textAlignment = .Center
        ViewSearch.addSubview(TextFieldSearchBar)
        TextFieldSearchBar.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(ViewSearch)
            make.left.equalTo(ViewSearch).offset(20)
            make.height.equalTo(26)
        }
        TextFieldSearchBar.delegate = self
    }
    
    func initWebView(){
        let config = WKWebViewConfiguration()
        config.userContentController.addScriptMessageHandler(self, name: "gan")
        webView = WKWebView(frame: CGRect(x: 0, y:55, width: self.view.frame.width, height: self.view.frame.height-58),configuration: config)
        webView?.scrollView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        webView?.scrollView.frame.size.width = self.view.frame.width
        webView?.scrollView.bounces = false
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.delegate = self
        webView!.navigationDelegate = self
        
        self.address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        let hud = MBProgressHUD.showMessage("加载中", toView: webView!)
        
        HTTPManager.POST(ContentType.WebData, params: ["address":self.address!,"page":"home","type":"Android"]).responseJSON({  [weak self] json -> Void in
            self!.index = json["index"] as? String
            self!.content = json["txt"] as? NSDictionary
            self!.webView?.loadRequest(NSURLRequest(URL: NSURL(string: self!.index!)!))
            }, hud: hud) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
        
        //MARK:顺便更新地位按钮名称，显示当前的小区
        let str = address!.stringByReplacingOccurrencesOfString("-", withString: "")
        ButtonLocation.setTitle(str, forState: .Normal)
        
        self.view.addSubview(webView!)
    }
    
}


//MARK:- WebView一些操作
extension MainViewController{
    
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
        challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        print("我要跳转了！")
        let url = navigationAction.request.URL
        print(url!.absoluteString)
        if(url!.absoluteString != index){
            decisionHandler(WKNavigationActionPolicy.Cancel)
            nextURLRequest = navigationAction.request
            self.performSegueWithIdentifier("showHome", sender: self)
        }else{
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        let data = try? NSJSONSerialization.dataWithJSONObject(self.content!, options: NSJSONWritingOptions())
        let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //str = str?.stringByReplacingOccurrencesOfString("/", withString: "")
        //            str = str?.stringByReplacingOccurrencesOfString("\"", withString: "")
        //print(str)
        let str1 = "'" + (str as! String) + "'"
        self.webView?.evaluateJavaScript("load(\(str1),'iPhone')", completionHandler: { (response,error) -> Void in
            print(response)
            print(error)
        })
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        //MARK:接收到点击了哪个商品
        itemno = "\(message.body)"
        self.performSegueWithIdentifier("showHome", sender: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y > 0 ? 0: scrollView.contentOffset.y
        if( y != 0){
            if(ButtonSearch.hidden == false){
                ButtonSearch.hidden = true
            }
        }else{
            if(ButtonSearch.hidden == true){
                ButtonSearch.hidden = false
            }
        }
    }
    
}

//MARK:-一些控件的方法
extension MainViewController{
    
    @IBAction func ButtonLocationClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("showLocation", sender: nil)
    }
    
    @IBAction func ButtonSearchClicked(sender: AnyObject) {
        textFieldDidBeginEditing(TextFieldSearchBar)
    }
    
    
    
}

//MARK:- TextField's delegate
extension MainViewController{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.resignFirstResponder()
        self.hidesBottomBarWhenPushed = true
        self.performSegueWithIdentifier("showSearcher", sender: nil)
        self.hidesBottomBarWhenPushed = false
    }
}











