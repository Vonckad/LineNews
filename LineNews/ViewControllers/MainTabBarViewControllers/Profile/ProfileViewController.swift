//
//  ProfileViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "avatar"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50.0
        return imageView
    }()
    
    private var nameTextField: AppTextField = {
        var textField = AppTextField(withPlaceholder: "Имя")
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private var mailTextField: AppTextField = {
        var textField = AppTextField(withPlaceholder: "Почта")
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(UIColor(hexString: "#FF3B30"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.addTarget(nil, action: #selector(logoutAction), for: .touchUpInside)
        return button
    }()
    
    private var dismissHandler: () -> ()
    
    //Life cycle
    init(profile: String, dismissHandler: @escaping () -> ()) {
        self.dismissHandler = dismissHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Theme.defaultBackgroundColor
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = Theme.defaultButtonBackgroundColor
    }
    
    //private
    private func setupViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameTextField)
        view.addSubview(mailTextField)
        view.addSubview(logoutButton)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(21.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(100.0)
            make.width.equalTo(100.0)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(30.0)
            make.left.equalTo(25.0)
            make.right.equalTo(-25.0)
        }
        
        mailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16.0)
            make.left.equalTo(25.0)
            make.right.equalTo(-25.0)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(mailTextField.snp.bottom).offset(100.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30.0)
        }
    }
    
    @objc
    private func logoutAction() {
        UIAlertController.showAlertView(viewController: self, style: .logout) { [weak self] _ in
            guard let self = self else { return }
            self.dismissHandler()
        }
    }
}
