//
//  UIView+Extension.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 06.11.2020.
//

import UIKit

extension UIView {
    func springButtonAnimation(animatedElement: UIButton, duration: Double) {
        animatedElement.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.10),
                       initialSpringVelocity: CGFloat(3.0),
                       options: .allowUserInteraction,
                       animations: {
                        animatedElement.transform = CGAffineTransform.identity
        })
    }
    
    func springViewAnimation(animatedElement: UIView, duration: Double) {
        animatedElement.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        UIView.animate(withDuration: duration,
                       delay: 1.0,
                       usingSpringWithDamping: CGFloat(0.10),
                       initialSpringVelocity: CGFloat(2.0),
                       options: .allowUserInteraction,
                       animations: {
                        animatedElement.transform = CGAffineTransform.identity
        })
    }
}
