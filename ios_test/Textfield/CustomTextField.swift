//
// Copyright © 2022 Monvel LTD. All rights reserved.
//
// Created by Mike Karpenko
//

import UIKit

protocol CustomTextDelegate: AnyObject {
    func textDidChange(from: String?, to: String?)
}

final class CustomTextField: UITextField {
    weak var customDelegate: CustomTextDelegate?

    override var placeholder: String? {
        didSet {
            attributedPlaceholder = .body.text(placeholder)
        }
    }

    override var text: String? {
        didSet {
            if oldValue != text {
                customDelegate?.textDidChange(from: oldValue, to: text)
            }
        }
    }

    var isAnyActionAvailable = true

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard self.isAnyActionAvailable else { return false }
        return super.canPerformAction(action, withSender: sender)
    }
}
