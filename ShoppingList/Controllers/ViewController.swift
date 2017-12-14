//
//  ViewController.swift
//  ShoppingList
//
//  Created by Nirmalya Mahanti on 14/12/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let shoppingList = ShoppingItemJSONManager().readFromJsonFile() else {
            return
        }
        print (shoppingList)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

