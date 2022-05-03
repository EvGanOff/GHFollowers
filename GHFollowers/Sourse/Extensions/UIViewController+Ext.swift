//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 3/30/22.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentsGFAlertControllerOnMainTread(title: String, massage: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, massage: massage, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

    func presenSafariVC(from url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemPink
        present(safariVC, animated: true, completion: nil)
    }
}
