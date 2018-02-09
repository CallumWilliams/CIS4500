//
//  ViewController.swift
//  A2
//
//  Created by toxin_4500 on 2018-02-08.
//  Copyright © 2018 toxin_4500. All rights reserved.
//

import UIKit

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
    
    init(req: String, dest: String, desc: String, a: Bool) {
        
        self.decRequirement = req
        self.decDestination = dest
        self.decDescription = desc
        self.auto = a
        
    }
    
    func getDecisionString() -> String {
        return self.decDescription + " " + decDestination + "\n"
    }
    
}

class Room {
    
    var roomID: String
    var roomDescription: String
    var conditions: [Decision] = []
    var endRoom: Bool
    
    init() {
        self.roomID = ""
        self.roomDescription = ""
        endRoom = false
    }
    
    init(input: String) {
        
        endRoom = false//until we find a '-end'
        
        //check if this is an end cell
        if (input.contains("-end")) {
            endRoom = true
        }
        
        if (input.contains("-inventory")) {
            
            var invToken = input.components(separatedBy: "-inventory")
            
            
        }
        
        //parse initial room data
        var token = input.components(separatedBy: " ")
        self.roomID = token[0]
        
        let quoteToken = input.components(separatedBy: "\"")
        self.roomDescription = quoteToken[1]
        
        //get destination options
        var optCount = 1
        var numberToken = input.components(separatedBy: String(optCount) + ".")
        var tokCount = numberToken.count
        while (tokCount > 1) {
            
            //parse out arguments
            var numberQuotes = numberToken[1].components(separatedBy: "\"")
            let d = numberQuotes[1]
            
            optCount = optCount + 1
            var o = numberQuotes[2].components(separatedBy: ">")
            conditions.append(Decision(req: "", dest: o[0], desc: d, a: false))
            numberToken = input.components(separatedBy: String(optCount) + ".")
            tokCount = numberToken.count
            
        }
        
        //get conditionals
        var condToken = input.components(separatedBy: "-if")
        if (condToken.count > 1) {
            for i in 1..<condToken.count {
                var ifQuotes = condToken[i].components(separatedBy: "\"")
                //clean empty strings
                var cond = ""
                var out = ""
                var desc = ""
                var parseState = 0
                for k in 0..<ifQuotes.count {
                    
                    if (ifQuotes[k] != " ") {//use this
                        
                        if (parseState == 0) {//get condition
                            cond = ifQuotes[k]
                            parseState = 1
                        } else if (parseState == 1) {//get success
                            out = ifQuotes[k]
                            parseState = 2
                        } else if (parseState == 2) {//get output
                            desc = ifQuotes[k]
                            parseState = 3
                        } else if (parseState == 3) {//build condition
                            conditions.append(Decision(req: cond, dest: out, desc: desc, a: true))
                            parseState = 4
                        } else {
                            //otherwise ignore
                        }
                        
                    }//otherwise skip
                    
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
    
    @IBAction func PerformMove(_ sender: Any) {
        
        //all remaining game logic
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayLabel.numberOfLines = 0
        OptionBox.numberOfLines = 0
        InventoryBox.numberOfLines = 0
        
        var r: [Room] = []
        
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
        pos = r[0];
        DisplayLabel.text = pos.roomInfoOutput() + "\n"
        OptionBox.text = pos.getDecisionsList(auto: false)
        DisplayLabel.text! = DisplayLabel.text! + pos.getDecisionsList(auto: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

