//
//  Extensions+String.swift
//  GameOfChat
//
//  Created by YouSS on 4/8/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

extension String {
    func estimateFrameForText(fontSize: CGFloat) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)], context: nil)
    }
}
