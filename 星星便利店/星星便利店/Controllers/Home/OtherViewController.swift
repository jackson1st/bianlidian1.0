//
//  OtherViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/20.
//  Copyright © 2016年 黄人煌. All rights reserved.
//


import UIKit
import WebKit
import SVProgressHUD
class OtherViewController: UIViewController ,UIGestureRecognizerDelegate{
    
    
    //MenuView
    @IBOutlet weak var ButtonAdd: UIButton!
    @IBOutlet weak var ButtonLiked: UIButton!
    
    var pictureView: CyclePictureView?
    var detailView: ContentView!
    @IBOutlet weak var toolBar: UIView!
    var scrollView: UIScrollView!
    
    var contentViewForEVAView: UIView!
    let userDefault = NSUserDefaults()
    var goodSizeView: UITableView!
    var prototypeCell: GoodSizeTableCell!
    var ContentViewForGoodSizeView: UIView!
    var viewDidApper = false
    var screenWidth = Int(UIScreen.mainScreen().bounds.width)
    var photoCur: Int = 0
    var titleForView: String?
    var address: String!
    var ti: NSTimer?
    var itemNo:String!{
        didSet{
            restartData()
            HTTPManager.POST(ContentType.ItemDetail, params: ["itemno":itemNo,"address":address!]).responseJSON({ [weak self] json -> Void  in
                print(json)
                let dict = json["detail"] as! [String: AnyObject]
                let model = GoodDetail()
                var arry = json["comment"] as? NSArray
                
                model.comments = [Comment]()
                for  x in arry!{
                    var xx = x as! [String: AnyObject]
                    model.comments?.append(Comment(content: xx["comment"] as? String, date: xx["commentDate"] as? String, userName: xx["custNo"] as? String))
                }
                model.barcode = dict["barcode"] as? String
                model.eshopIntegral = dict["eshopIntegral"] as! Int
                model.itemBynum1 = dict["itemBynum1"] as! String
                model.itemName = dict["itemName"] as! String
                model.itemNo = dict["itemNo"] as! String
                model.itemSalePrice = dict["itemSalePrice"] as! String
                arry = json["stocks"] as? NSArray
                model.itemStocks = [ItemStock]()
                for  x in arry!{
                    var xx = x as! [String: AnyObject]
                    model.itemStocks.append(ItemStock(name: xx["shopName"] as? String, qty: xx["stockQty"] as? Int))
                }
                
                arry = dict["itemUnits"] as? NSArray
                model.itemUnits = [ItemUnit]()
                for  x in arry!{
                    var xx = x as! [String: AnyObject]
                    model.itemUnits.append(ItemUnit(salePrice: xx["itemSalePrice"] as? String , sizeName: xx["itemSize"] as? String))
                }
                
                model.imageDetail = json["imageDetail"] as! [String]
                model.imageTop = json["imageTop"] as! [String]
                self!.item = model
                SVProgressHUD.dismiss()
                }) { (error) -> Void in
                    SVProgressTool.showErrorSVProgress("出错了")
                    print("发生了错误: " + (error?.localizedDescription)!)
            }
        }
    }
    var item: GoodDetail?{
        didSet{
            sumCountForSizeChoose = (item?.itemUnits.count)!
            var arr = [String]()
            arr.append("规格")
            for var i = 0 ; i < item?.itemUnits.count; i++ {
                print(item?.itemUnits[i].sizeName)
                arr.append((item?.itemUnits[i].sizeName)!)
            }
            data.append(arr)
            self.viewDidLoad()
        }
    }
    var data = [[String]]()
    
    //选择规格
    var dictSizeChoose = NSMutableDictionary()
    var countForSizeChoose = 0
    var sumCountForSizeChoose = 0
    
    var lastConstaint:ConstraintItem!
    /**
     页面开始加载
     */
    override func viewDidLoad() {
        title = "商品详情"
        if(theme.isFirstLoad){
            return
        }
        super.viewDidLoad()
        if(item == nil){
            return
        }
        
        changeButtonLikedState()
        changeButtonAddState()
        initAll()
   
    }
    
