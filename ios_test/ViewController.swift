//
//  ViewController.swift
//  ios_test
//
//  Created by Mike Karpenko on 02.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var textfield: InputTextField = {
        let tf = InputTextField()
        tf.titleLabel.text = "Title"
        tf.textField.placeholder = "Placeholder"
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }


}

