//
//  UDocumentListViewController.swift
//  U17
//
//  Created by 岳琛 on 2018/10/24.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//  书架-书单页

import UIKit

class UDocumentListViewController: UBaseViewController {

    var list:[Any] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.background
        tw.delegate = self
        tw.dataSource = self
        tw.register(UITableViewCell.self, forCellReuseIdentifier: "DocumentListCell")
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        
        NotificationCenter.default.addObserver(self, selector: #selector(collectionDataDidChange), name: .UCollectionDataDidChange, object: nil)
        collectionDataDidChange()
    }
    
    @objc func collectionDataDidChange() {
        self.requestLocalData()
    }
    
    private func requestLocalData() {
        let localDic: [String : Any] = UserDefaults.standard.dictionary(forKey: "CollectionData") ?? [:]
        if localDic.keys.count > 0 {
            var array = [Any]()
            for item in localDic.values {
                array.append(item)
            }
            list = array
        } else {
            list = []
        }
    }
}

extension UDocumentListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentListCell", for: indexPath)
        
        let currentDic:[String : Any] = list[indexPath.row] as! [String : Any]
        let currentName: String = currentDic["name"] as! String
        cell.textLabel?.text = currentName;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentDic:[String : Any] = list[indexPath.row] as! [String : Any]
        let currentID: Int = currentDic["comic_id"] as! Int
        let vc = UComicViewController(comicid: currentID)
        navigationController?.pushViewController(vc, animated: true)
    }
}

