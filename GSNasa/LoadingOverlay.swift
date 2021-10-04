//
//  LoadingOverlay.swift
//  CTCAConnect
//
//  Created by Tomack, Barry on 12/7/16.
//  Copyright © 2016 CTCA. All rights reserved.
//

import UIKit

/**
 This class provides a view with an activity indicator and a message label to communicate
 what activity is currently being performed to the user.
 */

extension UIView {
    func quickFadeIn(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func quickFadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
public class LoadingOverlay{
    
    var overlayView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var messageLabel: UILabel = UILabel()
    
    var isLoading: Bool = false
    
    static let shared: LoadingOverlay = LoadingOverlay()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() { }
    
    public func showOverlay(view: UIView, message: String? = nil) {
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        let size = (width > height) ? width : height

        self.overlayView.frame = CGRect(x:view.frame.origin.x, y: view.frame.origin.y, width: size, height: size);
        self.overlayView.center = view.center
        self.overlayView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.overlayView.clipsToBounds = true
        self.overlayView.alpha = 1.0
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
        self.activityIndicator.style = UIActivityIndicatorView.Style.large
        self.activityIndicator.color = UIColor.gs_theme
        self.activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        
        if (message != nil) {
            self.messageLabel.frame = CGRect(x: 0, y:0, width: overlayView.bounds.width, height: 30)
            self.messageLabel.text = message
            
            self.messageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            self.messageLabel.numberOfLines = 1
            self.messageLabel.textAlignment = .center
            self.messageLabel.textColor = UIColor.gs_theme
            
            self.messageLabel.center = CGPoint(x: overlayView.bounds.width / 2,
                                               y: overlayView.bounds.height / 2 + 40.0)
            
            overlayView.addSubview(messageLabel)
        }
        
        view.addSubview(overlayView)
        
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        self.overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.overlayView.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.overlayView.centerYAnchor).isActive = true
        
        if (message != nil) {
            self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
            self.messageLabel.centerXAnchor.constraint(equalTo: self.overlayView.centerXAnchor).isActive = true
            self.messageLabel.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: 20.0).isActive = true
        }
        
        self.activityIndicator.startAnimating()
        isLoading = true;
    }
    
    public func hideOverlay() {
        activityIndicator.stopAnimating()
        self.overlayView.removeFromSuperview()
        self.isLoading = false
    }
    
    public func fadeOutOverlay() {
        self.overlayView.quickFadeOut(completion: { (finished: Bool) -> Void in
            self.hideOverlay()
        })
    }
    
    public func update(message: String) {
        messageLabel.text = message
    }
}
