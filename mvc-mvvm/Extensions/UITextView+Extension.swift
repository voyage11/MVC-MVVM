//
//  UITextView+Extension.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit


extension UITextView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
    
}


