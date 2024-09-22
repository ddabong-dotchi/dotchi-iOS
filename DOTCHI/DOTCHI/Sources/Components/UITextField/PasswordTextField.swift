//
//  PasswordTextField.swift
//  DOTCHI
//
//  Created by KimYuBin on 9/8/24.
//

import UIKit

final class PasswordTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
        setRightView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
        setRightView()
    }
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func configureTextField() {
        self.isSecureTextEntry = true
        self.textColor = .dotchiWhite
        self.font = .sub
        self.backgroundColor = .dotchiMgray
        self.tintColor = UITextField().tintColor
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.addLeftPadding(12)
    }
    
    func setPlaceholder(text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.dotchiLgray,
            NSAttributedString.Key.font: UIFont.sub
        ]
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
    
    private func setRightView() {
        let containerView = UIView()
        containerView.addSubview(infoImageView)
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(39)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        self.rightView = containerView
        self.rightViewMode = .always
    }
    
    func updateRightImageView(image: UIImage?, tintColor: UIColor?) {
        infoImageView.image = image
        infoImageView.tintColor = tintColor
        infoImageView.isHidden = image == nil
    }
}
