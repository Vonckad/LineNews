//
//  AppTextButton.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit
import SnapKit

protocol AppTextButtonDelegate {
    func didTouchUpInside(appTextButton: AppTextButton)
}

class AppTextButton: UIView {
    
    var delegate: AppTextButtonDelegate?
    private var title: String
    
    private lazy var textLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 13.0)
        return textLabel
    }()
    
    private lazy var button: UIButton = {
        var button = UIButton()
        button.setTitleColor(Theme.defaulButtonBackgroundColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    // life cycle
    init(withText: String, title: String) {
        self.title = title
        super.init(frame: .zero)
        textLabel.text = withText
        button.setTitle(title, for: .normal)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public
    func setTextAndTitle(text: String, title: String) {
        self.title = title
        textLabel.text = text
        button.setTitle(title, for: .normal)
    }
    
    func getTitle() -> String {
        return title
    }
    
    //private
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [textLabel, button])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 6.0
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    @objc
    private func buttonAction() {
        delegate?.didTouchUpInside(appTextButton: self)
    }
}
