//
//  JFShoppingCartViewController.swift
//  shoppingCart
//
//

import UIKit
import MJRefresh
import SVProgressHUD
class JFShoppingCartViewController: BaseViewController{
    
    // MARK: - 私有属性
    /// 可选商品数组
    private var canSelectShop: [String] = []
    /// 已选择店铺
    private var shopName = "无"
    /// 传入金额
    private var payPrice: CFloat = 0.00
    /// 总金额，默认0.00
    private var price: CFloat = 0.00
    /// tableView
    @IBOutlet var tableView: UITableView!
    /// 商品列表cell的重用标识符
    private let shoppingCarCellIdentifier = "shoppingCarCell"
    
    
    // MARK: - view生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNetObserve(64)
        
        showMySelect()

        creatUIControl()
        
        if(UserAccountTool.userIsLogin()) {
            
            prepareUiForLogin()
            
        }
            
        else {
            
            prepareUiForNoLogin()
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //布局UI
        layoutUI()
        if(UserAccountTool.userIsLogin()) {
            
            prepareUiForLogin()
            
        }
            
        else {
            
            prepareUiForNoLogin()
        }
    }
    
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: UI控件以及布局
    
    /**
     创建UI控件
     */
    private func creatUIControl() {
        
        // 标题
        navigationItem.title = "购物车列表"
        // 导航栏左边返回
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedBackButton")
        let clearView: UIView = UIView()
        clearView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = clearView
        view.backgroundColor = theme.SDBackgroundColor
        
        // 添加子控件
        view.addSubview(bottomView)
        view.addSubview(noLoginImageView)
        view.addSubview(loginButton)
        view.addSubview(resignButton)
        view.addSubview(goShoppingButton)
        bottomView.addSubview(selectButton)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(buyButton)
    }
    
    private func  prepareUiForNoLogin() {
        tableView.hidden = true
        bottomView.hidden = true
        loginButton.hidden = false
        resignButton.hidden = false
        goShoppingButton.hidden = true
        noLoginImageView.hidden = false
        
        noLoginImageView.frame = CGRect(x: (AppWidth - 240)/2, y: 112, width: 240, height: 240)
        noLoginImageView.image = UIImage(named: "未登录页面")
        self.view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
    }
    
    
    private func prepareUiForLogin(){
        
        if(Model.defaultModel.shopCart.count == 0){
            self.tableView.hidden = true
            self.bottomView.hidden = true
            self.loginButton.hidden = true
            self.resignButton.hidden = true
            self.goShoppingButton.hidden = false
            self.noLoginImageView.hidden = false
            self.noLoginImageView.frame = CGRect(x: (AppWidth - 240)/2, y: 79, width: 240, height: 240)
            self.noLoginImageView.image = UIImage(named: "没有商品图片")
            self.view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        }
        else {
            self.tableView.hidden = false
            self.bottomView.hidden = false
            self.loginButton.hidden = true
            self.resignButton.hidden = true
            self.goShoppingButton.hidden = true
            self.noLoginImageView.hidden = true
            
            
            self.tableView.delegate = self
            
            self.tableView.dataSource = self
            
            self.tableView.registerClass(JFShoppingCartCell.self, forCellReuseIdentifier: self.shoppingCarCellIdentifier)
            // 设置TableViewHeader
            self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
                self.tableView.reloadData()
                self.showMySelect()
                self.tableView.mj_header.endRefreshing()
            })
            // 判断是否需要全选
            
