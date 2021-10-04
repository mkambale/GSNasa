//
//  SwitchButton.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 04/10/21.
//

import UIKit
import CoreMotion

class SwitchButton: UIButton {

    var status: Bool = false {
        didSet {
            self.update()
        }
    }
    var onImage = UIImage(named: "on-image")
    var offImage = UIImage(named: "off-image")
    
    var onTitle = ""
    var offTitle = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStatus(false)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func update() {
        UIView.transition(with: self, duration: 0.10, options: .transitionCrossDissolve, animations: {
            self.status ? self.setImage(self.onImage, for: .normal) : self.setImage(self.offImage, for: .normal)
        }, completion: nil)
        
        if onTitle != offTitle {
            self.status ? self.setTitle(onTitle, for: .normal) : self.setTitle(offTitle, for: .normal)
        }
    }
    func toggle() {
        self.status ? self.setStatus(false) : self.setStatus(true)
    }
    
    func toggleToOff() {
        self.setStatus(false)
    }
    
    func toggleToOn() {
        self.setStatus(true)
    }
    
    func setStatus(_ status: Bool) {
        self.status = status
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.sendHapticFeedback()
        self.toggle()
    }
    
    func sendHapticFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
}
