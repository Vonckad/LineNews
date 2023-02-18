//
//  AppButton.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit

open class AppButton: UIButton {
    
    // life cycle
    init(withTitle: String) {
        super.init(frame: .zero)
        setTitle(withTitle, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = Theme.defaulButtonBackgroundColor
        layer.cornerRadius = 20.0
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
