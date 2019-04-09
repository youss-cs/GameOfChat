//
//  Extensions+Date.swift
//  GameOfChat
//
//  Created by YouSS on 4/9/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation

extension Date {
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
