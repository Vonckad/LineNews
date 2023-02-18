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

    enum StyleStartViewController {
        case login, register, resetPassword
    }
    
    private var style: StyleStartViewController
    
    private var logoAnimationView: LogoAnimationView?
    
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
    
    private lazy var noAccountOrRegisterView: AppTextButton = {
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
    init(style: StyleStartViewController) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.startBackgroundColor
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.backButtonTitle = ""
        switch style {
        case .login:
            logoAnimationView = LogoAnimationView()
            startAnimation()
            title = "Вход"
            noAccountOrRegisterView.setTextAndTitle(text: "Нет аккаунта ?", title: "Зарегистрироваться")
            resetPasswordView.isHidden = false
        case .register:
            title = "Регистрация"
            noAccountOrRegisterView.setTextAndTitle(text: "У Вас есть аккаунт ?", title: "Войти")
            resetPasswordView.isHidden = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.layoutMargins.left = 30.0
            setupViews()
        case .resetPassword:
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            title = "Сброс пароля"
            
            setupViews()
            resetPasswordView.isHidden = true
            passwordTextField.isHidden = true
            noAccountOrRegisterView.isHidden = true
            
            loginButton.setTitle("Сбросить пароль", for: .normal)
            loginButton.snp.remakeConstraints { make in
                make.top.equalTo(loginTextField.snp.bottom).offset(20.0)
                make.left.equalTo(87.0)
                make.right.equalTo(-87.0)
                make.height.equalTo(42.0)
            }
            
            let descriptionLabel = UILabel()
            view.addSubview(descriptionLabel)
            descriptionLabel.numberOfLines = 2
            descriptionLabel.font = UIFont.systemFont(ofSize: 13.0)
            descriptionLabel.text = "Инструкция по сбросу пароля\nпридет Вам на почту"
            descriptionLabel.textAlignment = .center
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(loginButton.snp.bottom).offset(20.0)
                make.centerX.equalTo(loginButton)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let logoAnimationView = logoAnimationView {
            logoAnimationView.logoGifImageView.startAnimatingGif()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = style == .login ? .always : .never
        navigationController?.navigationBar.prefersLargeTitles = style == .login ? true : false
    }
    
    //private
    private func startAnimation() {
        if let logoAnimationView = logoAnimationView {
            view.addSubview(logoAnimationView)
            logoAnimationView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            logoAnimationView.logoGifImageView.delegate = self
        }
    }
    
    private func setupViews() {
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(noAccountOrRegisterView)
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
        
        noAccountOrRegisterView.snp.makeConstraints { make in
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
        //test@mail.ru, 123456
        if loginTextField.text == nil && passwordTextField.text == nil {
            
        } else if loginTextField.text == "test@mail.ru" && passwordTextField.text == "123456" {
            
        } else {
            
        }
    }
}

//MARK: - SwiftyGifDelegate
extension StartViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        if let logoAnimationView = logoAnimationView {
            logoAnimationView.isHidden = true
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins.left = 30.0
        setupViews()
    }
}

//MARK: - AppTextButtonDelegate
extension StartViewController: AppTextButtonDelegate {
    func didTouchUpInside(appTextButton: AppTextButton) {
        switch appTextButton {
        case noAccountOrRegisterView:
            print("noAccountView")
            if noAccountOrRegisterView.getTitle() == "Зарегистрироваться" {
                print(".register")
                let registerVC = UINavigationController(rootViewController: StartViewController(style: .register))
                registerVC.modalPresentationStyle = .fullScreen
                present(registerVC, animated: true)
            } else if noAccountOrRegisterView.getTitle() == "Войти" {
                print(".login")
                dismiss(animated: true)
            }
        case resetPasswordView:
            print("resetPasswordView")
            navigationController?.pushViewController(StartViewController(style: .resetPassword),
                                                     animated: true)
        default:
            break
        }
    }
}
