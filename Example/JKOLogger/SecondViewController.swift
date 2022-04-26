//
//  SecondViewController.swift
//  JKOLogger_Example
//
//  Created by chiehchun.lee on 2020/8/18.
//  Copyright © 2020 JKOS. All rights reserved.
//

import UIKit
import JKOLogger

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let table = UITableView()
    let headerView = JKCellItem()
    let footerView = JKCellItem()
    var logger : JKOScrollViewExposeLogger?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logger = JKOScrollViewExposeLogger(table)
        self.view.addSubview(table)
        table.frame = self.view.bounds
        table.delegate = self
        table.dataSource = self
        table.register(JKCell.self, forCellReuseIdentifier: "cell")


        self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150)
        self.headerView.backgroundColor = .red
        self.headerView.name = "header"
        self.table.tableHeaderView = headerView


        self.footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150)
        self.footerView.backgroundColor = .red
        self.footerView.name = "footer"
        self.table.tableFooterView = footerView

        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoNext))
        self.footerView.addGestureRecognizer(tap)

        logger?.appendLoggerViewIfNotExist(headerView)
        logger?.appendLoggerViewIfNotExist(footerView)

    }

    @objc func gotoNext() {
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    deinit {
        logger?.despose()
        print("deinit \(type(of: self))")
    }
    private var isGoAndBack = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isGoAndBack {
            self.logger?.resendExposureEvent()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isGoAndBack = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? JKCell else {
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let loggerCell = cell as? JKCell else {return}
        loggerCell.cellItem.name = "index\(indexPath.row)"
        logger?.appendLoggerViewIfNotExist(loggerCell.cellItem)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ThirdViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension SecondViewController : JKOLoggerDisplayComponentProtocol {
    var pageName: String? {
        get { return "vcpage2" }
    }

    var module: String? {
        get { return "module2" }
    }

    var componentDescription: String? {
        get { return "des2" }
    }

    var componentHashKey: String? {
        get { return "" }
    }

    var properties: [String : Any]? {
        get {return [:]}
    }
}

//MARK : test cell
class JKCell : UITableViewCell {
    var cellItem : JKCellItem = JKCellItem()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cellItem)
        cellItem.frame = self.contentView.bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cellItem.frame = self.contentView.bounds
    }

}

class JKCellItem : UIView {
    private var _name:String? = ""
    var name: String? {
        get {
            return _name
        }
        set {
            _name = newValue
            self.label.text = newValue
        }
    }
    var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JKCellItem : JKOLoggerComponentProtocol {
    var properties: [String : Any]? { get {return ["index":"\(name ?? "")"]} }
    var module      : String? { get { return "coupon"} }
    var componentDescription : String? { get { return "myCouponPage" } }
    var componentHashKey : String? { get { return name } }
}

