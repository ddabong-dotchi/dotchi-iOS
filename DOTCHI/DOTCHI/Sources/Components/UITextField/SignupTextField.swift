//
//  SignupTextField.swift
//  DOTCHI
//
//  Created by Jungbin on 7/31/24.
//

import UIKit
import SnapKit

final class SignupTextField: UITextField {
    
    enum TextFieldType {
        case username
        case password
    }
    
    // MARK: Properties
    
    private lazy var showButton = IconButton(normalIcon: .iconEyeOpen, selectedIcon: .iconEyeClose)
    
    // MARK: Initializer
    
    init(type: TextFieldType) {
        super.init(frame: .zero)
        
        self.setUI(type: type)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI(type: TextFieldType) {
        self.backgroundColor = .dotchiMgray
        self.font = .sub
        self.textColor = .dotchiLgray
        self.addLeftPadding(12)
        self.addRightPadding(12)
        self.makeRounded(cornerRadius: 8)
        self.returnKeyType = .done
        
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.keyboardType = .default
        self.clearButtonMode = .whileEditing
        
        switch type {
        case .username:
            self.textContentType = .username
        case .password:
            self.textContentType = .password
            self.isSecureTextEntry = true
            self.setShowButton()
        }
    }
    
    func setBorderColor(isCorrect: Bool) {
        self.layer.borderWidth = 1
        self.layer.borderColor = isCorrect ? UIColor.dotchiGreen.cgColor : UIColor.dotchiOrange.cgColor
    }
    
    func removeBorderColor() {
        self.layer.borderWidth = 0
    }
    
    private func setShowButton() {
        self.addSubview(showButton)
        
        self.showButton.snp.makeConstraints { make in
            make.verticalEdges.right.equalToSuperview()
            make.width.equalTo(48)
        }
        
        self.showButton.setAction {
            self.showButton.isSelected.toggle()
            self.isSecureTextEntry = !self.showButton.isSelected
        }
    }
}
