//
//  TextFont.swift
//  ios_test
//
//  Created by Mike Karpenko on 14.11.2022.
//

import UIKit

final class TextFont: AbstractFont {
    init(
        font: UIFont,
        size: CGFloat,
        lineHeight: CGFloat?,
        charsSpacing: CGFloat? = nil
    ) {
        super.init(
            font: font,
            size: size,
            lineHeight: lineHeight,
            charsSpacing: charsSpacing
        )
    }

    func text(_ string: String?) -> NSAttributedString? {
        guard let string else { return nil }
        let attrs = self.attributes
        return NSAttributedString(string: string, attributes: attrs)
    }
}

extension NSAttributedString {
    static var largeTitle: TextFont {
        let font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: .systemFont(ofSize: 32.0, weight: .bold))
        return TextFont(font: font, size: 32, lineHeight: 40, charsSpacing: 0.4)
    }

    static var title1: TextFont {
        let font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: .systemFont(ofSize: 28.0, weight: .regular))
        return TextFont(font: font, size: 28, lineHeight: 32, charsSpacing: 0.38)
    }

    static var title2: TextFont {
        let font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: .systemFont(ofSize: 24.0, weight: .bold))
        return TextFont(font: font, size: 24, lineHeight: 32, charsSpacing: -0.26)
    }

    static var title3: TextFont {
        let font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: .systemFont(ofSize: 20.0, weight: .bold))
        return TextFont(font: font, size: 20, lineHeight: 28, charsSpacing: -0.45)
    }

    static var headline: TextFont {
        let font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 16.0, weight: .bold))
        return TextFont(font: font, size: 16, lineHeight: 24, charsSpacing: -0.43)
    }

    static var body: TextFont {
        let font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 16.0, weight: .regular))
        return TextFont(font: font, size: 16, lineHeight: 24, charsSpacing: -0.43)
    }

    static var callout: TextFont {
        let font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: .systemFont(ofSize: 14.0, weight: .regular))
        return TextFont(font: font, size: 14, lineHeight: 20, charsSpacing: -0.31)
    }

    static var subheadline: TextFont {
        let font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: .systemFont(ofSize: 14.0, weight: .semibold))
        return TextFont(font: font, size: 14, lineHeight: 20, charsSpacing: -0.23)
    }

    static var footnote: TextFont {
        let font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: .systemFont(ofSize: 13.0, weight: .regular))
        return TextFont(font: font, size: 13, lineHeight: 16, charsSpacing: -0.08)
    }

    static var caption1: TextFont {
        let font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .systemFont(ofSize: 13.0, weight: .medium))
        return TextFont(font: font, size: 13, lineHeight: 16)
    }

    static var caption2: TextFont {
        let font = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: .systemFont(ofSize: 12.0, weight: .semibold))
        return TextFont(font: font, size: 12, lineHeight: 16, charsSpacing: 0.06)
    }

    static var custom: TextFont {
        let font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: .systemFont(ofSize: 14.0, weight: .bold))
        return TextFont(font: font, size: 14, lineHeight: 20, charsSpacing: -0.23)
    }
}

extension UIFont {
    static var largeTitle: UIFont {
        NSAttributedString.largeTitle.font
    }

    static var title1: UIFont {
        NSAttributedString.title1.font
    }

    static var title2: UIFont {
        NSAttributedString.title2.font
    }

    static var title3: UIFont {
        NSAttributedString.title3.font
    }

    static var headline: UIFont {
        NSAttributedString.headline.font
    }

    static var body: UIFont {
        NSAttributedString.body.font
    }

    static var callout: UIFont {
        NSAttributedString.callout.font
    }

    static var subheadline: UIFont {
        NSAttributedString.subheadline.font
    }

    static var footnote: UIFont {
        NSAttributedString.footnote.font
    }

    static var caption1: UIFont {
        NSAttributedString.caption1.font
    }

    static var caption2: UIFont {
        NSAttributedString.caption2.font
    }

    static var custom: UIFont {
        NSAttributedString.custom.font
    }
}

