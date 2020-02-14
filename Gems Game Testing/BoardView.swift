//
//  BoardView.swift
//  Gems Game Testing
//
//  Created by Chandan Karmakar on 12/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    var size: Int = 0
    
    var gemViews = [[GemView]]()
    
    var cellSize: CGFloat = 0
    var cellMid: CGFloat = 0
    
    // animation times
    let removeTime = 0.3
    let shiftTime = 0.3
    let insertTime = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = TouchGesture(target: self, action: #selector(onTouch(_:)))
        addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellSize = bounds.width / CGFloat(size)
        cellMid = cellSize / 2
        updateViews()
    }
    
    func fillBoardRandomly() {
        subviews.forEach{ $0.removeFromSuperview() }
        gemViews.removeAll()
        for i in 0..<size {
            gemViews.append([GemView]())
            for j in 0..<size {
                let gem = GemView()
                gem.loc = GemLoc(i, j)
                gemViews[i].append(gem)
            }
        }
    }
    
    func updateViews() {
        if size < 1 { return }
        print(#function)
        for i in 0..<size {
            for j in 0..<size {
                let gem = gemViews[i][j]
                addGem(gem: gem, loc: GemLoc(i, j))
            }
        }
    }
    
    func clearArr(locs: [GemLoc]) {
        isUserInteractionEnabled = false
        var delay = 0.0
        for each in locs {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.clearLoc(each)
            }
            delay += 0.1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isUserInteractionEnabled = true
        }
    }
    
    private func clearLoc(_ loc: GemLoc) {
        // remove animate down
        let delGem = gemViews[loc.x][loc.y]
        UIView.animate(withDuration: removeTime, delay: 0.0, options: [.curveEaseIn], animations: {
            delGem.center.y += self.cellMid
            delGem.alpha = 0
        }, completion: { _ in
            delGem.removeFromSuperview()
        })
        
        // shift down
        var delay = 0.3
        var j = loc.y
        while j - 1 >= 0 {
            let upperGem = gemViews[loc.x][j - 1]
            let prevLoc = upperGem.loc
            print(GemLoc(prevLoc.x, j))
            UIView.animate(withDuration: shiftTime, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [], animations: {
                self.addGem(gem: upperGem, loc: GemLoc(prevLoc.x, j))
            }, completion: nil)
            j -= 1
            delay += 0.02
        }
        
        // insert from top
        let new = GemView()
        addGem(gem: new, loc: GemLoc(loc.x, 0))
        let center = new.center
        new.center.y = -self.bounds.height
        UIView.animate(withDuration: insertTime, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: [], animations: {
            new.center = center
        }, completion: nil)
    }
    
    func addGem(gem: GemView, loc: GemLoc) {
        if gem.superview == nil {
            addSubview(gem)
        }
        gemViews[loc.x][loc.y] = gem
        gem.loc = loc
        gem.board = self
        gem.frame.size = CGSize(width: cellSize / 2, height: cellSize / 2)
        gem.center = CGPoint(x: CGFloat(loc.x) * cellSize + cellMid, y: CGFloat(loc.y) * cellSize + cellMid)
    }
    
    var touchSelectedNodes: [GemView] = [] {
        didSet {
            lines.removeAll()
            setNeedsDisplay()
            if touchSelectedNodes.count < 2 { return }
            for i in 0..<touchSelectedNodes.count-1 {
                let path = UIBezierPath()
                path.lineWidth = 8
                path.move(to: touchSelectedNodes[i].center)
                path.addLine(to: touchSelectedNodes[i+1].center)
                lines.append(path)
            }
            setNeedsDisplay()
        }
    }
    
    var lines = [UIBezierPath]()
    
    var selectedColor = UIColor.white
    
    @objc func onTouch(_ ges: UIGestureRecognizer) {
        let point = ges.location(ofTouch: 0, in: self)
        let x = Int(point.x / cellSize)
        let y = Int(point.y / cellSize)
        if x < 0 || x >= size || y < 0 || y >= size {
            checkAndRemoveNodes()
            touchSelectedNodes.removeAll()
            return
        }
        let gemView = gemViews[x][y]
        switch ges.state {
        case .began:
            selectedColor = gemView.backgroundColor ?? .white
            touchSelectedNodes.removeAll()
            touchSelectedNodes.append(gemView)
            gemView.addPulse()
        case .changed:
            if !touchSelectedNodes.contains(gemView) && shouldSelect(gem: gemView) {
                touchSelectedNodes.append(gemView)
                gemView.addPulse()
            }
        default:
            checkAndRemoveNodes()
            touchSelectedNodes.removeAll()
        }
    }
    
    override func draw(_ rect: CGRect) {
        for each in lines {
            selectedColor.setStroke()
            each.stroke()
        }
    }
    
    func shouldSelect(gem: GemView) -> Bool {
        guard let last = touchSelectedNodes.last else { return true }
        return gem.backgroundColor == last.backgroundColor && gem.loc.isNeigbour(loc: last.loc)
    }
    
    func checkAndRemoveNodes() {
        if touchSelectedNodes.count > 1 {
            clearArr(locs: touchSelectedNodes.map({ $0.loc }))
        }
    }
}
