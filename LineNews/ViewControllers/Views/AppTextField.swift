//
//  AppTextField.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit

open class AppTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 8.0, left: 20.0, bottom: 8.0, right: 8.0);
    
    // Paddging for place holder
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // Padding for text
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // Padding for text in editting mode
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // life cycle    
    init(withPlaceholder: String) {
        super.init(frame: .zero)
        placeholder = withPlaceholder
        backgroundColor = Theme.defaultTextFieldBackgroundColor
        layer.cornerRadius = 20.0
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
