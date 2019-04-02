//
//  ViewController.swift
//  test1
//
//  Created by bojun  Huang on 2019/3/23.
//  Copyright © 2019 NTU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Magic.setTitleColor(.red, for: .normal)
        updateUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func showMessage(sender: UIButton) {
        let alertController = UIAlertController(title: "Welcome to My First App", message: "Hello World", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    var temp = true
    @IBOutlet weak var Magic: UIButton!
    @IBAction func magicaction(_ sender: Any) {
        temp = !temp
        updateUI()
    }
    func updateUI(){
        if temp{
            view.backgroundColor = .white
            Magic.setTitle("Off", for: .normal)
        }else{
            view.backgroundColor = .black
            Magic.setTitle("On", for: .normal)
        }
    }
    

}

