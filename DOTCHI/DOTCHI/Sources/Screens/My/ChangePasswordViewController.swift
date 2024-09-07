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
    private let newPasswordTextField = UITextField()
    private let newPasswordWarningLabel = UILabel()
    private let newPasswordInfoImageView = UIImageView()
    private let confirmPasswordTextField = UITextField()
    private let confirmPasswordWarningLabel = UILabel()
    private let confirmPasswordInfoImageView = UIImageView()
    private let currentPasswordLabel = UILabel()
    private let currentPasswordTextField = UITextField()
    private let currentPasswordWarningLabel = UILabel()
    private let currentPasswordInfoImageView = UIImageView()
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
        
        confirmPasswordWarningLabel.text = "비밀번호가 일치하지 않습니다"
        confirmPasswordWarningLabel.textColor = .dotchiOrange
        confirmPasswordWarningLabel.font = .sSub
        confirmPasswordWarningLabel.isHidden = true
        
        currentPasswordLabel.text = "현재 비밀번호"
        currentPasswordLabel.textColor = .dotchiWhite
        currentPasswordLabel.font = .sub
        
        currentPasswordTextField.isSecureTextEntry = true
        currentPasswordTextField.textColor = .dotchiWhite
        currentPasswordTextField.font = .sub
        currentPasswordTextField.backgroundColor = .dotchiMgray
        currentPasswordTextField.tintColor = UITextField().tintColor
        currentPasswordTextField.layer.cornerRadius = 8
        currentPasswordTextField.layer.borderWidth = 1
        currentPasswordTextField.setLeftPadding(12)
        
        currentPasswordTextField.attributedPlaceholder = NSAttributedString(string: "현재 비밀번호", attributes: attributes)
        currentPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        let currentPasswordContainerView = UIView()
        currentPasswordContainerView.addSubview(currentPasswordInfoImageView)
        
        currentPasswordContainerView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(39)
        }
        
        currentPasswordInfoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        currentPasswordTextField.rightView = currentPasswordContainerView
        currentPasswordTextField.rightViewMode = .always
        
        currentPasswordWarningLabel.text = "비밀번호가 일치하지 않습니다"
        currentPasswordWarningLabel.textColor = .dotchiOrange
        currentPasswordWarningLabel.font = .sSub
        currentPasswordWarningLabel.isHidden = true
        
        forgetPasswordStackView.axis = .horizontal
        forgetPasswordStackView.spacing = 3
        forgetPasswordStackView.alignment = .top
        forgetPasswordStackView.addArrangedSubviews([forgetPasswordInfoLabel, contactButton])
        
        forgetPasswordInfoLabel.text = "비밀번호를 잊으셨나요?"
        forgetPasswordInfoLabel.textColor = .dotchiWhite50
        forgetPasswordInfoLabel.font = .sub
        
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
    
    private func handleCurrentPasswordTextFieldChange(_ newText: String) {
        currentPasswordTextField.layer.borderColor = verifyCurrentPassword() ? UIColor.clear.cgColor : UIColor.dotchiOrange.cgColor
        currentPasswordWarningLabel.isHidden = verifyCurrentPassword()
        currentPasswordWarningLabel.text = verifyCurrentPassword() ? "" : "비밀번호가 일치하지 않습니다"
        
        currentPasswordInfoImageView.image = verifyCurrentPassword() ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "info.circle")
        currentPasswordInfoImageView.tintColor = verifyCurrentPassword() ? .dotchiGreen : .dotchiOrange
        currentPasswordInfoImageView.isHidden = false
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

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
