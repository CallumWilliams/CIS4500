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
        
        let NEWLINE: String = "\n"
        outputLabel.numberOfLines = 0
        let wordCount = countWords(input: (textField.text))
        let sentenceCount = countSentences(input: (textField.text))
        let syllableCount = countSyllables(input: (textField.text))
        let index = computeIndex(word: wordCount, sent: sentenceCount, syll: syllableCount)
        outputLabel.text = "Words: " + String(wordCount) + NEWLINE
        outputLabel.text = outputLabel.text! + "Sentence: " + String(sentenceCount) + NEWLINE
        outputLabel.text = outputLabel.text! + "Syllables: " + String(syllableCount) + NEWLINE
        outputLabel.text = outputLabel.text! + "Index: " + String(index)
        
        
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
        
        return sentCount
        
    }
    
    func countSyllables(input: String) -> Int {
        
        var syllCount: Int = 0
        let delims = ["a", "e", "i", "o", "u", "y"]
        var i_tmp = input.startIndex
        for i in input.indices {
            if (delims.contains(String(input[i]))) {
                if (!delims.contains(String(input[i_tmp]))) {
                    syllCount = syllCount + 1
                }
            }
            //if we find a blank and the previous character was an 'e', undo last step
            if (input[i] == " ") {
                if (input[i_tmp] == "e") {
                    syllCount = syllCount - 1
                }
            }
            i_tmp = i
        }
        
        if (syllCount < 0) {
            return 1;
        }
        return syllCount
        
    }
    
    func computeIndex(word: Int, sent: Int, syll: Int) -> Double {
        
        var ret: Double;
        
        ret = 206.835 - (84.6 * Double(syll/word)) - (1.015 * Double(word/sent))
        
        return ret;
        
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

