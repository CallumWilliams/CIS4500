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
var optionSize = 1

class Inventory {
    
    var inv: [String] = []
    
    func addItem(i: String) {
        inv.append(i)
    }
    
    func hasItem(i: String) -> Bool {
        
        if (self.inv.contains(i)) {
            return true
        }
        return false
        
    }
    
    func searchFor(item: String) -> Bool {
        
        for i in self.inv {
            if (i.contains(item)) {
                return true
            }
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
                            self.conditions.append(Decision(req: cond, dest: out, desc: desc, a: true))
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
                                        cond = ""
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
    
    func updateInventoryDisplay() {
        
        InventoryBox.text = ""
        for i in inv.inv {
            InventoryBox.text! = InventoryBox.text! + i + "\n"
        }
        
    }
    
    func searchForRoom(id: String) -> Int {
        
        var ind = 0
        for room in r {
            
            if (id == room.roomID) {
                return ind
            }
            ind = ind + 1
            
        }
        
        return -1
        
    }
    
    func resetGame() {
        
        inv.inv.removeAll()
        InventoryBox.text = ""
        pos = r[0]
        DisplayLabel.text = ""
        
        joinRoom(r: pos)
        
    }
    
    func joinRoom(r: Room) {
        
        pos = r
        
        if (pos.endRoom) {
            
            let alert = UIAlertController(title: "Congratulations!", message: "You have won! Would you like to play again?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Exit Program"), style: .default, handler: { (action: UIAlertAction!) in self.resetGame()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Exit Program"), style: .cancel, handler: { (action: UIAlertAction!) in exit(0)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        DisplayLabel.text! = DisplayLabel.text! + "\n" + r.roomInfoOutput() + "\n"
        for d in r.conditions {
            if (d.auto && inv.hasItem(i: d.decRequirement)) {
                DisplayLabel.text! = DisplayLabel.text! + d.getDecisionString() + "\n"
                inv.removeItem(i: d.decRequirement)
                inv.addItem(i: d.decDestination)
            }
        }
        if (r.roomItems.count > 0) {
            DisplayLabel.text! = DisplayLabel.text! + r.invString + "\n"
            for i in r.roomItems {
                InventoryBox.text! = InventoryBox.text! + i + "\n"
                inv.addItem(i: i)
            }
        }
        updateInventoryDisplay()
        OptionBox.text = pos.getDecisionsList(auto: false)
        
    }
    
    @IBAction func PerformMove(_ sender: Any) {
        
        //all game logic
        var user_input = Input.text!
        user_input = "<" + user_input + ">"
        var foundRoom = false
        
        for p in pos.conditions {
            
            if (!p.auto && p.decRequirement == "") {//ignore requirements
                
                if (p.decDestination.contains(user_input)) {
                    foundRoom = true
                    let i = searchForRoom(id: user_input)
                    joinRoom(r: r[i])
                    break
                }
                
            } else if (!p.auto && p.decRequirement != "" && p.decDestination.contains(user_input)) {//check if required item is in inventory
                print(p.decRequirement + " " + p.decDestination)
                if (inv.searchFor(item: p.decRequirement)) {
                    foundRoom = true
                    let i = searchForRoom(id: user_input)
                    joinRoom(r: r[i])
                    break
                } else {
                    DisplayLabel.text! = DisplayLabel.text! + p.failMessage + "\n"
                    foundRoom = true
                    break
                }
            }
            
        }
        
        if (!foundRoom) {
            let alert = UIAlertController(title: "Error", message: "Error finding room " + Input.text!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        Input.text = ""
        
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
                    if (l.starts(with: "<") && roomString.count > 0) {
                        r.append(Room(input: roomString))
                        roomString = l
                        i = i + 1
                    } else {
                        roomString = roomString + l
                    }
                }
                r.append(Room(input: roomString))
                
            } catch {
                let alert = UIAlertController(title: "ERROR", message: "There was a error in getting access to this file.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "ERROR", message: "There was an error in finding the input file.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        //start game
        pos = r[0]
        joinRoom(r: pos)
        updateInventoryDisplay()
        optionSize = pos.conditions.count
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

