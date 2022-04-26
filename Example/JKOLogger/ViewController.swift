//
//  ViewController.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 08/18/2020.
//  Copyright (c) 2020 chiehchun.lee. All rights reserved.
//

import UIKit
import JKOLogger

class ViewController: UIViewController {
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        label.center = self.view.center
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        self.view.addSubview(label)
        label.text = "tap me!"
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapG))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
    }

    @objc func tapG() {
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController : JKOLoggerDisplayComponentProtocol {
    var pageName: String? {
        get { return "vcpage" }
    }

    var module: String? {
        get { return "module1" }
    }

    var componentDescription: String? {
        get { return "des" }
    }

    var componentHashKey: String? {
        get { return "" }
    }

    var properties: [String : Any]? {
        get {return [:]}
    }
}