    //购买数量
    var viewAddNum: UIView!
    var labelAddNum: UILabel!
    var addNum: Int = 1
    
    
    
    
    //MARK: - 页面出现的事务
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if item != nil {
            self.changeButtonAddState()
        }
        if(theme.isFirstLoad == true && UserAccountTool.userIsLogin()){
            Model.defaultModel.loadDataForNetWork(nil)
            CollectionModel.CollectionCenter.loadDataFromNet(1, count: 10, success: nil, callback: { [weak self] in
                theme.isFirstLoad = false
                self!.viewDidLoad()
                })
            
        }else{
            if(theme.isFirstLoad){
                theme.isFirstLoad = false
                self.viewDidLoad()
            }
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("被销毁")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func restartData() {
        SVProgressHUD.showWithStatus("加载中啊..", maskType: SVProgressHUDMaskType.Clear)
    }
}



//MARK:-一些控件的方法
extension OtherViewController{
    
    
    //改变加入购物车按钮的状态
    func changeButtonAddState(){
        if(UserAccountTool.userIsLogin() == false){
            ButtonAdd.backgroundColor = UIColor.lightGrayColor()
            ButtonAdd.setTitle("请登录购买", forState: .Normal)
            ButtonAdd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            ButtonAdd.userInteractionEnabled = true
        }else{
            if(Model.defaultModel.itemIsExist((item?.itemNo)!)){
                ButtonAdd.backgroundColor = UIColor.lightGrayColor()
                ButtonAdd.setTitle("已加入购物车", forState: .Normal)
                ButtonAdd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                ButtonAdd.userInteractionEnabled = false
            }else{
                ButtonAdd.backgroundColor = UIColor.colorWith(237, green: 65, blue: 75, alpha: 1)
                ButtonAdd.setTitle("加入购物车", forState: .Normal)
                ButtonAdd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                ButtonAdd.userInteractionEnabled = true
            }
        }
    }
    
    //改变收藏按钮的状态
    func changeButtonLikedState(){
        if(UserAccountTool.userIsLogin() == false){
            ButtonLiked.selected = false
        }else{
            CollectionModel.CollectionCenter.find((item?.itemNo)!, success: { (flag) -> Void in
                self.ButtonLiked.selected = flag == "Y" ?? false
            })
        }
    }
    
    @IBAction func ButtonGoToShopCartClicked(sender: AnyObject) {
        let vc = mainStoryBoard.instantiateViewControllerWithIdentifier("shoppingCart") as! JFShoppingCartViewController
        presentViewController(BaseNavigationController(rootViewController: vc), animated: true, completion: nil)
        
    }
    
    //将商品加入购物车
    @IBAction func ButtonAddItemToShopCartClicked(sender: AnyObject) {
        
        if UserAccountTool.userIsLogin() {
                let JFmodel = JFGoodModel()
                JFmodel.url = item?.imageTop[0]
                JFmodel.num = addNum
                JFmodel.custNo = UserAccountTool.getUserCustNo()!
                JFmodel.itemName = item?.itemName
                JFmodel.itemNo = item?.itemNo
                JFmodel.itemSize = "没有规格"
                JFmodel.barcode = item?.barcode
                JFmodel.itemSalePrice = item?.itemSalePrice
                JFmodel.itemDistPrice = item?.itemSalePrice
                JFmodel.totalPrice = 100
                JFmodel.shopNameList = [Shop]()
                for  x in (item?.itemStocks)!{
                    print(x.shopName)
                    JFmodel.shopNameList.append(Shop(shopName:x.shopName!))
                }
                let hud = MBProgressHUD(view: self.view)
                Model.defaultModel.addItem(JFmodel, success: { () -> Void in
                    self.changeButtonAddState()
                    hud.hidden = true
                    SVProgressHUD.showSuccessWithStatus("成功添加到购物车")
                })
                theme.refreshFlag = true
        }
        else {
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
    @IBAction func ButtonLikedClicked() {
        if(UserAccountTool.userIsLogin() == false){
            SVProgressHUD.showInfoWithStatus("登录后才可以收藏哦！")
        }else{
            if(ButtonLiked.state.rawValue == 1 ){
                CollectionModel.CollectionCenter.addLiked(item!, success: { () -> Void in
                    self.ButtonLiked.selected = true
                })
                
            }else{
                CollectionModel.CollectionCenter.removeAtNo((item?.itemNo)!, success: { () -> Void in
                    self.ButtonLiked.selected = false
                })
            }
        }
    }
    
    //响应规格选择的通知
    
    func chooseSize(notification: NSNotification){
        let useInfo = notification.userInfo
        let flag = useInfo!["flag"] as! Int
        if(flag == 0){
            //取消这个规格
            countForSizeChoose--
        }else{
            countForSizeChoose++
            dictSizeChoose["规格"] = data[0][flag%100]
        }
    }
    
    //相应增加数量
    func AddNum(sender: AnyObject){
        switch(sender.tag){
        case 101:
            //减
            if(addNum>1){
                addNum--
            }
        default:
            if(addNum<99){
                addNum++
            }
        }
        labelAddNum.text = "\(addNum)"
    }
    
}

//一些初始化
extension OtherViewController{
    
    func initAll(){
        
        initScrollView()
        initPhotoScan()
        initDetailView()
        initSizeView()
        //        initButtonAddDetail()
        initNot()
        initViewAddNum()
    }
    
    //注册通知
    func initNot(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "chooseSize:", name: "ChooseSize", object: nil)
    }
    
    //初始化数量修改视图
    func initViewAddNum(){
        viewAddNum = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        viewAddNum.backgroundColor = UIColor.whiteColor()
        let
        label1 = UILabel()
        label1.textAlignment = .Left
        label1.text = "数量"
        viewAddNum.addSubview(label1)
        label1.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.left.equalTo(viewAddNum).offset(10)
            make.centerY.equalTo(viewAddNum)
        }
        let btn1 = UIButton()
        btn1.setTitle("-", forState: .Normal)
        btn1.setTitleColor(UIColor.blackColor() , forState: .Normal)
        btn1.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        btn1.layer.cornerRadius = 10
        btn1.layer.borderColor = UIColor.blackColor().CGColor
        btn1.layer.borderWidth = 0.3
        btn1.addTarget(self, action: "AddNum:", forControlEvents: .TouchUpInside)
        btn1.tag = 101
        viewAddNum.addSubview(btn1)
        btn1.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(label1.snp_right).offset(5)
            make.centerY.equalTo(viewAddNum)
        }
        
