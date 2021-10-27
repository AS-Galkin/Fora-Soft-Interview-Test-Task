//
//  ActivityView.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 27.10.2021.
//

import UIKit

class ActivityView: UIView {
    private var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicator.frame = frame
        addSubview(activityIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showActivity() {
        activityIndicator.startAnimating()
    }
    
    func hideActivity() {
        activityIndicator.stopAnimating()
    }
}
