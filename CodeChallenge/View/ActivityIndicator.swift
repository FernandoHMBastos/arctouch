//
//  ActivityIndicator.swift
//  CodeChallenge
//
//  Created by Fernando H M Bastos on 19/09/19.
//  Copyright © 2019 Fernando H M Bastos. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator{

    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func showActivityIndicator(uiView: UIView) {
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 175, height: 125)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10


        let labelLoading: UILabel =  UILabel()
        labelLoading.text = "Loading..."
        labelLoading.textColor = UIColor.white
        labelLoading.font = UIFont.boldSystemFont(ofSize: 22.0)
        labelLoading.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 40.0);
        labelLoading.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 1.35);
        loadingView.addSubview(labelLoading)

        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge

        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 3);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }

    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