        labelAddNum = UILabel()
        labelAddNum.font = UIFont.systemFontOfSize(15)
        labelAddNum.textColor = UIColor.blackColor()
        labelAddNum.textAlignment = .Center
        labelAddNum.text = "1"
        viewAddNum.addSubview(labelAddNum)
        labelAddNum.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.left.equalTo(btn1.snp_right)
            make.centerY.equalTo(viewAddNum)
        }
        
        let btn2 = UIButton()
        
        btn2.setTitle("+", forState: .Normal)
        btn2.setTitleColor(UIColor.blackColor() , forState: .Normal)
        btn2.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        btn2.layer.cornerRadius = 8
        btn2.layer.borderColor = UIColor.blackColor().CGColor
        btn2.layer.borderWidth = 0.3
        btn2.addTarget(self, action: "AddNum:", forControlEvents: .TouchUpInside)
        btn2.tag = 102
        viewAddNum.addSubview(btn2)
        btn2.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(labelAddNum.snp_right)
            make.centerY.equalTo(viewAddNum)
        }
        let textImageLabel = UILabel()
        textImageLabel.textColor = UIColor.blackColor()
        textImageLabel.text = "图文详情"
        textImageLabel.textAlignment = .Left
        viewAddNum?.addSubview(textImageLabel)
        textImageLabel.snp_makeConstraints { (make) -> Void in
            make.leftMargin.equalTo(label1)
            make.top.equalTo(label1).offset(40)
        }
    
        

    }
    
    //初始化scrollView
    func initScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 59, width: self.view.width, height: self.view.height-59-49))
        scrollView.contentSize.width = self.view.frame.size.width
        scrollView.contentSize.height = 0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.bounces = false
        scrollView.directionalLockEnabled = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.colorWith(243, green: 241, blue: 244, alpha: 1)
        self.view.addSubview(scrollView)

    }
    
    //初始化轮播
    func initPhotoScan(){
        pictureView = CyclePictureView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width), imageURLArray: nil)
        pictureView?.imageURLArray = item?.imageTop
        pictureView?.autoScroll = true
        pictureView?.timeInterval = 3
        scrollView.addSubview(pictureView!)
        scrollView.contentSize.height += (pictureView?.height)!
        lastConstaint = pictureView?.snp_bottom
    }
    
    
    //初始化商品描述视图
    func initDetailView(){
        let nib = NSBundle.mainBundle().loadNibNamed("ItemContentView", owner: self, options: nil)
        detailView = nib[0] as! ContentView
        detailView.setLabel(item?.itemName, price: item?.itemSalePrice, sco: "积分:" + "\((item?.eshopIntegral)!)", salesNum: item?.itemBynum1)
        scrollView.addSubview(detailView)
        detailView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo((pictureView?.snp_left)!).offset(0)
            make.top.equalTo(lastConstaint).offset(10)
            make.width.equalTo((pictureView?.snp_width)!).offset(0)
        }
        scrollView.contentSize.height += detailView.height
        lastConstaint = detailView.snp_bottom
    }
    
    
    func initButtonAddDetail(){
        let buttonAddDetail = UIButton(type: .Custom)
        buttonAddDetail.addBottomLine(0.3, offsetLeft: 0, offsetRight: 0)
        buttonAddDetail.backgroundColor = UIColor.whiteColor()
        buttonAddDetail.setTitle("查看商品详情", forState: .Normal)
        buttonAddDetail.setTitleColor(UIColor.blackColor() , forState: .Normal)
        buttonAddDetail.addTarget(self, action: "addMoreEVA", forControlEvents: .TouchUpInside)
        scrollView.addSubview(buttonAddDetail)
        buttonAddDetail.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(lastConstaint).offset(10)
            make.left.equalTo(pictureView!).offset(0)
            make.width.equalTo(self.view.frame.width)
        }
        lastConstaint = buttonAddDetail.snp_bottom
    }
    
    
    //初始化规格视图
    func initSizeView(){
        goodSizeView = UITableView()
        goodSizeView.restorationIdentifier = "GoodSizeView"
        ContentViewForGoodSizeView = UIView()
        scrollView.addSubview(goodSizeView)
        //        ContentViewForGoodSizeView.addSubview(goodSizeView)
        goodSizeView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(lastConstaint).offset(10)
            make.width.equalTo(detailView.snp_width).offset(0)
            make.left.equalTo(detailView.snp_left).offset(0)
            make.height.equalTo(80)
        }
        goodSizeView.delegate = self
        goodSizeView.dataSource = self
        goodSizeView.scrollEnabled = false
        let nib = UINib(nibName: "GoodSizeTableCell", bundle: nil)
        goodSizeView.registerNib(nib, forCellReuseIdentifier: "GoodSizeCell")
        lastConstaint = goodSizeView.snp_bottom
        goodSizeView.sizeToFit()
        
        var counts:CGFloat = 0
        let width = self.view.frame.width
        var hg: CGFloat
        if UIDevice.currentDeviceScreenMeasurement() == 3.5 {
            hg = 510
        }
        else if UIDevice.currentDeviceScreenMeasurement() == 4.0 {
            hg = 510
        }
        else if UIDevice.currentDeviceScreenMeasurement() == 4.7 {
            hg = 560
        }
        else {
            hg = 600
        }
        
        for  x in (item?.imageDetail)!{
            
            let imgView = UIImageView(frame: CGRect(x: 0 , y: hg + 300 * counts , width: width, height: width))
            imgView.sd_setImageWithURL(NSURL(string: x))
            imgView.clipsToBounds = true
            counts++
            scrollView.contentSize.height += width + 10
            scrollView.addSubview(imgView)
        }
    }

    
}

//tableView代理
extension OtherViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(tableView.restorationIdentifier == "GoodSizeView"){
//            return data.count
//        }else{
            return 0
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        viewDidApper = true
        let cell = tableView.dequeueReusableCellWithIdentifier("GoodSizeCell") as! GoodSizeTableCell
//        var buttons = [UIButton]()
//        for(var i = 1 ; i < data[indexPath.row].count ; i++ ){
//            let button = UIButton()
//            button.setTitle(data[indexPath.row][i], forState: .Normal)
//            button.setTitle(data[indexPath.row][i], forState: .Selected)
//            button.frame.size        = (data[indexPath.row][i] as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15.0)])
//            button.setTitleColor(UIColor.blackColor() , forState: .Normal)
//            button.titleLabel?.font  = UIFont.systemFontOfSize(15)
//            button.frame.size.width += 15
//            button.frame.size.height += 5
//            buttons.append(button)
//        }
//        cell.sizeTag        = (indexPath.row+1)*100
//        cell.buttons        = buttons
//        cell.nameLabel.text = data[indexPath.row][0]
//        cell.selectionStyle = .None
//        prototypeCell = cell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return viewAddNum
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
}


