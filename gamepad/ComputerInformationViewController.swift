//
//  ComputerInformationViewController.swift
//  gamepad
//
//  Created by pr0ximo on 2016. 12. 9..
//  Copyright © 2016년 pr0ximo. All rights reserved.
//

import UIKit

class ComputerInformationViewController: UIViewController {
    @IBOutlet weak var txtAlias: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPort: UITextField!
    
    var _Index: Int = -1
    var _Alias: String = ""
    var _Address: String = ""
    var _Port: UInt16 = 3300
    
    // 뷰컨트롤러의 뷰가 보이기 시작할때
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 보여줄 정보를 각 텍스트필드에 설정
        txtAlias.text = _Alias
        txtAddress.text = _Address
        txtPort.text = String(_Port)
        
        // 가장 첫번째 텍스트필드(txtAlias)에 포커스를 주고, 키보드를 보임
        txtAlias.becomeFirstResponder()
    }
    
    // 완료 버튼이 눌렸을때
    @IBAction func pressDone(_ sender: Any) {
        // Index == -1 이라면, 추가 모드
        // 만약 Index != -1 이라면, Index에 대해 데이터를 수정
        let alert = UIAlertController(title: "Invalid input", message: "Can't save current profile", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        if txtAlias.text! == "" || txtAddress.text == "" || txtPort.text == "" {
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let computer = ComputerStorage.Computer(alias: txtAlias.text!, address: txtAddress.text!, port: UInt16(txtPort.text!)!)
        if _Index == -1 {
            (UIApplication.shared.delegate as? AppDelegate)?._ComputerListMan.add(computer: computer)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?._ComputerListMan.edit(index: _Index, computer: computer)
        }
        
        self.navigationController!.popViewController(animated: true)
    }
}
