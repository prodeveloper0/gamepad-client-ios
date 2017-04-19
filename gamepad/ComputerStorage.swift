//
//  ComputerStorage.swift
//  gamepad
//
//  Created by pr0ximo on 2016. 12. 9..
//  Copyright © 2016년 pr0ximo. All rights reserved.
//

import Foundation

class ComputerStorage {
    struct Computer {
        var alias: String
        var address: String
        var port: UInt16
    }
    
    var _ComputerList: Array<Computer> = Array<Computer>()
    
    init() {
        do {
            let json_raw = try String(contentsOfFile: document_path() + "/computers.json").data(using: .utf8)!
            let json = try JSONSerialization.jsonObject(with: json_raw, options: .mutableContainers) as? Array<NSDictionary>
            
            for item in json! {
                _ComputerList.append(Computer(alias: (item["alias"] as? String)!, address: (item["address"] as? String)!, port: (item["port"] as? UInt16)!))
            }
            
        } catch {
            NSLog("Cannot open computers.json")
        }
    }
    
    private func save() {
        var array_dictionary: Array<NSDictionary> = Array<NSDictionary>()
        
        for computer in _ComputerList {
            array_dictionary.append(["alias": computer.alias, "address": computer.address, "port": computer.port])
        }
        
        do {
            let json_raw = try JSONSerialization.data(withJSONObject: array_dictionary, options: .prettyPrinted)
            let json_string = String(data: json_raw, encoding: .utf8)
            try json_string?.write(toFile: document_path() + "/computers.json", atomically: false, encoding: .utf8)
        } catch {
            NSLog("Cannot save to computers.json")
        }
    }
    
    func add(computer: Computer) {
        _ComputerList.append(computer)
        save()
    }
    
    func edit(index: Int, computer: Computer) {
        _ComputerList[index] = computer
        save()
    }
    
    func delete(index: Int) {
        _ComputerList.remove(at: index)
        save()
    }
    
    func at(index: Int) -> Computer {
        return _ComputerList[index]
    }
    
    func count() -> Int {
        return _ComputerList.count
    }
}

