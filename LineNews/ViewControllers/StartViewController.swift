//
//  StartViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit
import SwiftyGif
import SnapKit

class StartViewController: UIViewController {

    let logoAnimationView = LogoAnimationView()
    
    private var loginTextField: AppTextField = {
        var textField = AppTextField(withPlaceholder: "Почта")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private var passwordTextField: AppTextField = {
        var textField = AppTextField(withPlaceholder: "Пароль")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: AppButton = {
        var button = AppButton(withTitle: "Вход")
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var noAccountView: AppTextButton = {
        var noAccountView = AppTextButton(withText: "Нет аккаунта ?", title: "Зарегистрироваться")
        noAccountView.delegate = self
        return noAccountView
    }()
    
    private lazy var resetPasswordView: AppTextButton = {
        var resetPasswordView = AppTextButton(withText: "", title: "Сбросить пароль")
        resetPasswordView.delegate = self
        return resetPasswordView
    }()
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.startBackgroundColor
        startAnimation()
        
        title = "Вход"
        navigationController?.setNavigationBarHidden(true, animated: false)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
    
    //private
    private func startAnimation() {
        view.addSubview(logoAnimationView)
        logoAnimationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    private func setupViews() {
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(noAccountView)
        view.addSubview(resetPasswordView)
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(45.0)
            make.left.equalTo(38.0)
            make.right.equalTo(-38.0)
            make.height.equalTo(44.0)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(15.0)
            make.left.equalTo(loginTextField)
            make.right.equalTo(loginTextField)
            make.height.equalTo(44.0)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20.0)
            make.left.equalTo(87.0)
            make.right.equalTo(-87.0)
            make.height.equalTo(42.0)
        }
        
        noAccountView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20.0)
            make.centerX.equalTo(loginButton)
        }
        
        resetPasswordView.snp.makeConstraints { make in
            make.centerX.equalTo(loginButton)
            make.bottom.equalTo(-30.0)
        }
    }
    
    @objc
    private func loginButtonAction() {
        print("loginButtonAction")
    }
}

//MARK: - SwiftyGifDelegate
extension StartViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        setupViews()
    }
}

//MARK: - AppTextButtonDelegate
extension StartViewController: AppTextButtonDelegate {
    func didTouchUpInside(appTextButton: AppTextButton) {
        switch appTextButton {
        case noAccountView:
            print("noAccountView")
        case resetPasswordView:
            print("resetPasswordView")
        default:
            break
        }
    }
}
