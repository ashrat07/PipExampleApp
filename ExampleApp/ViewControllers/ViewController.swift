//
//  ViewController.swift
//  ExampleApp
//
//  Created by Ashish on 01/07/25.
//

import UIKit

class ViewController: UIViewController {
    
    private var pushButton: UIButton! = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Push", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pushButton)
        pushButton.addTarget(self, action: #selector(push), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pushButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func push() {
        self.navigationController?.pushViewController(makeExampleViewController(), animated: true)
    }
}
