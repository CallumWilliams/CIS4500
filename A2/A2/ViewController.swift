//
//  ViewController.swift
//  A2
//
//  Created by toxin_4500 on 2018-02-08.
//  Copyright © 2018 toxin_4500. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let file = Bundle.main.path(forResource: "input", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: file)
                print(contents)
            } catch {
                print("error")
            }
        } else {
            print("no")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

