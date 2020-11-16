//
//  SwipeViewCell.swift
//  SwipeView
//
//  Created by Дмитрий Х on 21.10.2020.
//

import UIKit

enum SwipeViewSwipeDirection {
    case right, left
}

class SwipeViewCell: UIView {
    var onSwipeAction: ((SwipeViewSwipeDirection, Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.draggingV(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panRecognizer)
    }
    
    @objc private func draggingV(_ recognizer: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: superview)
            self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: superview)
        case .ended:
            if self.center.x >= (superview.bounds.width * 0.65) {
                self.onSwipeAction?(.right, self.tag)
                UIView.animate(withDuration: 0.2) {
                    self.center.x = superview.frame.maxX + self.bounds.width
                    self.layoutIfNeeded()
                } completion: { _ in
                    self.removeFromSuperview()
                }
            } else if self.center.x <= (superview.bounds.width * 0.35) {
                self.onSwipeAction?(.left, self.tag)
                UIView.animate(withDuration: 0.1) {
                    self.center.x = superview.frame.origin.x - self.bounds.width
                    self.layoutIfNeeded()
                } completion: { _ in
                    self.removeFromSuperview()
                }
            } else {
                self.frame = superview.bounds
            }
        default:
            break
        }
    }
    
    deinit {
//        print(self.tag, " deinit")
    }
}
