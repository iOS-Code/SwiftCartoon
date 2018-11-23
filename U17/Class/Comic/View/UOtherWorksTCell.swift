//
//  UOtherWorksTCell.swift
//  U17
//
//  Created by 岳琛 on 2018/11/22.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//

import UIKit

class UOtherWorksTCell: UBaseTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: DetailStaticModel? {
        didSet{
            guard let model = model else { return }
            textLabel?.text = "其他作品"
            detailTextLabel?.text = "\(model.otherWorks?.count ?? 0)本"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        }
    }
}
