//
//  UBaseTableViewHeaderFooterView.swift
//  U17
//
//  Created by 岳琛 on 2018/11/10.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//

import UIKit
import Reusable

class UBaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}

}
