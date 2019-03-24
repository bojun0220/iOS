//
//  ViewController.swift
//  HelloWorld
//
//  Created by bojun  Huang on 2019/3/22.
//  Copyright © 2019 NTU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func showMessage(sender: UIButton){
        let alertController = UIAlertController(title: "It is my first iOS APP", message: "I am a student", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }


}

