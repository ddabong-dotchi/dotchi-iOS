//
//  ChangePasswordViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 8/30/24.
//

import UIKit

class ChangePasswordViewController: BaseViewController, UITextFieldDelegate {
    private let navigationView = DotchiNavigationView(type: .closeCenterTitle)
    
    private let newPasswordLabel = UILabel()
    private let newPasswordTextField = UITextField()
    private let newPasswordWarningLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    private let confirmPasswordWarningLabel = UILabel()
    private let newPasswordInfoImageView = UIImageView()
    private let confirmPasswordInfoImageView = UIImageView()
    private let currentPasswordLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.dotchiScreenBackground
        
        setupSubviews()
        setupConstraints()
        fetchMyData()
        
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    private func setupSubviews() {
        self.view.addSubviews([
            navigationView,
            newPasswordLabel,
            newPasswordTextField,
            newPasswordWarningLabel,
            confirmPasswordTextField,
            confirmPasswordWarningLabel,
            currentPasswordLabel
        ])
        
        navigationView.centerTitleLabel.text = "비밀번호 변경"
        
        newPasswordLabel.text = "새 비밀번호"
        newPasswordLabel.textColor = .dotchiWhite
        newPasswordLabel.font = .sub
        
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.textColor = .dotchiWhite
        newPasswordTextField.font = .sub
        newPasswordTextField.backgroundColor = .dotchiMgray
        newPasswordTextField.tintColor = UITextField().tintColor
        newPasswordTextField.layer.cornerRadius = 8
        newPasswordTextField.layer.borderWidth = 1
        newPasswordTextField.setLeftPadding(12)
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.dotchiLgray,
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "새 비밀번호(최소 10자 이상)", attributes: attributes)
        newPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        newPasswordInfoImageView.tintColor = .dotchiOrange
        newPasswordInfoImageView.contentMode = .scaleAspectFit
        newPasswordInfoImageView.isHidden = true
        
        let newPasswordcontainerView = UIView()
        newPasswordcontainerView.addSubview(newPasswordInfoImageView)
        
