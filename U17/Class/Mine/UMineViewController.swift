//
//  UMineViewController.swift
//  U17
//
//  Created by 岳琛 on 2018/10/24.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//  我的页

import UIKit
import MBProgressHUD

class UMineViewController: UBaseViewController {

    private lazy var myArray: Array = {
        return [[["icon":"mine_vip", "title": "登录"],
                 ["icon":"mine_setting", "title": "退出登录"]]]
    }()
    
    private lazy var head: UMineHead = {
        return UMineHead(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
    }()
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.backgroundColor = UIColor.background
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: UBaseTableViewCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        
        tableView.parallaxHeader.view = head
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.minimumHeight = navigationBarY
        tableView.parallaxHeader.mode = .fill
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.parallaxHeader.height)
    }
    
    private func checkLoginLocalData() -> Void {
        // 读取本地缓存
        let loginType: Bool = UserDefaults.standard.bool(forKey: "loginType")
        if loginType == false {
            self.present(ULoginViewController.getVC(), animated: true) { }
        } else {
            self.showTips("已经登录")
        }
    }
    
    private func checkLogoutLocalData() -> Void {
        // 读取本地缓存
        let loginType: Bool = UserDefaults.standard.bool(forKey: "loginType")
        if loginType == true {
            UserDefaults.standard.set(false, forKey: "loginType")
            self.showTips("退出成功")
        } else {
            self.showTips("尚未登录")
        }
    }
    
    private func showTips(_ name : String) {
        let tips:MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        tips.mode = MBProgressHUDMode.text
        tips.label.text = name
        tips.removeFromSuperViewOnHide = true
        tips.hide(animated: true, afterDelay: 3)
    }
}

extension UMineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -(scrollView.parallaxHeader.minimumHeight) {
            navigationController?.barStyle(.theme)
            navigationItem.title = "我的"
        } else {
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = myArray[section]
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        let sectionArray = myArray[indexPath.section]
        let dict: [String: String] = sectionArray[indexPath.row]
        cell.imageView?.image =  UIImage(named: dict["icon"] ?? "")
        cell.textLabel?.text = dict["title"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.checkLoginLocalData()
        }
        
        if indexPath.row == self.myArray.count {
            self.checkLogoutLocalData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
