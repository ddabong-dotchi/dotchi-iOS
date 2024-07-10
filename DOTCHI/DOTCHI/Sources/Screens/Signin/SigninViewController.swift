//
//  SigninViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SigninViewController: BaseViewController {
    
    private enum Text {
        static let title = "따봉도치야 고마워!"
        static let subTitle = "나만의 따봉도치를 만나요"
        static let signupInfo = "회원이 아니신가요?"
        static let signup = "회원가입하기"
        static let usernamePlaceholder = "아이디를 입력해 주세요"
        static let passwordPlaceholder = "비밀번호를 입력해 주세요"
        static let signin = "로그인하기"
        static let forgetPassword = "비밀번호를 잊으셨나요?"
        static let contact = "문의하기"
    }
    
    // MARK: UIComponents
    
    private let logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: .imgDotchiSquareLogo)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.title
        label.setStyle(.title, .dotchiGreen)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.subTitle
        label.setStyle(.title, .dotchiWhite)
        return label
    }()
    
    private let signupInfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.signupInfo
        label.setStyle(.sub, .dotchiWhite50)
        return label
    }()
    
    private let signupButton: TextUnderlineButtonUIView = TextUnderlineButtonUIView(title: Text.signup)
    
    private let usernameTextField: SigninUITextField = {
        let textField: SigninUITextField = SigninUITextField()
        textField.setDotchiPlaceholder(Text.usernamePlaceholder)
        textField.textContentType = .username
        textField.returnKeyType = .next
        return textField
    }()
    
    private let passwordTextField: SigninUITextField = {
        let textField: SigninUITextField = SigninUITextField()
        textField.setDotchiPlaceholder(Text.passwordPlaceholder)
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    private let signinButton: DoneUIButton = {
        let button: DoneUIButton = DoneUIButton(type: .system)
        button.setTitle(Text.signin, for: .normal)
        return button
    }()
    
    private let contactStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.spacing = 3
        stackView.alignment = .top
        return stackView
    }()
    
    private let forgetPasswordInfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.forgetPassword
        label.setStyle(.sub, .dotchiWhite50)
        return label
    }()
    
    private let contactButton: TextUnderlineButtonUIView = TextUnderlineButtonUIView(title: Text.contact)
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var isSigninButtonEnable: [Bool] = [false, false] {
        didSet {
            self.signinButton.isEnabled = self.isSigninButtonEnable[0]
                && self.isSigninButtonEnable[1]
        }
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setTextField()
        self.setSignupButtonAction()
        self.setContactButtonAction()
        self.setSigninButtonAction()
    }
    
    // MARK: Methods
    
    private func setTextField() {
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.usernameTextField.rx.text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, changedText in
                owner.isSigninButtonEnable[0] = changedText.count >= 5
            })
            .disposed(by: self.disposeBag)
        
        self.passwordTextField.rx.text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, changedText in
                owner.isSigninButtonEnable[1] = changedText.count >= 10
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setSignupButtonAction() {
        self.signupButton.button.setAction {
            self.present(BaseUINavigationController(rootViewController: SignupUserInfoViewController()), animated: true)
        }
    }
    
    private func setContactButtonAction() {
        self.contactButton.button.setAction {
            self.sendForgetPasswordMail()
        }
    }
    
    private func setSigninButtonAction() {
        self.signinButton.setAction {
            if let username = self.usernameTextField.text,
            let password = self.passwordTextField.text {
                let data: SigninRequestDTO = .init(username: username, password: password)
                self.requestSignin(data: data) { response in
                    self.setUserInfo(data: response)
                    self.setSigninDataToKeychain(username: username, password: password)
                    self.presentHomeViewController()
                }
            }
        }
    }
    
    private func presentHomeViewController() {
        self.present(DotchiUITabBarController(), animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SigninViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.passwordTextField.endEditing(true)
        }
    }
}

// MARK: - Network

extension SigninViewController {
    
    private func requestSignin(data: SigninRequestDTO, completion: @escaping (SigninResponseDTO) -> (Void)) {
        AuthService.shared.requestSignin(data: data) { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? SigninResponseDTO {
                    completion(result)
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
}

// MARK: - Layout

extension SigninViewController {
    private func setLayout() {
        self.contactStackView.addArrangedSubviews([forgetPasswordInfoLabel, contactButton])
        
        self.view.addSubviews([logoImageView, titleLabel, subTitleLabel, signupInfoLabel, signupButton, usernameTextField, passwordTextField, signinButton, contactStackView])
        
        self.logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(193.adjustedH)
            make.left.equalToSuperview().inset(32)
            make.width.height.equalTo(48)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.logoImageView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(28)
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(28)
        }
        
        self.signupInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(34)
            make.height.equalTo(14)
        }
        
        self.signupButton.snp.makeConstraints { make in
            make.top.equalTo(self.signupInfoLabel)
            make.left.equalTo(self.signupInfoLabel.snp.right).offset(3)
            make.height.equalTo(16)
        }
        
        self.usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.signupInfoLabel.snp.bottom).offset(56)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
        
        self.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.usernameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
        
        self.signinButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(52)
        }
        
        self.contactStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.signinButton.snp.top).offset(-18)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        
        self.forgetPasswordInfoLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
        
        self.contactButton.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
    }
}
