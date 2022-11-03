//
// Copyright © 2022 Monvel LTD. All rights reserved.
//
// Created by Mike Karpenko
//

import UIKit

private protocol CommonFontAttributes {
    var attributes: [NSAttributedString.Key: Any] { get }
    var font: UIFont { get }
}

private let abstractFontUndefinedLineHeight = CGFloat.leastNormalMagnitude

class AbstractFont: CommonFontAttributes {
    var fontName: String
    var fontSize: CGFloat
    var lineHeight: CGFloat
    var charsSpacing: CGFloat?
    let fontMetrics: UIFontMetrics?
    private var baselineOffset: CGFloat = .zero

    init(fontName: String,
         fontMetrics: UIFontMetrics? = nil,
         size: CGFloat,
         lineHeight: CGFloat?,
         charsSpacing: CGFloat? = nil) {
        self.fontName = fontName
        self.fontMetrics = fontMetrics
        self.fontSize = size
        self.charsSpacing = charsSpacing

        self.lineHeight = lineHeight ?? abstractFontUndefinedLineHeight
    }

    var attributes: [NSAttributedString.Key: Any] {
        return self.attributes(with: .natural)
    }

    var font: UIFont {
        guard let font = UIFont(name: self.fontName, size: self.fontSize) else {
            fatalError("""
            Failed to load the \(self.fontName) font with size: \(self.fontSize).
            Make sure the font file is included in the project and the font name is spelled correctly.
            """)
        }
        return font
    }

    func attributes(with textAlignment: NSTextAlignment) -> [NSAttributedString.Key: Any] {
        let style = self.paragraphStyle(forTextAligment: textAlignment)
        return self.attributes(withParagraphStyle: style)
    }

    func attributes(with textAlignment: NSTextAlignment, lineBreakMode: NSLineBreakMode) -> [NSAttributedString.Key: Any] {
        let style = self.paragraphStyle(forTextAligment: textAlignment, lineBreakMode: lineBreakMode)
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

    func attributes(forLabel label: UILabel) -> [NSAttributedString.Key: Any]? {
        let style = self.paragraphStyle(forLabel: label)
        return self.attributes(withParagraphStyle: style)
    }

    func paragraphStyle(forTextAligment textAligment: NSTextAlignment) -> NSParagraphStyle? {
        let style = paragraphStyle(forTextAligment: textAligment, lineBreakMode: .byWordWrapping)
        return style
    }

    func paragraphStyle(forTextAligment textAligment: NSTextAlignment, lineBreakMode: NSLineBreakMode) -> NSParagraphStyle? {
        let style = NSMutableParagraphStyle()
        style.alignment = textAligment
        style.lineBreakMode = lineBreakMode

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

    func paragraphStyle(forLabel label: UILabel) -> NSParagraphStyle? {
        let style = self.paragraphStyle(
            forTextAligment: label.textAlignment,
            lineBreakMode: label.lineBreakMode
        )
        return style
    }
}

