//
// Copyright © 2022 Monvel LTD. All rights reserved.
//
// Created by Mike Karpenko
//

import UIKit

private protocol TextFontJSON {
    var upperCase: Bool { get }
    var underlined: Bool { get }
}

final class TextFont: AbstractFont, TextFontJSON {
    var upperCase: Bool
    var underlined: Bool

    init(
        fontName: String,
        size: CGFloat,
        lineHeight: CGFloat?,
        uppercase: Bool = false,
        underlined: Bool = false,
        charsSpacing: CGFloat? = nil
    ) {
        self.upperCase = uppercase
        self.underlined = underlined
        super.init(fontName: fontName, size: size, lineHeight: lineHeight, charsSpacing: charsSpacing)
    }

    override func attributes(withParagraphStyle paragraphStyle: NSParagraphStyle?) -> [NSAttributedString.Key: Any] {
        var attrs = super.attributes(withParagraphStyle: paragraphStyle)

        if self.underlined {
            attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        return attrs
    }

    func attributedString(_ string: String) -> NSAttributedString {
        let attrs = self.attributes
        return NSAttributedString(string: string, attributes: attrs)
    }
}
