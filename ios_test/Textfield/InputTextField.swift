//
//  InputTextField.swift
//  ios_test
//
//  Created by Mike Karpenko on 14.11.2022.
//

import SnapKit
import UIKit

protocol InputFocusDelegate: AnyObject {
    func didTap(_ field: UIView)
}

class InputTextField: UIView {
    // MARK: - Public properties

    public var prefixText: String? {
        didSet {
            prefixLabel.attributedText = .headline.text(prefixText)
            prefixLabel.isHidden = !hasPrefix
            updatePrefixStackViewVisibility()
        }
    }

    public var hintText: String? {
        didSet {
            setupBottomLabel(error: errorText, hint: hintText)
        }
    }

    public var errorText: String? {
        didSet {
            setupBottomLabel(error: errorText, hint: hintText)
        }
    }

    public var leftView: UIView? {
        willSet {
            leftView?.removeFromSuperview()
        }
        didSet {
            if let leftView {
                mainStackView.insertArrangedSubview(leftView, at: 0)
            }
        }
    }

    public var rightView: UIView? {
        willSet {
            rightView?.removeFromSuperview()
        }
        didSet {
            if let rightView {
                mainStackView.addArrangedSubview(rightView)
            }
        }
    }

    /// superview responsible for calling layoutIfNeeded upon inputfield's layout changes
    public weak var enclosingSuperview: UIView?
    public var shouldUpdate: ((String) -> Bool)?
    public var didUpdateText: ((String) -> Void)?
    public var didBeginEditing: (() -> Void)?
    public var didEndEditing: ((String) -> Void)?
    public var shouldReturn: (() -> Bool)?

    // MARK: - Private properties

