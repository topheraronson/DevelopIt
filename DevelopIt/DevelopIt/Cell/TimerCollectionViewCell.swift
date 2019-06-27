//
//  TimerCollectionViewCell.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

enum AnimationState {
    case startAnimatin
    case stopAnimation
    case pauseAnimation
    case resumeAnimation
}

class TimerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var timerTitleLabel: UILabel!
    @IBOutlet var animationContainerView: UIView!
    
    private let shapeLayer = CAShapeLayer()
    
    override var isSelected: Bool {
        didSet {
            updateViews()
        }
    }
    
    func createCircle() {
        
        let trackShape = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: 25, y: 37), radius: 30, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 2, clockwise: true)
        
        trackShape.path = path.cgPath
        
        trackShape.strokeColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 5
        
        animationContainerView.layer.addSublayer(trackShape)
        
        shapeLayer.path = path.cgPath
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        
        animationContainerView.layer.addSublayer(shapeLayer)
    }
    
    func setAnimationState(duration: Double?, animationState: AnimationState) {
        
        switch animationState {
        case .startAnimatin:
            startAnimation(duration: duration)
        case .pauseAnimation:
            pauseAnimation()
        case .resumeAnimation:
            resumeAnimation()
        case .stopAnimation:
            stopAnimation()
        }
    }
    
    private func startAnimation(duration: Double?) {
        
        guard let duration = duration else { return }
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        
        shapeLayer.strokeEnd = 1
        animation.duration = duration
        animation.speed = 0.79
        shapeLayer.add(animation, forKey: animation.keyPath)
    }
    
    func removeCircle() {
        shapeLayer.removeFromSuperlayer()
    }
    
    private func pauseAnimation() {
        
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0
        layer.timeOffset = pausedTime
    }
    
    private func resumeAnimation() {
        let pausedTime = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0
        layer.beginTime = 0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    private func stopAnimation() {
        
    }
    
    private func updateViews() {
        
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
