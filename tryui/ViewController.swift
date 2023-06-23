//
//  ViewController.swift
//  tryui
//
//  Created by Елизавета Шерман on 22.06.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print("YES")
        
        preparePlainView2()
    }
    
    func preparePlainView2() {
        let plainview = UIView(frame: CGRect(x: 200, y: 200, width: 100, height: 200))
        plainview.backgroundColor = .red
        view.addSubview(plainview)
    }

}

