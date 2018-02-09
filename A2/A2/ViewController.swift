//
//  ViewController.swift
//  A2
//
//  Created by toxin_4500 on 2018-02-08.
//  Copyright © 2018 toxin_4500. All rights reserved.
//

import UIKit

var r: [Room] = []
var pos = Room()
var inv = Inventory()

class Inventory {
    
    var inv: [String] = []
    
    func addItem(i: String) {
        inv.append(i)
    }
    
    func hasItem(i: String) -> Bool {
        
        if (inv.contains(i)) {
            return true
        }
        return false
        
    }
    
    func removeItem(i: String) {
        
        if (inv.contains(i)) {
            let ind = inv.index(of: i)
            inv.remove(at: ind!)
        }
        
    }
    
}

class Decision {
    
    var decRequirement: String
    var decDestination: String
    var decDescription: String
    var auto: Bool//true means it's an item pickup, false means it regular navigation
    var failMessage = ""
    
    init(req: String, dest: String, desc: String, a: Bool) {
        
        self.decRequirement = req
        self.decDestination = dest
        self.decDescription = desc
        self.auto = a
        
    }
    
    init(req: String, dest: String, desc: String, a: Bool, fail: String) {
        
        self.decRequirement = req
        self.decDestination = dest
        self.decDescription = desc
        self.auto = a
        self.failMessage = fail
        
    }
    
    func getDecisionString() -> String {
        return self.decDescription + " " + decDestination + "\n"
    }
    
}

class Room {
    
    var roomID: String
    var roomDescription: String
    var conditions: [Decision] = []
    var roomItems: [String] = []
    var invString = ""
    var endRoom = false
    
    init() {
        self.roomID = ""
        self.roomDescription = ""
    }
    
    init(input: String) {
        
        //parse initial room data
        var token = input.components(separatedBy: " ")
        self.roomID = token[0]
        
        let quoteToken = input.components(separatedBy: "\"")
        self.roomDescription = quoteToken[1]
        
        var inputTmp = input.replacingOccurrences(of: self.roomID, with: "")
        inputTmp = inputTmp.replacingOccurrences(of: self.roomDescription, with: "")
        //shave off front content
        for _ in 0...2 {
            inputTmp.removeFirst()
        }
        
        
        //check if this is an end cell
        if (inputTmp.contains("-end")) {
            endRoom = true
            inputTmp = inputTmp.replacingOccurrences(of: "-end", with: "")
        }
        
        while (inputTmp != "") {
            
            if (inputTmp.starts(with: "-if")) {
                for _ in 0...3 {//remove -if
                    inputTmp.removeFirst()
                }
                let quoteToken = inputTmp.components(separatedBy: "\"")
                var cond = ""
                var out = ""
                var desc = ""
                var parseState = 0
                for q in quoteToken {
                    
                    if (q != "" && q != " ") {
                        if (parseState == 0) {
                            cond = q
                            for _ in 0..<cond.count+2 {//remove from buffer
                                inputTmp.removeFirst()
                            }
                            parseState = 1
                        } else if (parseState == 1) {
                            out = q
                            for _ in 0..<out.count+2 {//remove from buffer
                                inputTmp.removeFirst()
                            }
                            parseState = 2
                        } else if (parseState == 2) {
                            desc = q
                            print(cond + " " + out + " " + desc)
                            for _ in 0..<desc.count+2 {//remove from buffer
                                inputTmp.removeFirst()
                            }
                            break
                        }
                    } else if (q == " "){//remove it
                        inputTmp.removeFirst()
                    }
                    
                }
                
            } else if (inputTmp.starts(with: "-inventory")){
                for _ in 0...10 {//remove -inventory
                    inputTmp.removeFirst()
                }
                let itemToken = inputTmp.components(separatedBy: "\"")
                
                var parseState = 0
                for i in itemToken {
                    
                    if (i != "" && i != " ") {
                        if (parseState == 0) {
                            self.invString = i
                            for _ in 0..<self.invString.count+2 {//remove item message
                                inputTmp.removeFirst()
                            }
                            parseState = 1
                        } else if (parseState == 1) {
                            self.roomItems.append(i)
                            for _ in 0..<i.count+2 {//remove item message
                                inputTmp.removeFirst()
                            }
                            print("Added item " + i + " to room + " + self.roomID)
                            parseState = 2
                        } else if (parseState == 2) {
                            
                            if (i == ", ") {
                                for _ in 0...1 {
                                    inputTmp.removeFirst()
                                }
                                parseState = 1
                            } else {
                                parseState = 3
                            }
                            
                        } else {//no more items
                            break
                        }
                    } else if (i == " ") {//remove
                        inputTmp.removeFirst()
                    }
                    
                }
            } else {//read as regular directional input
                while (inputTmp != "") {
                    
                    var parseState = 0
                    //0 = ignore (index)
                    //1 = read description
                    //2 = destination
                    var cond = ""
                    var out = ""
                    var desc = ""
                    let quotes = inputTmp.components(separatedBy: "\"")
                    for q in quotes {
                        
                        if (q != "" && q != " ") {
                            if (parseState == 0) {
                                //ignore
                                for _ in 0..<2 {//remove from buffer
                                    inputTmp.removeFirst()
                                }
                                parseState = 1
                            } else if (parseState == 1) {
                                desc = q
                                for _ in 0..<desc.count+2 {//remove from buffer
                                    inputTmp.removeFirst()
                                }
                                parseState = 2
                            } else if (parseState == 2) {
                                if (q.contains("-if")) {
                                    print("test" + q)
                                    //parse as condition
                                    parseState = 3
                                } else {
                                    out = q
                                    for _ in 0..<out.count+1 {//remove from buffer
                                        inputTmp.removeFirst()
                                    }
                                    out = out.components(separatedBy: ">")[0] + ">"
                                    if (out.starts(with: " go ")) {
                                        for _ in 0...3 {
                                            out.removeFirst()
                                        }
                                    }
                                    if (cond == "") {
                                        self.conditions.append(Decision(req: cond, dest: out, desc: desc, a: false))
                                        print("BUILD PATH - (" + cond + ") " + out + " " + desc)
                                        parseState = 1
                                    } else {
                                        parseState = 4
                                    }
                                }
                            } else if (parseState == 3) {//parse as condition
                                cond = q
                                parseState = 2
                            } else if (parseState == 4) {
                                self.conditions.append(Decision(req: cond, dest: out, desc: desc, a: false, fail: q))
                                for _ in 0..<q.count+2 {
                                    inputTmp.removeFirst()
                                }
                                print("BUILD PATH - (" + cond + ") " + out + " " + desc + "| Fail = " + q)
                                cond = ""
                                parseState = 0
                            }
                        } else if (q == " ") {//remove
                            inputTmp.removeFirst()
                        }
                        
                    }
                    
                }
            }
            
        }
        print(self.roomID + " finished")
        
    }
    
