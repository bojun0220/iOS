//
//  ViewController.swift
//  Calculator
//
//  Created by bojun  Huang on 2019/3/28.
//  Copyright © 2019 NTU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    var first = [0, 0]
    var later = [0, 0]
    var calcbutton = false
    var dotbutton = false
    var calcway: Character = "+"

    
    @IBOutlet var numButton: [UIButton]!
    @IBOutlet var opButton: [UIButton]!
    @IBAction func pushNum(_ sender: UIButton) {
            if let number = numButton.firstIndex(of: sender){
                if calcbutton == false{
                    if dotbutton == false{
                        first[0] = first[0] * 10 + number
                    }else{
                        first[1] = first[1] * 10 + number
                    }
                }else{
                    if dotbutton == false{
                        later[0] = later[0] * 10 + number
                    }else{
                        later[1] = later[1] * 10 + number
                    }
                }
            }else{
            }
    }
    
    @IBAction func dot(_ sender: UIButton) {
        dotbutton = true
    }
    func calculate(first: String, second: String, operation: Character)->String{
        var answer = 0.0
        
        switch operation {
        case "+":
            if let firstnum = Double(first), let secondnum = Double(second){
                answer = firstnum + secondnum
            }
        case "-":
            if let firstnum = Double(first), let secondnum = Double(second){
                answer = firstnum - secondnum
            }
        case "*":
            if let firstnum = Double(first), let secondnum = Double(second){
                answer = firstnum * secondnum
            }
        case "/":
            if let firstnum = Double(first), let secondnum = Double(second){
                answer = firstnum / secondnum
            }
        default:
            return first
        }
            return String(answer)
    }
    @IBAction func equal(_ sender: UIButton) {
        if calcbutton == false{
            //print(first)
            showlabel.text = first
        }else{
            //print(calculate(first: first, second: later, operation: calcway))
            showlabel.text = calculate(first: first, second: later, operation: calcway)
        }
        first = ""
        later = ""
        calcbutton = false
        calcway = "+"

        
    }
    
    @IBAction func Operator(_ sender: UIButton) {
        if let OperationButton = opButton[opButton.firstIndex(of: sender)]{
            
        }
        
    }
    @IBAction func clear(_ sender: UIButton) {
        first = ""
        later = ""
        calcbutton = false
        calcway = "+"
        showlabel.text = "0"
    }
    @IBAction func plusminus(_ sender: UIButton) {
    }
    @IBAction func mod(_ sender: UIButton) {
    }
    
    @IBOutlet weak var showlabel: UILabel!
    
}

