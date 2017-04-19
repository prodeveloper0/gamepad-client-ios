//
//  mymodule.swift
//  gamepad
//
//  Created by pr0ximo on 2016. 12. 9..
//  Copyright © 2016년 pr0ximo. All rights reserved.
//

import Foundation
import UIKit

/* Swift 3.0 UINavigationController 기기 방향 고정 */
extension UINavigationController {
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
}

extension GamePadViewController {
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }
}

func document_path() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
}
