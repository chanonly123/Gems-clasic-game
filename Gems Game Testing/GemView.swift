//
//  GemView.swift
//  Gems Game Testing
//
//  Created by Chandan Karmakar on 12/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class GemView: UIView {
    static let colors: [UIColor] = [.red, .blue, .brown, .green, .black, .cyan]
    
    var loc = GemLoc()
    weak var board: BoardView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        isUserInteractionEnabled = false
        backgroundColor = GemView.colors[Int.random(in: 0..<GemView.colors.count)]
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        //addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    @objc func actionTap() {
        var a = loc
        a.y -= 1
        var b = loc
        b.y -= 2
        board?.clearArr(locs: [loc])
    }
 
    let pulse = CAShapeLayer()
    
    func addPulse() {
        pulse.fillColor = UIColor.blue.cgColor
        pulse.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.1
        scaleAnimation.toValue = 2.0
        scaleAnimation.duration = 0.5
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.5
        opacityAnimation.values = [alpha, alpha * 0.5, 0.0]
        opacityAnimation.fillMode = .forwards
        opacityAnimation.isRemovedOnCompletion = false
        //opacityAnimation.keyTimes = [0.0, NSNumber(value: keyTimeForHalfOpacity), 1.0]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 0.5
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        layer.addSublayer(pulse)
        pulse.frame = bounds
        pulse.add(animationGroup, forKey: "pulse")
    }
}

struct GemLoc {
    var x = -1, y = -1
    
    init(){}
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func isNeigbour(loc: GemLoc) -> Bool {
        return ((loc.x - 1 == x || loc.x + 1 == x) && loc.y == y) ||
             ((loc.y - 1 == y || loc.y + 1 == y) && loc.x == x)
    }
}
