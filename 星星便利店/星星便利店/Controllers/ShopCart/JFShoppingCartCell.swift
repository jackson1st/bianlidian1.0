//
//  JFShoppingCartCell.swift
//  shoppingCart
//
//  Created by jianfeng on 15/11/18.
//

import UIKit

protocol JFShoppingCartCellDelegate: NSObjectProtocol {
    
    func shoppingCartCell(cell: JFShoppingCartCell, button: UIButton, countLabel: UILabel)
    
    func reCalculateTotalPrice()
}

class JFShoppingCartCell: UITableViewCell {
    
    // MARK: - 属性
    /// 商品模型
    var goodModel: JFGoodModel? {
        didSet {
            
            // 选中状态
            selectButton.selected = goodModel!.selected
            // 是否可选
            selectButton.enabled = goodModel!.canChange
            goodCountLabel.text = "\(goodModel!.num)"
            
            if let _ = goodModel?.url {
                iconView.sd_setImageWithURL(NSURL(string: (goodModel?.url)!), placeholderImage: UIImage(named: "quesheng"))
            }
            
            if let title = goodModel?.itemName {
                if title.judgeLineNumber(titleLabel,labelText: title) == true {
                    titleLabel.frame = CGRect(x: 110, y: 0, width: 180, height: 50)
                }
                titleLabel.text = title
            }
            
            if let newPrice = Double((goodModel?.itemSalePrice)!) {
                
                newPriceLabel.text = "¥\(newPrice.roundedToTwoDecimals())"
            }
            
            if goodModel?.itemDistPrice != nil {
                if let oldPrice = Double((goodModel?.itemDistPrice)!) {
                    oldPriceLabel.text = "¥\(oldPrice.roundedToTwoDecimals())"
                }
            }
            lackLabel.textColor = UIColor.grayColor()
            lackLabel.font = UIFont.boldSystemFontOfSize(18)
            lackLabel.text = "缺货"
            lackLabel.hidden = goodModel!.canChange
            newPriceLabel.hidden = !goodModel!.canChange
            oldPriceLabel.hidden = !goodModel!.canChange
            // 重新布局，会更新frame
//            layoutIfNeeded()
            
        }
    }
    
    /// 代理属性
    weak var delegate: JFShoppingCartCellDelegate?
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 准备UI
        prepareUI()
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加子控件
        contentView.addSubview(selectButton)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newPriceLabel)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(addAndsubtraction)
        contentView.addSubview(lackLabel)
        addAndsubtraction.addSubview(subtractionButton)
        addAndsubtraction.addSubview(goodCountLabel)
        addAndsubtraction.addSubview(addButton)
        
        // 约束子控件
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
//        titleLabel.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(contentView.snp_top).offset(10)
//            make.left.equalTo(iconView.snp_right).offset(12)
//            
//        }

        newPriceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(30)
            make.right.equalTo(-12)
        }
        

        oldPriceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(newPriceLabel.snp_bottom).offset(5)
            make.right.equalTo(-12)
        }
        
    }
    
    // MARK: - 响应事件
    /**
    被点击的按钮，tag10 减   tag11 加
    
    - parameter button: 按钮
    */
    @objc private func didTappedCalculateButton(button: UIButton) {
        delegate?.shoppingCartCell(self, button: button, countLabel: goodCountLabel)
    }
    
    /**
     选中了按钮后触发
     
     - parameter button: 被选中的按钮
     */
    @objc private func didSelectedButton(button: UIButton) {
        
        // 选中
        button.selected = !button.selected
        goodModel?.selected = button.selected
        // 重新计算价格
        delegate?.reCalculateTotalPrice()
    }
    
    // MARK: - 懒加载
    /// 选择按钮
    private lazy var selectButton: UIButton = {
        let selectButton = UIButton(type: UIButtonType.Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: UIControlState.Normal)
        selectButton.setImage(UIImage(named: "check_y"), forState: UIControlState.Selected)
        selectButton.setImage(UIImage(named: "none"), forState: UIControlState.Disabled)
        selectButton.addTarget(self, action: "didSelectedButton:", forControlEvents: UIControlEvents.TouchUpInside)
        selectButton.sizeToFit()
        return selectButton
    }()
    
    /// 商品图片
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.frame = CGRectMake(42, 10, 60, 60);
        return iconView
    }()
    
    /// 商品标题
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.frame = CGRect(x: 110, y: 0, width: 180, height: 35)
        return titleLabel
    }()
    
    /// 新价格标签
    private lazy var newPriceLabel: UILabel = {
        let newPriceLabel = UILabel()
        newPriceLabel.textColor = UIColor.redColor()
        return newPriceLabel
    }()
    
    // 老价格标签
    private lazy var oldPriceLabel: JFOldPriceLabel = {
        let oldPriceLabel = JFOldPriceLabel()
        oldPriceLabel.textColor = UIColor.grayColor()
        return oldPriceLabel
    }()
    
    // 缺货标签
    private lazy var lackLabel: UILabel = {
        let lackLabel = UILabel(frame: CGRect(x: 250, y: 30, width: 60, height: 30))
        lackLabel.textColor = UIColor.blackColor()
        return lackLabel
    }()
    // 加减操作的view
    private lazy var addAndsubtraction: UIView = {
        let addAndsubtraction = UIView()
        addAndsubtraction.frame = CGRect(x: 110, y: 45, width: 80, height: 25)
        addAndsubtraction.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return addAndsubtraction
    }()
    
    // 减号按钮
    private lazy var subtractionButton: UIButton = {
        let subtractionButton = UIButton(type: UIButtonType.Custom)
        subtractionButton.tag = 10;
        subtractionButton.setBackgroundImage(UIImage(named: "subtraction_icon"), forState: UIControlState.Normal)
        subtractionButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        subtractionButton.addTarget(self, action: "didTappedCalculateButton:", forControlEvents: UIControlEvents.TouchUpInside)
        return subtractionButton
    }()
    
    // 显示数量lbael
    private lazy var goodCountLabel: UILabel = {
        let goodCountLabel = UILabel()
        goodCountLabel.textAlignment = NSTextAlignment.Center
        goodCountLabel.frame = CGRect(x: 25, y: 0, width: 30, height: 25)
        return goodCountLabel
    }()
    
    // 加号按钮
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: UIButtonType.Custom)
        addButton.tag = 11
        addButton.setBackgroundImage(UIImage(named: "add_icon"), forState: UIControlState.Normal)
        addButton.frame = CGRect(x: 55, y: 0, width: 25, height: 25)
        addButton.addTarget(self, action: "didTappedCalculateButton:", forControlEvents: UIControlEvents.TouchUpInside)
        return addButton
    }()
    
}
