//
//  UHomeViewController.swift
//  U17
//
//  Created by 岳琛 on 2018/10/24.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//

import UIKit

class UHomeViewController: UPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"),
                                                            target: self,
                                                            action: #selector(selectAction))
    }
    
    @objc private func selectAction() {
        navigationController?.pushViewController(USearchViewController(), animated: true)
    }
}
