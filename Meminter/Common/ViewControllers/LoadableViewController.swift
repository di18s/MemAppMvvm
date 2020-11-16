//
//  LoadableViewController.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import UIKit

class LoadableViewController: UIViewController, LoadableViewInput {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    func setLoading(_ loading: Bool) {
        loading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    }
}
