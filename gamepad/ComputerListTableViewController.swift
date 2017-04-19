//
//  ComputerListTableViewController.swift
//  gamepad
//
//  Created by pr0ximo on 2016. 12. 9..
//  Copyright © 2016년 pr0ximo. All rights reserved.
//

import UIKit

class ComputerListTableViewController: UITableViewController {
    func onInfo() {
        let message = "Made by Samuel Lee (@pr0ximo)\nhttp://pr0xsw.org\n\nKunsan National University\nComputer & Information Engineering"
        let alert = UIAlertController(title: "GamePad", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(onInfo), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    // 뷰컨트롤러의 뷰가 보이기 시작할때
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 뷰가 보일때 마다, 테이블뷰 새로고침
        tableView.reloadData()
    }
    
    // 테이블뷰에 보일 컴퓨터 갯수 알림
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate)._ComputerListMan.count()
    }
    
    // 테이블뷰에 보일 항목 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComputerListCellIdentifier", for: indexPath)
        
        cell.textLabel?.text = ((UIApplication.shared.delegate as? AppDelegate)?._ComputerListMan.at(index: indexPath.row).alias)!
        cell.detailTextLabel?.text = ((UIApplication.shared.delegate as? AppDelegate)?._ComputerListMan.at(index: indexPath.row).address)!
        
        return cell
    }
    
    // 테이블뷰 아이템이 삭제/편집될때 동작 설정
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as? AppDelegate)?._ComputerListMan.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // 다른 뷰컨트롤러로 이동 할때, 이동될 뷰컨트롤러뷰에 준비 작업
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let appdelegate = (UIApplication.shared.delegate as? AppDelegate)
        
        if segue.identifier == "EditComputerSegue" {
            let selectedCell = (sender as? UITableViewCell)
            let selectedIndexPath = tableView.indexPath(for: selectedCell!)!
            let computer: ComputerStorage.Computer = (appdelegate?._ComputerListMan.at(index: selectedIndexPath.row))!
        
            (segue.destination as! ComputerInformationViewController)._Index = selectedIndexPath.row
            (segue.destination as! ComputerInformationViewController)._Alias = computer.alias
            (segue.destination as! ComputerInformationViewController)._Address = computer.address
            (segue.destination as! ComputerInformationViewController)._Port = computer.port
        } else if segue.identifier == "SelectComputerSegue" {
            let computer: ComputerStorage.Computer = (appdelegate?._ComputerListMan.at(index: (tableView.indexPathForSelectedRow?.row)!))!
            
            (segue.destination as! GamePadViewController)._Computer = computer
        }
    }
}
