//
//  ViewController.swift
//  FitbitTest
//
//  Created by bojun  Huang on 2019/6/8.
//  Copyright © 2019 NTU IOX Center. All rights reserved.
//

import UIKit


class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func fitbitButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "即將跳轉至Fitbit應用程式", message: "請進入後請下拉重整\n之後請按左上方返回本程式", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {action in self.gotoFitbit() })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func webButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "即將跳轉至網頁", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {action in self.gotoWeb() })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func gotoWeb() {
        let webURL = "http://www.iox.ntu.edu.tw"
        if let url = URL(string: webURL){
            UIApplication.shared.open(url)
        }
    }
    func gotoFitbit() {
        let urlString = "Fitbit://"
        if let url = URL(string: urlString){
            UIApplication.shared.open(url)
        }
        
    }
    
}

