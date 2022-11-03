//
//  Label.swift
//  ios_test
//
//  Created by Mike Karpenko on 03.11.2022.
//

import UIKit

class Label: UILabel {
    override var text: String? {
        didSet {
            if let text {
                let attrText = NSMutableAttributedString(string: text)
                let range = NSRange(location: 0, length: text.count)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = 50
                paragraphStyle.maximumLineHeight = 50
                attrText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
                attrText.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
                attrText.addAttribute(.baselineOffset, value: 11, range: range)
                attributedText = attrText
            }
        }
    }
}
