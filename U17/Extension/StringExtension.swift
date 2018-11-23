//
//  StringExtension.swift
//  U17
//
//  Created by 岳琛 on 2018/11/19.
//  Copyright © 2018 NJTU-Engineering. All rights reserved.
//

import Foundation

extension String {
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
}
