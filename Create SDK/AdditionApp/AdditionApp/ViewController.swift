//
//  ViewController.swift
//  AdditionApp
//
//  Created by Amit on 24/08/22.
//

import UIKit
import Testing

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let obj = Addtwonumber()
        
        let add = obj.additiontwonumber(num1: 5, num2: 5)
        
        print(add)

        
        // Do any additional setup after loading the view.
    }


}

