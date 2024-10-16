//
//  ChangePasswordViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 8/30/24.
//

import UIKit

class ChangePasswordViewController: BaseViewController, UITextFieldDelegate {
    private let userService = UserService.shared
    
    private let navigationView = DotchiNavigationView(type: .closeCenterTitle)
    private let newPasswordLabel = UILabel()
    private let newPasswordTextField = PasswordTextField()
    private let newPasswordWarningLabel = UILabel()
    private let confirmPasswordTextField = PasswordTextField()
    private let confirmPasswordWarningLabel = UILabel()
    private let currentPasswordLabel = UILabel()
    private let currentPasswordTextField = PasswordTextField()
    private let currentPasswordWarningLabel = UILabel()
    private let forgetPasswordStackView = UIStackView()
    private let forgetPasswordInfoLabel = UILabel()
    private let contactButton: TextUnderlineButtonView = TextUnderlineButtonView(title: "문의하기")
    private let changePasswordButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.dotchiScreenBackground
        
        setupSubviews()
        setupConstraints()
        
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        currentPasswordTextField.delegate = self
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
            currentPasswordLabel,
            currentPasswordTextField,
            currentPasswordWarningLabel,
            forgetPasswordStackView,
            changePasswordButton
        ])
        
        navigationView.centerTitleLabel.text = "비밀번호 변경"
        
        newPasswordLabel.text = "새 비밀번호"
        newPasswordLabel.setStyle(.sub, .dotchiWhite)
        
        newPasswordTextField.setPlaceholder(text: "새 비밀번호(최소 10자 이상)")
        newPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        newPasswordWarningLabel.text = "10자 이상 입력하세요"
        newPasswordWarningLabel.setStyle(.sSub, .dotchiOrange)
        newPasswordWarningLabel.isHidden = true
        
        confirmPasswordTextField.setPlaceholder(text: "새 비밀번호 확인(최소 10자 이상)")
        confirmPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        confirmPasswordWarningLabel.text = "비밀번호가 일치하지 않습니다"
        confirmPasswordWarningLabel.setStyle(.sSub, .dotchiOrange)
        confirmPasswordWarningLabel.isHidden = true
        
        currentPasswordLabel.text = "현재 비밀번호"
        currentPasswordLabel.setStyle(.sub, .dotchiWhite)
        
        currentPasswordTextField.setPlaceholder(text: "현재 비밀번호")
        currentPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        currentPasswordWarningLabel.text = "비밀번호가 일치하지 않습니다"
        currentPasswordWarningLabel.setStyle(.sSub, .dotchiOrange)
        currentPasswordWarningLabel.isHidden = true
        
        forgetPasswordStackView.axis = .horizontal
        forgetPasswordStackView.spacing = 3
        forgetPasswordStackView.alignment = .top
        forgetPasswordStackView.addArrangedSubviews([forgetPasswordInfoLabel, contactButton])
        
        forgetPasswordInfoLabel.text = "비밀번호를 잊으셨나요?"
        forgetPasswordInfoLabel.setStyle(.sub, .dotchiWhite50)
        
        contactButton.button.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
        
        changePasswordButton.setTitle("비밀번호 변경", for: .normal)
        changePasswordButton.titleLabel?.font = .head2
        changePasswordButton.layer.cornerRadius = 8
        changePasswordButton.isEnabled = false
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        updateChangePasswordButtonState()
    }
    
    // MARK: - Button Actions
    
    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        if textField == newPasswordTextField {
            handleNewPasswordTextFieldChange(newPasswordTextField.text ?? "")
            handleConfirmPasswordTextFieldChange(confirmPasswordTextField.text ?? "")
        } else if textField == confirmPasswordTextField {
            handleConfirmPasswordTextFieldChange(confirmPasswordTextField.text ?? "")
        } else if textField == currentPasswordTextField {
            handleCurrentPasswordTextFieldChange(currentPasswordTextField.text ?? "")
        }
        
        updateChangePasswordButtonState()
    }
    
    @objc private func changePasswordButtonTapped() {
        userService.changePassword(data: newPasswordTextField.text ?? "") { result in
            switch result {
            case .success:
                self.updatePasswordInKeychain(newPassword: self.newPasswordTextField.text ?? "")
                self.dismiss(animated: true, completion: nil)
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    @objc private func contactButtonTapped() {
        self.sendForgetPasswordMail()
    }
    
    // MARK: - UITextFieldDelegate
    
    private func handleNewPasswordTextFieldChange(_ newText: String) {
        let isWarningVisible = newText.count < 10
        newPasswordTextField.layer.borderColor = isWarningVisible ? UIColor.dotchiOrange.cgColor : UIColor.clear.cgColor
        newPasswordWarningLabel.isHidden = !isWarningVisible
        
        let image = UIImage(systemName: isWarningVisible ? "info.circle" : "checkmark.circle")
        let tintColor = isWarningVisible ? UIColor.dotchiOrange : UIColor.dotchiGreen
        newPasswordTextField.updateRightImageView(image: image, tintColor: tintColor)
        
        updateWarningLabelConstraints(isWarningVisible: isWarningVisible)
    }
    
    private func handleConfirmPasswordTextFieldChange(_ newText: String) {
        let newPassword = newPasswordTextField.text ?? ""
        let isMatch = newPassword == newText
        let isWarningVisible = newText.count < 10 || !isMatch
        
        confirmPasswordTextField.layer.borderColor = isWarningVisible ? UIColor.dotchiOrange.cgColor : UIColor.clear.cgColor
        confirmPasswordWarningLabel.isHidden = isMatch
        
        let image = UIImage(systemName: isWarningVisible ? "info.circle" : "checkmark.circle")
        let tintColor = isWarningVisible ? UIColor.dotchiOrange : UIColor.dotchiGreen
        confirmPasswordTextField.updateRightImageView(image: image, tintColor: tintColor)
        
        updateWarningLabelConstraints(isWarningVisible: isWarningVisible, forConfirmPassword: true)
    }
    
    private func handleCurrentPasswordTextFieldChange(_ newText: String) {
        let isValid = verifyCurrentPassword()
        currentPasswordTextField.layer.borderColor = isValid ? UIColor.clear.cgColor : UIColor.dotchiOrange.cgColor
        currentPasswordWarningLabel.isHidden = isValid
        currentPasswordWarningLabel.text = isValid ? "" : "비밀번호가 일치하지 않습니다"
        
        let image = UIImage(systemName: isValid ? "checkmark.circle" : "info.circle")
        let tintColor = isValid ? UIColor.dotchiGreen : UIColor.dotchiOrange
        currentPasswordTextField.updateRightImageView(image: image, tintColor: tintColor)
    }
    
    private func verifyCurrentPassword() -> Bool {
        guard let savedPassword = getPasswordFromKeychain() else {
            currentPasswordWarningLabel.text = "비밀번호를 확인할 수 없습니다"
            currentPasswordWarningLabel.isHidden = false
            return false
        }
        
        let isValid = savedPassword == currentPasswordTextField.text
        return isValid
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
                    make.height.equalTo(isWarningVisible ? 20 : 0)
                }
                
                self.confirmPasswordWarningLabel.isHidden = !isWarningVisible
            } else {
                self.newPasswordTextField.snp.remakeConstraints { make in
                    make.top.equalTo(self.newPasswordLabel.snp.bottom).offset(16)
                    make.leading.trailing.equalToSuperview().inset(28)
                    make.height.equalTo(48)
                }
                
                self.newPasswordWarningLabel.snp.remakeConstraints { make in
                    make.top.equalTo(self.newPasswordTextField.snp.bottom).offset(isWarningVisible ? 8 : 0)
                    make.leading.trailing.equalToSuperview().inset(28)
                    make.height.equalTo(isWarningVisible ? 20 : 0)
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
    
    private func updateChangePasswordButtonState() {
        let isNewPasswordValid = newPasswordTextField.text?.count ?? 0 >= 10
        let isConfirmPasswordValid = confirmPasswordTextField.text == newPasswordTextField.text
        let isCurrentPasswordValid = verifyCurrentPassword()
        let isEnabled = isNewPasswordValid && isConfirmPasswordValid && isCurrentPasswordValid
        
        changePasswordButton.isEnabled = isEnabled
        changePasswordButton.backgroundColor = isEnabled ? .dotchiGreen : UIColor.dotchiGreen.withAlphaComponent(0.5)
        changePasswordButton.setTitleColor(isEnabled ? .dotchiWhite : UIColor.dotchiWhite.withAlphaComponent(0.5), for: .normal)
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
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(0)
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
            make.top.equalTo(confirmPasswordWarningLabel.snp.bottom).offset(33)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        currentPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
        
        currentPasswordWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        forgetPasswordStackView.snp.makeConstraints { make in
            make.bottom.equalTo(changePasswordButton.snp.top).offset(-32)
            make.centerX.equalToSuperview()
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).offset(-32)
            make.leading.equalTo(safeArea).offset(28)
            make.trailing.equalTo(safeArea).offset(-28)
            make.height.equalTo(52)
        }
    }
}
