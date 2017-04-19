//
//  GamePadViewController.swift
//  gamepad
//
//  Created by pr0ximo on 2016. 12. 9..
//  Copyright © 2016년 pr0ximo. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

func == (left: [Int], right: [Int]) -> Bool {
    if left.count != right.count {
        return false
    }
    
    for (index, item) in left.enumerated() {
        if item != right[index] {
            return false
        }
    }
    
    return true
}


class GamePadViewController: UIViewController, GCDAsyncUdpSocketDelegate, JoystickPadDelegate {
    
    var _Computer: ComputerStorage.Computer? = nil
    var _Socket: GCDAsyncUdpSocket? = nil
    var _Bitset: [Int] = [Int](repeating: 0, count: 15)
    
    // 소멸자
    deinit {
        // 소켓이 nil이 아닐경우만 소켓을 닫는다.
        guard _Socket != nil else {
            _Socket?.close()
            return
        }
    }
    
    // 뷰컨트롤러의 뷰가 보이기 시작할때
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 장치를 오른쪽 기준으로 눕힌다.
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
        // 소켓 생성
        _Socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
    }
    
    func joystickPadMove(_ ox: Float, _ oy: Float, _ angle: Float) {
        if sqrt(pow(ox, 2) + pow(oy, 2)) < 20 {
            return;
        }
        
        let temp = _Bitset
        _Bitset[5] = ((angle >= 22.5 && angle <= 157.5)) ? 1 : 0 // UP
        _Bitset[7] = ((angle >= 292.5 || angle <= 67.5)) ? 1 : 0 // RIGHT
        _Bitset[4] = ((angle >= 112.5 && angle <= 247.5)) ? 1 : 0 // LEFT
        _Bitset[6] = ((angle >= 202.5 && angle <= 337.5)) ? 1 : 0 // DOWN
        
        if temp == _Bitset {
            return
        }
            
        _Socket?.send(self.bitsetToString().data(using: .ascii)!, toHost: (_Computer?.address)!, port: (_Computer?.port)!, withTimeout: 0, tag: 0)
        
    }
    
    func joystickPadRelease() {
        _Bitset[5] = 0
        _Bitset[4] = 0
        _Bitset[7] = 0
        _Bitset[6] = 0
        _Socket?.send(self.bitsetToString().data(using: .ascii)!, toHost: (_Computer?.address)!, port: (_Computer?.port)!, withTimeout: 0, tag: 0)
    }
    
    private func bitsetToString() -> String {
        var ret: String = String()
        
        for bit in _Bitset {
            ret.append(String(bit))
        }
        
        ret.append("$")
        
        return ret
    }
    
    @IBAction func touchClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchDownPad(_ sender: UIButton?) {
        let tag: Int = (sender?.tag)!
        _Bitset[tag] = 1
        
        _Socket?.send(self.bitsetToString().data(using: .ascii)!, toHost: (_Computer?.address)!, port: (_Computer?.port)!, withTimeout: 0, tag: 0)
    }
    
    @IBAction func touchUpPad(_ sender: UIButton?) {
        let tag: Int = (sender?.tag)!
        _Bitset[tag] = 0
        
        _Socket?.send(self.bitsetToString().data(using: .ascii)!, toHost: (_Computer?.address)!, port: (_Computer?.port)!, withTimeout: 0, tag: 0)
    }
}
