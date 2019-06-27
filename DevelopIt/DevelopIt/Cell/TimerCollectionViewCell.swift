//
//  TimerCollectionViewCell.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class TimerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var timerTitleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            updateViews()
        }
    }
    
    func createCircle() {
        
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: self.center, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        shapeLayer.path = path.cgPath
        
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func updateViews() {
        
        if isSelected {
            timerTitleLabel.textColor = .black
        } else {
            timerTitleLabel.textColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        }
    }
    
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.15
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
    }
    
    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
    }
    
}