    func roomInfoOutput() -> String {
        return self.roomDescription
    }
    
    func getDecisionsList(auto: Bool) -> String {
        
        var r = ""
        var count = 1
        
        for d in self.conditions {
            
            if (d.auto == auto) {
                if (auto == true) {
                    if (inv.hasItem(i: d.decRequirement)) {
                        r = r + d.getDecisionString()
                    }
                } else {
                    r = r + String(count) + ". " + d.getDecisionString()
                    count = count + 1
                }
            }
            
        }
        
        return r
        
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var DisplayLabel: UILabel!
    @IBOutlet weak var OptionBox: UILabel!
    @IBOutlet weak var InventoryBox: UILabel!
    @IBOutlet weak var Input: UITextField!
    
    func joinRoom(r: Room) {
        
        pos = r
        DisplayLabel.text! = DisplayLabel.text! + "\n" + r.roomInfoOutput() + "\n"
        for d in r.conditions {
            if (d.auto) {
                //automatic condition - call it
            }
        }
        OptionBox.text = pos.getDecisionsList(auto: false)
        Input.text = ""
        
    }
    
    func findRoom(id: String) -> Room {
        
        var i = id.replacingOccurrences(of: " ", with: "")
        for room in r {
            
            print("|" + i + "|" + " vs " + "|" + room.roomID + "|")
            if (id.contains(room.roomID)) {
                return room
            }
            
        }
        
        return Room() //empty room
        
    }
    
    @IBAction func PerformMove(_ sender: Any) {
        
        //all remaining game logic
        var user_input = Input.text!
        
        var foundRoom = false
        if (user_input != "") {
            
            for room in pos.conditions {
                print(room.decDestination)
                user_input = "<" + user_input + ">"
                if (room.decDestination.contains(user_input)) {
                    print("Switching to " + user_input)
                    let output = findRoom(id: room.decDestination)
                    if (output.roomID == "") {//error
                        print("ERROR FINDING ROOM " + room.decDestination)
                    } else {
                        joinRoom(r: output)
                    }
                    foundRoom = true
                    break
                }
            }
            
            if (!foundRoom) {
                print("Error finding room")
            }
            print("end function")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayLabel.numberOfLines = 0
        OptionBox.numberOfLines = 0
        InventoryBox.numberOfLines = 0
        
        if let file = Bundle.main.path(forResource: "input", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: file)
                let lines = contents.components(separatedBy: .newlines)
                var roomString = ""
                var i = 1
                for l in lines {
                    if (l.characters.starts(with: "<") && roomString.count > 0) {
                        r.append(Room(input: roomString))
                        roomString = l
                        i = i + 1
                    } else {
                        roomString = roomString + l
                    }
                }
                r.append(Room(input: roomString))
                
            } catch {
                print("Error reading contents")
            }
        } else {
            print("ERROR - File not found")
        }
        
        //start game
        pos = r[0]
        joinRoom(r: pos)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

