//
//  UIViewController.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import UIKit

extension UIViewController {
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func wowwowEasy(_ alertImage: UIImage, title: String, message: String, action handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 50, width: 270, height: 235))
        imageView.contentMode = .scaleAspectFit
        imageView.image = alertImage
        alert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
        let width = NSLayoutConstraint(item: alert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let handler = handler else { return }
            handler()
        })
        self.present(alert, animated: true, completion: nil)
    }
}
