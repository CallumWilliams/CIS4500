//
//  ViewController.swift
//  A1
//
//  Created by toxin_4500 on 2018-01-25.
//  Copyright © 2018 toxin_4500. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBAction func calculate(sender: UIButton) {
        
        let wordCount = countWords(input: (textField.text))
        let sentenceCount = countSentences(input: (textField.text))
        //get syllable count
        outputLabel.text = "Words: " + String(wordCount) +
        "\nSentences: " + String(sentenceCount)
        
        
    }
    
    func countWords(input: String) -> Int {
        
        var wordCount: Int = 0
        let words = input.components(separatedBy: " ")
        
        for i in words {
            if (i != "") {
                wordCount = wordCount + 1
            }
        }
        return wordCount
        
    }
    
    func countSentences(input: String) -> Int {
        
        var sentCount: Int = 0
        let delims = [".", ":", ";", "!", "?"]
        var i_tmp = input.startIndex
        for i in input.indices {
            if (delims.contains(String(input[i]))) {
                if (!delims.contains(String(input[i_tmp]))) {
                    sentCount = sentCount + 1
                }
            }
            i_tmp = i
        }
        
        textField.text = String(sentCount)
        return sentCount
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