            for model in Model.defaultModel.shopCart {
                if model.selected != true && model.canChange == true{
                    // 只要有一个不等于就不全选
                    self.selectButton.selected = false
                    break
                }
            }
        }
        
        
        
    }
    
    
    /**
     布局UI
     */
    private func layoutUI() {
        
        // 约束子控件

        bottomView.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
        totalPriceLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(bottomView.snp_centerX)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
        
        
    }
    
    // MARK: - 懒加载
    
    
    /// 底部视图
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.whiteColor()
        bottomView.addTopLine(0.5, offsetLeft: 0.001, offsetRight: 0.0001)
        return bottomView
    }()
    
    /// 底部多选、反选按钮
    lazy var selectButton: UIButton = {
        let selectButton = UIButton(type: UIButtonType.Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: UIControlState.Normal)
        selectButton.setImage(UIImage(named: "check_y"), forState: UIControlState.Selected)
        selectButton.setTitle("多选\\反选", forState: UIControlState.Normal)
        selectButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        selectButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        selectButton.addTarget(self, action: "didTappedSelectButton:", forControlEvents: UIControlEvents.TouchUpInside)
        selectButton.selected = true
        selectButton.sizeToFit()
        return selectButton
    }()
    
    /// 底部总价Label
    lazy var totalPriceLabel: UILabel = {
        let totalPriceLabel = UILabel()
        let attributeText = NSMutableAttributedString(string: "总价：\(self.price)")
        attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText.length - 3))
        
        totalPriceLabel.attributedText = attributeText
        totalPriceLabel.sizeToFit()
        return totalPriceLabel
    }()
    
    /// 底部付款按钮
    lazy var buyButton: UIButton = {
        let buyButton = UIButton(type: UIButtonType.Custom)
        buyButton.setTitle("付款", forState: UIControlState.Normal)
        buyButton.setBackgroundImage(UIImage(named: "button_cart_add"), forState: UIControlState.Normal)
        buyButton.frame = CGRect(x: AppWidth - 100, y: 9, width: 88, height: 30)
        buyButton.layer.cornerRadius = 15
        buyButton.layer.masksToBounds = true
        buyButton.addTarget(self, action: #selector(JFShoppingCartViewController.payButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return buyButton
    }()
    
    
    /// 未登录页面
    lazy var noLoginImageView: UIImageView = {
        let noLoginImageView = UIImageView()
        return noLoginImageView
    }()
    
    /// 登录按钮
    lazy var loginButton: UIButton = {
        let loginButton = UIButton(frame: CGRect(x: (AppWidth - 240)/2 + 27, y: 322, width: 85, height: 32))
        loginButton.setBackgroundImage(UIImage(named: "购物车登录"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(JFShoppingCartViewController.enterLoginView), forControlEvents: UIControlEvents.TouchUpInside)
        return loginButton
    }()
    
    /// 注册按钮
    lazy var resignButton: UIButton = {
        let resignButton = UIButton(frame: CGRect(x: (AppWidth - 240)/2 + 122, y: 322, width: 85, height: 32 ))
        resignButton.setBackgroundImage(UIImage(named: "购物车注册"), forState: UIControlState.Normal)
        resignButton.addTarget(self, action: #selector(JFShoppingCartViewController.enterResignView), forControlEvents: UIControlEvents.TouchUpInside)
        return resignButton
    }()
    
    /// 去逛逛按钮
    lazy var goShoppingButton: UIButton = {
        let goShoppingButton: UIButton = UIButton(frame: CGRect(x: (AppWidth - 240)/2 + 34, y: 322, width: 168, height: 30))
        goShoppingButton.setBackgroundImage(UIImage(named: "去逛逛"), forState: UIControlState.Normal)
        goShoppingButton.addTarget(self, action: #selector(JFShoppingCartViewController.didTappedBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        return goShoppingButton
    }()
}


// MARK: - UITableViewDataSource, UITableViewDelegate数据、代理
extension JFShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.defaultModel.shopCart.count + 1 ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 50
        }
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if( indexPath.row == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("selectBrunchCell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            let selectBruchButton = cell?.viewWithTag(100) as? UIButton
            selectBruchButton?.addTarget(self, action: #selector(JFShoppingCartViewController.selectAlert), forControlEvents: UIControlEvents.TouchUpInside)
            selectBruchButton?.setTitle("当前店铺:\(shopName)", forState: UIControlState.Normal)
        }
        else {
            
            // 从缓存池创建cell,不成功就根据重用标识符和注册的cell新创建一个
            let cell2 = tableView.dequeueReusableCellWithIdentifier(shoppingCarCellIdentifier, forIndexPath: indexPath) as! JFShoppingCartCell
            // cell取消选中效果
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            // 指定代理对象
            cell2.delegate = self
            
            // 传递模型
            cell2.goodModel = Model.defaultModel.shopCart[indexPath.row - 1]
            
            if cell2.goodModel?.canChange == false {
                
            }
            else {
                cell2.backgroundColor = UIColor.whiteColor()
            }
            return cell2
        }

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reCalculateGoodCount()
    }
    internal func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    internal func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    internal func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        Model.defaultModel.removeAtIndex(indexPath.row - 1) { () -> Void in
            tableView.deleteRowsAtIndexPaths([indexPath],withRowAnimation: UITableViewRowAnimation.Fade)
            self.showMySelect()
            self.prepareUiForLogin()
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
}
// MARK: - UIActionSheetDelegate事件处理
extension JFShoppingCartViewController : UIActionSheetDelegate {
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if(buttonIndex <= self.canSelectShop.count && buttonIndex > 0) {
            
        self.shopName = self.canSelectShop[buttonIndex - 1]
        self.canChange(self.shopName)
        self.tableView.reloadData()
        self.reCalculateGoodCount()
            
        }
    }
    
}
// MARK: - view上的一些事件处理
extension JFShoppingCartViewController {
    
    //开始刷新
    func startRefreshView(){
        
    }
    //停止刷新
    func stopRefreshView(){
        
    }
    /**
     返回按钮
     */
    @objc private func didTappedBackButton() {
        
       dismissViewControllerAnimated(true, completion: nil)
    }
    /**
     付款按钮
     */
    func payButtonAction(){
        
        let payStotyBoard = UIStoryboard(name: "PayStoryboard", bundle: nil)
        let next = payStotyBoard.instantiateViewControllerWithIdentifier("payView") as! PayViewController
        next.shopNo = shopNoByName(shopName)
        for var i = 0; i<Model.defaultModel.shopCart.count; i++ {
            if(Model.defaultModel.shopCart[i].selected == true ) {
                next.payModel.append(Model.defaultModel.shopCart[i])
            }
        }
        
        if next.payModel.count > 0 {
            DataCenter.shareDataCenter.updateIntegral()
            DataCenter.shareDataCenter.updateAllCoupons(shopNoByName(shopName)) { (couponList) -> Void in
                next.canUseCoupon = couponList
                if next.canUseCoupon.count > 0 {
                    next.stampInfo = "有\(next.canUseCoupon.count)张优惠券可使用"
                }
                else {
                    next.stampInfo = "暂无可用优惠券"
                }
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
        else {
            SVProgressTool.showErrorSVProgress("商品不能为空")
        }
    }
    /**
     重新计算商品数量
     */
    private func reCalculateGoodCount() {
        
        // 遍历模型
        for model in Model.defaultModel.shopCart{
            
            // 只计算选中的商品
            if model.selected == true && model.canChange == true {
                var str = model.itemSalePrice! as NSString
                let isPerfix = str.hasPrefix("￥")
                if isPerfix {
                    str = str.substringFromIndex(1)
                }
                price += Float(model.num) * (str).floatValue
            }
        }
        
        // 判断是否需要全选
        
        for model in Model.defaultModel.shopCart {
            if model.selected != true && model.canChange == true{
                // 只要有一个不等于就不全选
                self.selectButton.selected = false
                break
            }
        }
        
        let applyMoney = Double(price)
        // 赋值价格
        let attributeText = NSMutableAttributedString(string: "总价：\(applyMoney.roundedToTwoDecimals())")
        attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText.length - 3))
        totalPriceLabel.attributedText = attributeText
        
        
        //赋值给payPrice
        
        payPrice = price
        
        // 清空price
        price = 0
        
        // 刷新表格
        tableView.reloadData()
    }
    
    /**
     点击了多选按钮后的事件处理
     
     - parameter button: 多选按钮
     */
    @objc private func didTappedSelectButton(button: UIButton) {
        
        selectButton.selected = !selectButton.selected
        for model in Model.defaultModel.shopCart {
            if model.canChange == true  {
                model.selected = selectButton.selected
                
            }
        }
        
        // 重新计算总价
        reCalculateGoodCount()
        
        // 刷新表格
        tableView.reloadData()
    }
    
    // 创造可操作数据
    func showMySelect(){
        // self.Model.defaultModel.shopCart = self.staticGoodModels
        canSelectShop.removeAll()
        //获得所有店名
        for i in 0 ..< Model.defaultModel.shopCart.count {
            guard Model.defaultModel.shopCart[i].shopNameList != nil else {
                continue
            }
            for j in 0 ..< Model.defaultModel.shopCart[i].shopNameList.count {
                if !canSelectShop.contains(Model.defaultModel.shopCart[i].shopNameList[j].shopName!) {
                    canSelectShop.append(Model.defaultModel.shopCart[i].shopNameList[j].shopName!)
                }
            }
        }
        if(self.canSelectShop.isEmpty == false) {
            if(shopName == "无" || !canSelectShop.contains(shopName)) {
              shopName = canSelectShop[0]
            }
            
        }
        
        canChange(shopName)
        reCalculateGoodCount()
        tableView.reloadData()
    }
    
    func shopNoByName(name: String) -> String{
        
        if(name == "无"){
            return "-1"
        }

        for x in Model.defaultModel.shopLists {
            if(x.shopName == name){
                return x.shopNo!
            }
        }
        return "-1"
    }
    
    
    // 根据店铺名判断商品是否可送
    func canChange(selectShopName: String){
        for i in 0  ..< Model.defaultModel.shopCart.count  {
            guard Model.defaultModel.shopCart[i].shopNameList != nil else {
                Model.defaultModel.shopCart[i].canChange == false
                Model.defaultModel.shopCart[i].selected = false
                continue
            }
            for j in 0  ..< Model.defaultModel.shopCart[i].shopNameList!.count  {
                if (Model.defaultModel.shopCart[i].shopNameList[j].shopName == selectShopName ){
                    Model.defaultModel.shopCart[i].canChange = true
                    break;
                }
                else {
                    Model.defaultModel.shopCart[i].canChange = false
                }
            }
            if(Model.defaultModel.shopCart[i].canChange == false) {
                Model.defaultModel.shopCart[i].selected = false
            }
            else {
                Model.defaultModel.shopCart[i].selected = true
            }
        }
    }
    func selectAlert(){
        let select = UIActionSheet(title: "选择店铺", delegate: self, cancelButtonTitle: "返回", destructiveButtonTitle: nil)
        
        for i in 0 ..< canSelectShop.count {
            select.addButtonWithTitle(canSelectShop[i])
        }
        select.showInView(self.view)
        
    }
    
    func enterLoginView(){
        let vc =  LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func enterResignView(){
        let vc = ResignViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - JFShoppingCartCellDelegate代理方法
extension JFShoppingCartViewController: JFShoppingCartCellDelegate {
    
    /**
     当点击了cell中加、减按钮
     
     - parameter cell:       被点击的cell
     - parameter button:     被点击的按钮
     - parameter countLabel: 显示数量的label
     */
    func shoppingCartCell(cell: JFShoppingCartCell, button: UIButton, countLabel: UILabel) {
        
        
        // 根据cell获取当前模型
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        
        // 获取当前模型，添加到购物车模型数组
        let model = Model.defaultModel.shopCart[indexPath.row - 1]
        
        if model.canChange == true {
            
            if button.tag == 10 {
                
                if model.num <= 1 {
                    print("数量不能低于1")
                    return
                }
                
                // 减
                Model.defaultModel.updataItemNum(indexPath.row - 1 , shopNo: shopNoByName(shopName), dis: -1, success: { () -> Void in
                    countLabel.text = "\(model.num)"
                    // 重新计算商品数量
                    self.reCalculateGoodCount()
                    }, callback: { () -> Void in
                        self.stopRefreshView()
                })
                
            } else {
                
                // 加
                Model.defaultModel.updataItemNum(indexPath.row - 1 , shopNo: shopNoByName(shopName), dis: 1, success: { () -> Void in
                    countLabel.text = "\(model.num)"
                    // 重新计算商品数量
                    self.reCalculateGoodCount()
                    }, callback: { () -> Void in
                        self.stopRefreshView()
                })
            }
            
        }
        
    }
    
    /**
     重新计算总价
     */
    func reCalculateTotalPrice() {
        reCalculateGoodCount()
    }
}








