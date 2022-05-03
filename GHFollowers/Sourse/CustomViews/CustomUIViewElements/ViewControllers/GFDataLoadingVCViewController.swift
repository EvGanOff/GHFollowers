//
//  GFDataLoadingVCViewController.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 5/4/22.
//

import UIKit


class GFDataLoadingVC: UIViewController {
    var containerView: UIView!

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0

        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func dissmisLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }

    func showEmptyStateView(with massege: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: massege)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)

    }
}
