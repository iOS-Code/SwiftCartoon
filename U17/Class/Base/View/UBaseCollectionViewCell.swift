//
//  UBaseCollectionViewCell.swift
//  U17
//
//  Created by 岳琛 on 2018/10/24.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//

import UIKit
import Reusable

class UBaseCollectionViewCell: UICollectionViewCell, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}
}
