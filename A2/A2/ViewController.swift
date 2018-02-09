//
//  ViewController.swift
//  A2
//
//  Created by toxin_4500 on 2018-02-08.
//  Copyright © 2018 toxin_4500. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var DisplayLabel: UILabel!
    
    class Decision {
        
        var decDescription: String
        var decDestination: String
        var decRequirement: String
        
        init(desc: String, dest: String, req: String) {
            
            self.decDescription = desc
            self.decDestination = dest
            self.decRequirement = req
            
        }
        
    }
    
    class Room {
        
        var roomID: String
        var roomDescription: String
        
        init(input: String) {
            
            //parse initial room data
            var token = input.components(separatedBy: " ")
            self.roomID = token[0]
            
            let quoteToken = input.components(separatedBy: "\"")
            self.roomDescription = quoteToken[1]
            
            print("|" + input + "|")
            
        }
        
        func roomInfoOutput() -> String {
            return self.roomID + ": \"" + self.roomDescription
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayLabel.numberOfLines = 0
        if let file = Bundle.main.path(forResource: "input", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: file)
                let lines = contents.components(separatedBy: .newlines)
                var roomString = ""
                var r: [Room] = []
                print(lines.count)
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
                
                for j in 0..<i {
                    DisplayLabel.text! = DisplayLabel.text! + r[j].roomInfoOutput() + "\n"
                }
                
            } catch {
                print("Error reading contents")
            }
        } else {
            print("ERROR - File not found")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

