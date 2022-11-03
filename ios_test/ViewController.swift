//
//  ViewController.swift
//  ios_test
//
//  Created by Mike Karpenko on 02.11.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.attributedText = FontFactory.shared.buildTextFont(forStyle: .tw4).attributedString("test")
    }


}

