//
//  AbstractFont.swift
//  ios_test
//
//  Created by Mike Karpenko on 14.11.2022.
//

import UIKit

private let abstractFontUndefinedLineHeight = CGFloat.leastNormalMagnitude

class AbstractFont {
    var font: UIFont
    var fontSize: CGFloat
    var lineHeight: CGFloat
    var charsSpacing: CGFloat?
    let fontMetrics: UIFontMetrics?
    private var baselineOffset: CGFloat = .zero

    init(
        font: UIFont,
        fontMetrics: UIFontMetrics? = nil,
        size: CGFloat,
        lineHeight: CGFloat?,
        charsSpacing: CGFloat? = nil
    ) {
        self.font = font
        self.fontMetrics = fontMetrics
        self.fontSize = size
        self.charsSpacing = charsSpacing

        self.lineHeight = lineHeight ?? abstractFontUndefinedLineHeight
    }

    var attributes: [NSAttributedString.Key: Any] {
        return self.attributes(with: .natural)
    }

    func attributes(with textAlignment: NSTextAlignment) -> [NSAttributedString.Key: Any] {
        let style = self.paragraphStyle(forTextAligment: textAlignment)
        return self.attributes(withParagraphStyle: style)
    }

    func attributes(withParagraphStyle paragraphStyle: NSParagraphStyle?) -> [NSAttributedString.Key: Any] {
        var attr: [NSAttributedString.Key: Any] = [
            .font: self.font,
            .paragraphStyle: paragraphStyle ?? NSParagraphStyle.default,
            .baselineOffset: baselineOffset
        ]

        if let charsSpacing = charsSpacing {
            attr[.kern] = NSNumber(value: Float(charsSpacing))
        }
        return attr
    }

    func paragraphStyle(forTextAligment textAligment: NSTextAlignment) -> NSParagraphStyle? {
        let style = NSMutableParagraphStyle()
        style.alignment = textAligment
        style.lineBreakMode = .byWordWrapping

        if self.lineHeight != abstractFontUndefinedLineHeight {
            let lineHeightMultiple = lineHeight / font.lineHeight
            style.lineHeightMultiple = lineHeightMultiple

            baselineOffset = (lineHeight - font.lineHeight) / 4

            let scaledLineHeight: CGFloat = fontMetrics?.scaledValue(for: lineHeight) ?? lineHeight
            style.minimumLineHeight = scaledLineHeight
            style.maximumLineHeight = scaledLineHeight
        }

        return style
    }
}

