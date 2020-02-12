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
        backgroundColor = GemView.colors[Int.random(in: 0..<GemView.colors.count)]
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        addGestureRecognizer(tap)
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
    
}

struct GemLoc {
    var x = -1, y = -1
    
    init(){}
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
}
