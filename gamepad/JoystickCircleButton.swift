//
//  JoystickButton.swift
//  gamepad
//
//  Created by pr0ximo on 2016. 12. 20..
//  Copyright © 2016년 pr0ximo. All rights reserved.
//

import UIKit

class JoystickCircleButton: UIButton {
    private func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        self.titleLabel?.shadowColor = UIColor.black
        self.titleLabel?.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        setup()
    }
}
