//
//  ViewController.swift
//  Version
//
//  Created by Sergey Lavrov on 07.08.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func roll(_ sender: Any) {
        label.text = String(Int.random(in: 1..<7))
    }
    
}
