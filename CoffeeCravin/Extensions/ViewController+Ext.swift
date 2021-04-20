//
//  ViewController+Ext.swift
//  CoffeeCravin
//
//  Created by George Cremer on 20/04/2021.
//
import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String, menuDelegate: MenuDelegate?) {
        DispatchQueue.main.async {
            let alertVC = CCAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.menuDelegate = menuDelegate
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
