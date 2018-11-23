//
//  UTicketTCell.swift
//  U17
//
//  Created by 岳琛 on 2018/11/22.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//

import UIKit

class UTicketTCell: UBaseTableViewCell {
    
    var model: DetailRealtimeModel? {
        didSet {
            guard let model = model else { return }
            let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ",
                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
            text.append(NSAttributedString(string: "\(model.comic?.total_ticket ?? "")",
                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange,
                                                        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]))
            text.insert(NSAttributedString(string: "\(model.comic?.monthly_ticket ?? "")",
                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange,
                                                        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]),
                        at: 6)
            textLabel?.attributedText = text
            textLabel?.textAlignment = .center
        }
    }

}
