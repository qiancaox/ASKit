//  VerifyCodeTextField.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit
import ASCore
import SnapKit

/// Coding character apperance style.
@objc
public enum CodingApperanceStyle: Int {
    // Box frame style
    case frame = 0
    // Underline
    case underline
}

// MARK: - CharacterLabel

fileprivate class CharacterLabel: UILabel {
    
    /// Is on focused state.
    private var isOnFocus: Bool = false
    /// Is label have text.
    private var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    /// Apperance style.
    private let style: CodingApperanceStyle
    
    /// Color of normal state.
    var normalColor: UIColor = UIColor.systemGray
    /// Color of on focused state.
    var focusedColor: UIColor = UIColor.systemBlue {
        didSet {
            textColor = focusedColor
        }
    }
    /// Only init when style is underline.
    let underlineView: UIView?
    /// Underline size, only effect when underline style.
    var underlineSize: CGSize = CGSize(width: 20, height: 1) {
        didSet {
            if style == .underline {
                underlineView?.snp.updateConstraints {
                    $0.size.equalTo(underlineSize)
                }
            }
        }
    }
    
    init(_ style: CodingApperanceStyle) {
        self.style = style
        if style == .underline {
            underlineView = UIView()
            underlineView?.backgroundColor = .systemGray
        } else {
            underlineView = nil
        }
        
        super.init(frame: .zero)
        textAlignment = .center
        textColor = focusedColor
        
        if style == .underline {
            addSubview(underlineView!)
            underlineView?.snp.makeConstraints { [weak self] in
                $0.size.equalTo(self?.underlineSize ?? .zero)
                $0.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
        } else {
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update Apparence
    
    func updateOnFocus(_ onFocus: Bool) {
        isOnFocus = onFocus
        updateApparence()
    }
    
    private func updateApparence() {
        if isEmpty {
            isOnFocus ? setDisplayToFocusedOrUnempty() : setDisplayToNormalEmpty()
        } else {
            setDisplayToFocusedOrUnempty()
        }
    }
    
    private func setDisplayToFocusedOrUnempty() {
        if style == .underline {
            underlineView?.backgroundColor = focusedColor
        } else {
            layer.borderColor = focusedColor.cgColor
        }
    }
    
    private func setDisplayToNormalEmpty() {
        if style == .underline {
            underlineView?.backgroundColor = normalColor
        } else {
            layer.borderColor = normalColor.cgColor
        }
    }
    
}

// MARK: - Verify Code TextField

final public class VerifyCodeTextField: UITextField {
    
    /// Tag of adding character labels.
    private var isAddingCharacterLabels: Bool = false
    /// Hold all character labels.
    private var characterLabels = [CharacterLabel] ()
    /// Code digits.
    @IBInspectable private var digits: Int = 6
    /// Code digits display style. Defaults to `frame`.
    @IBInspectable private var style: CodingApperanceStyle = .frame
    
    /// Space between code character labels.
    @IBInspectable public var spacing: CGFloat = 10 {
        didSet { setNeedsUpdateConstraints() }
    }
    /// The corner radius of code when `frame` style.
    @IBInspectable public var borderRadius: CGFloat = 4 {
        didSet { characterLabels.forEach { $0.layer.cornerRadius = borderRadius } }
    }
    /// The color of not filled code state.
    @IBInspectable public var color: UIColor = UIColor.black {
        didSet { characterLabels.forEach { $0.normalColor = color } }
    }
    /// The color of filled code and on focus state.
    @IBInspectable public var filledColor: UIColor = UIColor.systemBlue {
        didSet {
            tintColor = filledColor
            characterLabels.forEach { $0.focusedColor = filledColor }
        }
    }
    /// Underline size, only effect when underline style.
    @IBInspectable public var underlineSize: CGSize = CGSize(width: 20, height: 1) {
        didSet { characterLabels.forEach { $0.underlineSize = underlineSize } }
    }
    
    public override var font: UIFont? {
        didSet { characterLabels.forEach { $0.font = font } }
    }
    
    // MARK: - Initialize
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    public init(_ digits: Int, style: CodingApperanceStyle) {
        super.init(frame: .zero)
        autocorrectionType = .no
        autocapitalizationType = .none
        self.digits = digits
        self.style = style
        addCharacterLabelsIfNeeded()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    // MARK: - View
    
    /// Add character labels when load from xib.
    public override func awakeFromNib() {
        super.awakeFromNib()
        addCharacterLabelsIfNeeded()
    }
    
    /// Add character labels when digits more than zero and haven not added labels.
    private func addCharacterLabelsIfNeeded() {
        if isAddingCharacterLabels && digits > 0 {
            return
        }
        isAddingCharacterLabels = true
        
        // Add labels.
        for _ in 0..<digits {
            let label = CharacterLabel(style)
            label.font = font
            label.normalColor = color
            label.focusedColor = filledColor
            label.layer.cornerRadius = borderRadius
            addSubview(label)
            characterLabels.append(label)
        }
        
        // Add action for editing changed.
        addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - Layout
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 50.0 * CGFloat(digits) + spacing * CGFloat(digits - 1),
                      height: 50)
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        // Remove added constraints.
        characterLabels.forEach { $0.snp.removeConstraints() }
        
        // Update constraints.
        var behindLabel: CharacterLabel!
        let space = spacing
        let count = digits
        let widthOffset = space * CGFloat(count - 1) / CGFloat(count)
        for idx in 0..<digits {
            let label = characterLabels[safe: idx]
            label?.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                if idx == 0 {
                    $0.left.equalToSuperview()
                } else {
                    $0.left.equalTo(behindLabel.snp.right)
                        .offset(space)
                }
                $0.width.equalToSuperview()
                    .offset(-widthOffset)
                    .dividedBy(count)
            }
            behindLabel = label
        }
    }
    
    // MARK: - Functions To Customize TextField
    
    /// Caret only at the end of document.
    public override var selectedTextRange: UITextRange? {
        get { super.selectedTextRange }
        set { super.selectedTextRange = textRange(from: endOfDocument, to: endOfDocument) }
    }
    
    /// Caret rect at end of document.
    public override func caretRect(for position: UITextPosition) -> CGRect {
        let rect = super.caretRect(for: position)
        let count = text?.count ?? 0
        guard let labelWithCaret = characterLabels[safe: count] else {
            return rect
        }
        var caretRect = labelWithCaret.frame
        caretRect.size = rect.size
        caretRect.origin.y = labelWithCaret.center.y - rect.height / 2
        caretRect.origin.x = labelWithCaret.center.x - rect.width / 2
        return caretRect
    }
    
    /// Can't using paste, select and selectAll functions.
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    /// Hide border.
    public override func borderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    /// Hide text.
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    /// Hide placeholder.
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    // MARK: - Update Focus When User Operated
    
    public override func becomeFirstResponder() -> Bool {
        defer { updateLabels() }
        return super.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        defer { updateLabels() }
        return super.resignFirstResponder()
    }
    
    // MARK: - Functions
    
    private func updateLabels() {
        let count = min(digits, text?.count ?? 0)
        for idx in 0..<digits {
            let label = characterLabels[idx]
            if idx < count { // Label behind focused label.
                label.text = text![idx]
                label.updateOnFocus(true)
            } else if idx == count { // Label on focus.
                if isEditing {
                    label.text = ""
                    label.updateOnFocus(true)
                } else {
                    label.updateOnFocus(false)
                }
            } else { // Label after focused label.
                label.text = ""
                label.updateOnFocus(false)
            }
        }
    }
    
    // MARK: - Editing Changed
    
    @objc
    final public func editingChanged(_ sender: VerifyCodeTextField) {
        // Limit input text digits.
        if text?.count ?? 0 > digits {
            text = text![0..<digits]
        }
        
        // Update labels.
        updateLabels()
    }
    
}
