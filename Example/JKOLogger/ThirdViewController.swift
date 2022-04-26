//
//  ThirdViewController.swift
//  JKOLogger_Example
//
//  Created by chiehchun.lee on 2020/11/18.
//  Copyright © 2020 JKOS. All rights reserved.
//

import UIKit
import JKOLogger

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let table = UITableView()
    let headerView = JKCellItem()
    let footerView = JKCellItem()
    var logger : JKOScrollViewExposeLogger?
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 55)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.delegate = self
        v.dataSource = self
        v.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logger = JKOScrollViewExposeLogger(listenTo: [collectionView,table])
        self.view.addSubview(table)
        table.frame = self.view.bounds
        table.delegate = self
        table.dataSource = self
        table.register(JKCell.self, forCellReuseIdentifier: "cell")
        table.register(JKCell2.self, forCellReuseIdentifier: "cell2")


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
        if indexPath.row == 3 {
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? JKCell2 else {
                return tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            }
            if cell2.cellItem == nil {
                cell2.cellItem = collectionView
            }
            return cell2
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? JKCell else {
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let loggerCell = cell as? JKCell else {return}
        loggerCell.cellItem.name = "index\(indexPath.row)"
//        logger?.appendLoggerViewIfNotExist(loggerCell.cellItem)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ThirdViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCollectionViewCell {
            cell.index = CGFloat(indexPath.row)
            cell.contentView.backgroundColor = .lightGray
            logger?.appendLoggerViewIfNotExist(cell)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ThirdViewController : JKOLoggerDisplayComponentProtocol {
    var pageName: String? {
        get { return "vcpage3" }
    }

    var module: String? {
        get { return "module3" }
    }

    var componentDescription: String? {
        get { return "des3" }
    }

    var componentHashKey: String? {
        get { return "" }
    }

    var properties: [String : Any]? {
        get {return [:]}
    }
}


class MyCollectionViewCell: UICollectionViewCell {
    var index : CGFloat = -1
}

extension MyCollectionViewCell : JKOLoggerComponentProtocol {
    var properties: [String : Any]? { get {return ["index":"\(index)"]} }
    var module      : String? { get { return "collect"} }
    var componentDescription : String? { get { return "collect" } }
    var componentHashKey : String? { get { return "\(index)" } }
}

//MARK : test cell
class JKCell2 : UITableViewCell {
    var cellItem : UICollectionView?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let _cellItem = cellItem, _cellItem.superview==nil {
            self.contentView.addSubview(_cellItem)
            _cellItem.frame = self.contentView.bounds
            _cellItem.frame = self.contentView.bounds
        }
    }

}
