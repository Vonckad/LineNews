//
//  AlertControllerExtension.swift
//  LineNews
//
//  Created by Vlad Ralovich on 20.02.2023.
//

import UIKit

extension UIAlertController {
    
    enum AlertStyle {
        case networkError
        case logout
        case emptyFields
        case incorrectUsernameOrPassword
        case incorrectnessMail
        case successfully
    }
    
    private struct AlertStringParams {
        var title: String
        var message: String
        var actionTitle: String
        var cancelTitle: String?
    }
    
    static func showAlertView(viewController: UIViewController,
                              style: AlertStyle,
                              defaultActionHandler: ((UIAlertAction?) -> Void)? = nil) {
        
        let stringParams = getStringParams(style)
        
        let allert = UIAlertController.init(title: stringParams.title, message: stringParams.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: stringParams.actionTitle,
                                   style: style == .logout ? .destructive : .default,
                                   handler: defaultActionHandler)
        allert.addAction(action)
        
        if let cancelTitle = stringParams.cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            allert.addAction(cancelAction)
        }
        viewController.present(allert, animated: true, completion: nil)
    }
    
    private static func getStringParams(_ style: AlertStyle) -> AlertStringParams {
        switch style {
        case .networkError:
            return AlertStringParams(title: "Сбой загрузки!",
                                     message: "Проверьте подключение к интернету",
                                     actionTitle: "Обновить",
                                     cancelTitle: "Отмена")
        case .logout:
            return AlertStringParams(title: "Выход",
                                     message: "Вы уверены, что хотите выйти из аккаунта",
                                     actionTitle: "Выход",
                                     cancelTitle: "Отмена")
        case .emptyFields:
            return AlertStringParams(title: "Ошибка",
                                     message: "Заполните пустые поля",
                                     actionTitle: "Ок")
        case .incorrectUsernameOrPassword:
            return AlertStringParams(title: "Ошибка",
                                     message: "Указан неправильный логин\nили пароль",
                                     actionTitle: "Ок")
        case .incorrectnessMail:
            return AlertStringParams(title: "Ошибка",
                                     message: "Проверьте корректность ввода почты",
                                     actionTitle: "Ок")
        case .successfully:
            return AlertStringParams(title: "Успешно",
                                     message: "Инструкция по сбросу пароля\nпридет Вам на почту",
                                     actionTitle: "Ок")
        }
    }
}
