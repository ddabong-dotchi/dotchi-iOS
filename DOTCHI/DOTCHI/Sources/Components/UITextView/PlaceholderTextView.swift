//
//  PlaceholderTextView.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 8/25/24.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
        }
    }
    
    var placeholderFont: UIFont? {
        didSet {
            placeholderLabel.font = placeholderFont
            setNeedsLayout()
        }
    }
    
    var placeholderTextColor: UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
            setNeedsLayout()
        }
    }
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        addSubview(placeholderLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + 5, y: textContainerInset.top)
        placeholderLabel.frame.size.width = frame.width - (textContainerInset.left + textContainerInset.right + 10)
        placeholderLabel.sizeToFit()
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