    private let appearance = Appearance()
    private weak var delegate: InputFocusDelegate?
    private var bottomLabelHiddenConstraint: Constraint!
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = appearance.grey100
        label.font = .body
        return label
    }()

    private(set) lazy var textField: CustomTextField = {
        let tf = CustomTextField()
        tf.customDelegate = self
        tf.tintColor = appearance.cyanColor
        tf.textColor = appearance.grey30
        tf.clearButtonMode = .never
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(0, -2, 0)
        return tf
    }()

    private lazy var prefixLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = appearance.grey30
        lbl.isHidden = true
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()

    private lazy var textStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, prefixFieldStackView])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 0
        sv.isUserInteractionEnabled = false
        return sv
    }()

    private lazy var prefixFieldStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [prefixLabel, textField])
        sv.axis = .horizontal
        sv.spacing = 4
        sv.isHidden = true
        sv.isUserInteractionEnabled = false
        return sv
    }()

    private let clearButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "cross"), for: .normal)
        btn.tintColor = .lightGray
        btn.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        return btn
    }()

    private lazy var clearButtonContainer: UIView = {
        let view = UIView()
        view.addSubview(clearButton)
        view.isHidden = true
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [textStackView, clearButtonContainer])
        sv.axis = .horizontal
        sv.spacing = 16
        sv.isUserInteractionEnabled = false
        return sv
    }()

    private lazy var roundedContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = appearance.grey230.cgColor
        view.backgroundColor = appearance.grey255
        return view
    }()

    private lazy var footerLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .callout
        return lbl
    }()

    private var hasPrefix: Bool {
        prefixText?.isEmpty == false
    }

    private var isError: Bool {
        (errorText ?? String()).isEmpty == false
    }

    private var isEmpty: Bool {
        return textField.text?.isEmpty ?? true
    }

    // MARK: - Public methods

    override var isFirstResponder: Bool {
        return self.textField.isFirstResponder
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.isHidden = false
        clearButtonContainer.isHidden = isEmpty
        return self.textField.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        UIView.animate(withDuration: appearance.animationDuration) {
            self.textField.isHidden = self.isEmpty
            self.clearButtonContainer.isHidden = true
        }
        return self.textField.resignFirstResponder()
    }

    // MARK: - Initializations

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                if !clearButtonContainer.point(inside: convertedPoint, with: event),
                   isFirstResponder,
                   hitView == roundedContainerView {
                    if textField.text?.isEmpty == false {
                        return clearButton
                    } else {
                        return textField
                    }
                } else {
                    return hitView
                }
            }
        }
        return nil
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .clear
        addSubviews()
        makeConstraints()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        roundedContainerView.addGestureRecognizer(tapRecognizer)
    }

    private func addSubviews() {
        clearButtonContainer.addSubview(clearButton)
        roundedContainerView.addSubview(mainStackView)
        addSubview(roundedContainerView)
        addSubview(footerLabel)
    }

    private func makeConstraints() {
        clearButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.center.equalToSuperview()
        }
        clearButtonContainer.snp.makeConstraints { make in
            make.width.equalTo(clearButton.snp.width)
        }
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(appearance.verticalInset)
            make.leading.trailing.equalToSuperview().inset(appearance.sideInset)
        }
        roundedContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.width.equalToSuperview()
            make.height.equalTo(appearance.baseHeight)
        }
        footerLabel.snp.makeConstraints { make in
            make.top.equalTo(roundedContainerView.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(appearance.sideInset)
            bottomLabelHiddenConstraint = make.height.equalTo(0).constraint
            make.bottom.equalToSuperview()
        }
    }

    private func updateBordersColor() {
        if isError {
            roundedContainerView.layer.borderColor = appearance.redColor.cgColor
        } else if isFirstResponder {
            roundedContainerView.layer.borderColor = appearance.cyanColor.cgColor
        } else {
            roundedContainerView.layer.borderColor = appearance.grey230.cgColor
        }
    }

    @objc
    private func didTap() {
        delegate?.didTap(self)
        if !isFirstResponder {
            becomeFirstResponder()
        }
    }

    @objc
    private func clearPressed() {
        textField.text = nil
        clearButtonContainer.isHidden = true
        updateTextfieldFont()
    }

    private func setupBottomLabel(error: String?, hint: String?) {
        var text = String()
        if let err = error, !err.isEmpty {
            text = err
            footerLabel.textColor = appearance.redColor
        } else if let hint = hint {
            text = hint
            footerLabel.textColor = appearance.grey100
        }

        footerLabel.attributedText = .callout.text(text)
        updateBordersColor()

        UIView.animate(withDuration: appearance.animationDuration) {
            self.footerLabel.alpha = text.isEmpty ? 0.0 : 1.0
            text.isEmpty ? self.bottomLabelHiddenConstraint.activate() : self.bottomLabelHiddenConstraint.deactivate()
            self.enclosingSuperview?.layoutIfNeeded()
        }
    }

    private func updateTextfieldFont() {
        textField.attributedText = .headline.text(textField.text)
    }

    private func updatePrefixStackViewVisibility() {
        UIView.animate(withDuration: appearance.animationDuration) {
            if self.hasPrefix {
                self.titleLabel.attributedText = .callout.text(self.titleLabel.text)
                self.prefixFieldStackView.isHidden = false
            } else {
                if self.isEmpty {
                    self.prefixFieldStackView.isHidden = !self.textField.isFirstResponder
                    self.titleLabel.attributedText = self.textField.isFirstResponder ? .callout.text(self.titleLabel.text) : .body
                        .text(self.titleLabel.text)
                } else {
                    self.titleLabel.attributedText = .callout.text(self.titleLabel.text)
                    self.prefixFieldStackView.isHidden = false
                }
            }
            self.mainStackView.layoutIfNeeded()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateBordersColor()
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension InputTextField: UITextFieldDelegate, CustomTextDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        didBeginEditing?()
        updateBordersColor()
        clearButtonContainer.isHidden = isEmpty
        updateTextfieldFont()
        updatePrefixStackViewVisibility()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(textField.text ?? "")
        updateBordersColor()
        clearButtonContainer.isHidden = true
        textField.isHidden = isEmpty
        updatePrefixStackViewVisibility()
    }

    func textField(_: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        if let textRange = Range(range, in: currentText) {
            let nextText = currentText.replacingCharacters(
                in: textRange,
                with: string
            )
            let shouldUpdate = self.shouldUpdate?(nextText) ?? true
            return shouldUpdate
        }
        return true
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        return shouldReturn?() ?? true
    }

    @objc
    private func textFieldDidChanged(textfield: UITextField) {
        didUpdateText?(textField.text ?? "")
        clearButtonContainer.isHidden = isEmpty
        updateTextfieldFont()
    }

    // programmatic input change detection
    func textDidChange(from: String?, to: String?) {
        didUpdateText?(textField.text ?? "")
        clearButtonContainer.isHidden = isEmpty
        updateTextfieldFont()
    }
}

// MARK: - Appearance

extension InputTextField {
    struct Appearance {
        let cyanColor: UIColor = .cyan//Asset.Palette.aqua.color
        let grey30: UIColor = .black//Asset.Palette.grey30.color
        let grey230: UIColor = .lightGray//Asset.Palette.grey230.color
        let redColor: UIColor = .red//Asset.Palette.red.color
        let grey100: UIColor = .gray//Asset.Palette.grey100.color
        let grey255: UIColor = .white//Asset.Palette.grey255.color
        let animationDuration: CGFloat = 0.3
        let sideInset: CGFloat = 16
        let verticalInset: CGFloat = 6
        let baseHeight: CGFloat = 56
    }
}
