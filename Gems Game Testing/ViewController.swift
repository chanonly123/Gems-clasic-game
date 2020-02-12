//
//  ViewController.swift
//  Gems Game Testing
//
//  Created by Chandan Karmakar on 12/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var board: BoardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        board.size = 6
        board.fillBoardRandomly()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @IBAction func tapReset() {
        board.fillBoardRandomly()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

}

