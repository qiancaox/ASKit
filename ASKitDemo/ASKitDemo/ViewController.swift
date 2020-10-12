//
//  ViewController.swift
//  ASKitDemo
//
//  Created by AmtSuper on 2020/10/12.
//

import UIKit
import ASKit
import ASCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(0xefefef)
        HUD.show(inView: view, text: "Loading...")
        DispatchAfterDelay(.now() + 1) {
            HUD.state(inView: self.view, status: .success)
        }
    }

}

