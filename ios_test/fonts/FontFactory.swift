//
// Copyright © 2022 Monvel LTD. All rights reserved.
//
// Created by Mike Karpenko
//

import UIKit

final class FontFactory {
    static let shared = FontFactory()

    func buildTextFont(forStyle style: TextFontStyle) -> TextFont { // swiftlint:disable:this function_body_length
        let fontMedium = "Gotham-Medium"
        let fontBook = "Gotham-Book"
        let fontLight = "Gotham-Light"
        let fontBold = "Gotham-Bold"

        switch style {
        case .missingSpec:
            return TextFont(
                fontName: fontMedium,
                size: 18,
                lineHeight: 24,
                uppercase: true,
                underlined: true
            )
        case .tw1:
            return TextFont(fontName: fontBold, size: 80, lineHeight: 80)
        case .tw2:
            return TextFont(fontName: fontBold, size: 48, lineHeight: 90, charsSpacing: -0.4)
        case .tw3:
            return TextFont(fontName: fontBold, size: 32, lineHeight: 40)
        case .tw4:
            return TextFont(fontName: fontBook, size: 25, lineHeight: 91)
        case .tw5:
            return TextFont(fontName: fontLight, size: 25, lineHeight: 31)
        case .tw6:
            return TextFont(fontName: fontMedium, size: 15, lineHeight: 20)
        case .tw7:
            return TextFont(fontName: fontBook, size: 15, lineHeight: 20)
        }
    }
}
