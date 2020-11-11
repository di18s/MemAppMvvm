//
//  LoadableViewInput.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import UIKit

protocol LoadableViewInput: LoadableInput {
    var activityIndicator: UIActivityIndicatorView! { get }
}

extension LoadableViewInput {
    func setLoading(_ loading: Bool) {
        self.activityIndicator.superview?.bringSubviewToFront(self.activityIndicator)
        loading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    }
}
