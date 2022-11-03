//
// Copyright © 2022 Monvel LTD. All rights reserved.
//
// Created by Mike Karpenko
//

import UIKit

final class TextFont: AbstractFont {
    init(
        fontName: String,
        size: CGFloat,
        lineHeight: CGFloat?,
        charsSpacing: CGFloat? = nil
    ) {
        super.init(fontName: fontName, size: size, lineHeight: lineHeight, charsSpacing: charsSpacing)
    }

    func text(_ string: String) -> NSAttributedString {
        let attrs = self.attributes
        return NSAttributedString(string: string, attributes: attrs)
    }
}

extension NSAttributedString {
    static var tw1: TextFont {
        return TextFont(fontName: "Gotham-Bold", size: 80, lineHeight: 80)
    }
}
