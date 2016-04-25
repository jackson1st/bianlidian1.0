//
//  UpImageDownTextButton.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/1.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class UpImageDownTextButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRectMake(0, height - 15, width, (titleLabel?.height)!)
        titleLabel?.textAlignment = .Center
        
        imageView?.frame = CGRectMake(0, 0, width, height - 15)
        imageView?.contentMode = UIViewContentMode.Center
    }
    
}

class UpLabelDownTextButton: UIButton {
    
    let contextLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contextLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRectMake(0, height - 15, width, (titleLabel?.height)!)
        titleLabel?.textAlignment = .Center
        
        contextLabel.sizeToFit()
        contextLabel.frame = CGRectMake(0, 0, width , height - 15)
        contextLabel.textAlignment = .Center
    }
}

class ItemLeftButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let Offset: CGFloat = 15
        
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRectMake(-Offset, height - 15, width - Offset, (titleLabel?.height)!)
        titleLabel?.textAlignment = .Center
        
        imageView?.frame = CGRectMake(-Offset, 0, width - Offset, height - 15)
        imageView?.contentMode = UIViewContentMode.Center
    }
}

class ItemRightButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let Offset: CGFloat = 15
        
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRectMake(Offset, height - 15, width + Offset, (titleLabel?.height)!)
        titleLabel?.textAlignment = .Center
        
        imageView?.frame = CGRectMake(Offset, 0, width + Offset, height - 15)
        imageView?.contentMode = UIViewContentMode.Center
    }
}

class ItemLeftImageButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = bounds
        imageView?.frame.origin.x = -15
    }
    
}