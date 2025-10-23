//
//  SwipeToPopGestureRecognizer.swift
//  Geometria
//
//  Created by Pietro Calamusa on 28/04/25.
//

import UIKit

// enableSwipeToPop() da aggiungere nelle viewDidLoad delle viewController

extension UIViewController {
    func enableSwipeToPop() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRecognizer.direction = .right
        self.view.addGestureRecognizer(swipeRecognizer)
    }

    @objc private func handleSwipe() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else if let presentingViewController = self.presentingViewController {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
}
