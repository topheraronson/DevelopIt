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
    
    func updateViews() {
        
        if isSelected {
            timerTitleLabel.textColor = .black
        } else {
            timerTitleLabel.textColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        }
    }
    
}