        newPasswordcontainerView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(39)
        }
        
        newPasswordInfoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        newPasswordTextField.rightView = newPasswordcontainerView
        newPasswordTextField.rightViewMode = .always
        
        newPasswordWarningLabel.text = "10자 이상 입력하세요"
        newPasswordWarningLabel.textColor = .dotchiOrange
        newPasswordWarningLabel.font = .sSub
        newPasswordWarningLabel.isHidden = true
        
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.textColor = .dotchiWhite
        confirmPasswordTextField.font = .sub
        confirmPasswordTextField.backgroundColor = .dotchiMgray
        confirmPasswordTextField.tintColor = UITextField().tintColor
        confirmPasswordTextField.layer.cornerRadius = 8
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.setLeftPadding(12)
        
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "새 비밀번호 확인(최소 10자 이상)", attributes: attributes)
        confirmPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        confirmPasswordWarningLabel.text = "비밀번호가 일치하지 않습니다"
        confirmPasswordWarningLabel.textColor = .dotchiOrange
        confirmPasswordWarningLabel.font = .sSub
        confirmPasswordWarningLabel.isHidden = true
        
        let confirmPasswordContainerView = UIView()
        confirmPasswordContainerView.addSubview(confirmPasswordInfoImageView)
        
        confirmPasswordContainerView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(39)
        }
        
        confirmPasswordInfoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        confirmPasswordTextField.rightView = confirmPasswordContainerView
        confirmPasswordTextField.rightViewMode = .always
        
        currentPasswordLabel.text = "현재 비밀번호"
        currentPasswordLabel.textColor = .dotchiWhite
        currentPasswordLabel.font = .sub
    }
    
    // MARK: - Button Actions
    
    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        if textField == newPasswordTextField {
            handleNewPasswordTextFieldChange(newPasswordTextField.text ?? "")
            handleConfirmPasswordTextFieldChange(confirmPasswordTextField.text ?? "")
        } else if textField == confirmPasswordTextField {
            handleConfirmPasswordTextFieldChange(confirmPasswordTextField.text ?? "")
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    private func handleNewPasswordTextFieldChange(_ newText: String) {
        let isWarningVisible = newText.count < 10
        newPasswordTextField.layer.borderColor = isWarningVisible ? UIColor.dotchiOrange.cgColor : UIColor.clear.cgColor
        newPasswordWarningLabel.isHidden = !isWarningVisible
        
        if isWarningVisible {
            newPasswordInfoImageView.image = UIImage(systemName: "info.circle")
            newPasswordInfoImageView.tintColor = .dotchiOrange
        } else {
            newPasswordInfoImageView.image = UIImage(systemName: "checkmark.circle")
            newPasswordInfoImageView.tintColor = .dotchiGreen
        }
        
        newPasswordInfoImageView.isHidden = false
        updateWarningLabelConstraints(isWarningVisible: isWarningVisible)
    }
    
    private func handleConfirmPasswordTextFieldChange(_ newText: String) {
        let newPassword = newPasswordTextField.text ?? ""
        let isMatch = newPassword == newText
        let isWarningVisible = newText.count < 10 || !isMatch
        
        confirmPasswordTextField.layer.borderColor = isWarningVisible ? UIColor.dotchiOrange.cgColor : UIColor.clear.cgColor
        confirmPasswordWarningLabel.isHidden = isMatch
        
        if isWarningVisible {
            confirmPasswordInfoImageView.image = UIImage(systemName: "info.circle")
            confirmPasswordInfoImageView.tintColor = .dotchiOrange
        } else {
            confirmPasswordInfoImageView.image = UIImage(systemName: "checkmark.circle")
            confirmPasswordInfoImageView.tintColor = .dotchiGreen
        }
        
        confirmPasswordInfoImageView.isHidden = false
        updateWarningLabelConstraints(isWarningVisible: isWarningVisible, forConfirmPassword: true)
    }
    
    private func updateWarningLabelConstraints(isWarningVisible: Bool, forConfirmPassword: Bool = false) {
        UIView.animate(withDuration: 0.3) {
            if forConfirmPassword {
                self.confirmPasswordTextField.snp.remakeConstraints { make in
                    let offset = isWarningVisible ? 16 : 10
                    make.top.equalTo(self.newPasswordWarningLabel.isHidden ? self.newPasswordTextField.snp.bottom : self.newPasswordWarningLabel.snp.bottom).offset(offset)
                    make.leading.trailing.equalToSuperview().inset(28)
                    make.height.equalTo(48)
                }
                
                self.confirmPasswordWarningLabel.snp.remakeConstraints { make in
                    make.top.equalTo(self.confirmPasswordTextField.snp.bottom).offset(8)
                    make.leading.trailing.equalToSuperview().inset(28)
                }
                
                self.confirmPasswordWarningLabel.isHidden = !isWarningVisible
            } else {
                self.newPasswordTextField.snp.remakeConstraints { make in
                    let offset = isWarningVisible ? 16 : 10
                    make.top.equalTo(self.newPasswordLabel.snp.bottom).offset(16)
                    make.leading.trailing.equalToSuperview().inset(28)
                    make.height.equalTo(48)
                }
                
                self.newPasswordWarningLabel.snp.remakeConstraints { make in
                    make.top.equalTo(self.newPasswordTextField.snp.bottom).offset(8)
                    make.leading.trailing.equalToSuperview().inset(28)
                }
                
                self.confirmPasswordTextField.snp.remakeConstraints { make in
                    let offset = isWarningVisible ? 16 : 10
                    make.top.equalTo(self.newPasswordWarningLabel.isHidden ? self.newPasswordTextField.snp.bottom : self.newPasswordWarningLabel.snp.bottom).offset(offset)
                    make.leading.trailing.equalToSuperview().inset(28)
                    make.height.equalTo(48)
                }
                
                self.confirmPasswordWarningLabel.isHidden = true
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(48)
        }
        
        newPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
        
        newPasswordWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(-2)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(0)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordWarningLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
        
        confirmPasswordWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        currentPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordWarningLabel).offset(33)
            make.leading.trailing.equalToSuperview().inset(28)
        }
    }
    
    // MARK: - Network
    
    private func fetchMyData() {
        
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
