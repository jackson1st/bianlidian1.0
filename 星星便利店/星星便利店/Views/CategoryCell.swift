

import UIKit

class CategoryCell: UITableViewCell {
    
    private static let identifier = "CategoryCell"
    
    // MARK: Lazy Property
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = HRHTextGreyColol
        nameLabel.highlightedTextColor = UIColor.blackColor()
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.font = UIFont.systemFontOfSize(14)
        return nameLabel
    }()
    
    private lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "llll")
        backImageView.highlightedImage = UIImage(named: "kkkkkkk")
        return backImageView
        }()
    
    private lazy var redView: UIView = {
        let redView = UIView()
        redView.backgroundColor = HRHNavigationBarRedBackgroundColor
        
        return redView
        }()
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithCustom(225, g: 225, b: 225)
        return lineView
        }()
// MARK: 模型setter方法
    var categorie: String? {
        didSet {
            nameLabel.text = categorie
        }
    }
    
// MARK: Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backImageView)
        addSubview(lineView)
        addSubview(redView)
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func cellWithTableView(tableView: UITableView) -> CategoryCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CategoryCell
        if cell == nil {
            cell = CategoryCell(style: .Default, reuseIdentifier: identifier)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameLabel.highlighted = selected
        backImageView.highlighted = selected
        redView.hidden = !selected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = bounds
        backImageView.frame = CGRectMake(0, 0, width, height)
        redView.frame = CGRectMake(0, height * 0.1, 5, height * 0.8)
        lineView.frame = CGRectMake(0, height - 1, width, 1)
    }

}
