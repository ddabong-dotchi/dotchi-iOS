//
//  SignupUserInfoViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignupUserInfoViewController: BaseViewController {
    
    private enum Text {
        static let usernameTitle = "아이디"
        static let usernameDescription = "한글, 영어, 숫자만 가능하며 3자 이상 입력해 주세요."
        static let passwordTitle = "비밀번호"
        static let passwordDescription = "영어, 숫자만 가능하며 10자 이상 입력해 주세요."
        static let checkDuplicate = "중복확인"
        static let duplicatedUsername = "중복된 아이디입니다."
        static let uniqueUsername = "사용 가능한 아이디입니다."
        static let next = "다음"
    }
    
    // MARK: UIComponents
    
    private let navigationView: DotchiNavigationView = DotchiNavigationView(type: .close)
    
    private let progressBarView = ProgressBarView()
    
    private let usernameTitleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.usernameTitle
        return label
    }()
    
    private let usernameDescriptionLabel = {
        let label = UILabel()
        label.font = .subSbold
        label.textColor = .dotchiLgray
        label.text = Text.usernameDescription
        return label
    }()
    
    private let usernameTextField = SignupTextField(type: .username)
    
    private let usernameDuplicateButton = {
        let button: DoneButton = DoneButton()
        button.setTitle(Text.checkDuplicate, for: .normal)
        return button
    }()
    
    private let usernameStatusLabel = StatusLabel(warningText: Text.duplicatedUsername, successText: Text.uniqueUsername)
    
    private let passwordTitleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.passwordTitle
        return label
    }()
    
    private let passwordDescriptionLabel = {
        let label = UILabel()
        label.font = .subSbold
        label.textColor = .dotchiLgray
        label.text = Text.passwordDescription
        return label
    }()
    
    private let passwordTextField = SignupTextField(type: .password)
    
    private let termsLabel = TermsLabel()
    
    private let nextButton: DoneButton = {
        let button: DoneButton = DoneButton(type: .system)
        button.setTitle(Text.next, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private var isNextButtonEnabled = [false, false] {
        didSet {
            self.nextButton.isEnabled = self.isNextButtonEnabled == [true, true]
        }
    }
    private var signupRequestData = SignupRequestDTO()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setTermsLabelAction()
        self.setDuplicateButtonAction()
        self.setUsernameTextField()
        self.setPasswordTextField()
        self.setNextButtonAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setUI()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.progressBarView.setProgress(step: .one)
    }
    
    private func setTermsLabelAction() {
        self.termsLabel.onTermsTap = {
            self.openSafariInApp(url: "https://www.google.com/search?q=이용약관")
        }
        
        self.termsLabel.onPrivacyTap = {
            self.openSafariInApp(url: "https://www.google.com/search?q=개인정보처리방침")
        }
    }
    
    private func setDuplicateButtonAction() {
        self.usernameDuplicateButton.setAction {
            self.requestCheckUsernameDuplicate(username: self.usernameTextField.text ?? "") { isDuplicated in
                self.usernameTextField.setBorderColor(isCorrect: !isDuplicated)
                self.isNextButtonEnabled[0] = !isDuplicated
                self.usernameStatusLabel.status = isDuplicated ? .warning : .success
            }
        }
    }
    
    private func setUsernameTextField() {
        self.usernameTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(self.usernameTextField.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.isNextButtonEnabled[0] = false
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setPasswordTextField() {
        self.passwordTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(self.passwordTextField.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.isNextButtonEnabled[1] = self?.isValidPassword(input: text) ?? false
            })
            .disposed(by: self.disposeBag)
    }
    
    private func isValidPassword(input: String) -> Bool {
        let pattern = "^(?=.*[A-Za-z0-9]).{10,}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: input.utf16.count)
        
        if let regex = regex {
            return regex.firstMatch(in: input, options: [], range: range) != nil
        }
        
        return false
    }
    
    private func setNextButtonAction() {
        self.nextButton.setAction {
            self.signupRequestData.username = self.usernameTextField.text ?? ""
            self.signupRequestData.password = self.passwordTextField.text ?? ""
            
            self.navigationController?.pushViewController(SignupNicknameViewController(signupRequestData: self.signupRequestData), animated: true)
        }
    }
}

// MARK: - Network

extension SignupUserInfoViewController {
    private func requestCheckUsernameDuplicate(username: String, completion: @escaping (Bool) -> ()) {
        UserService.shared.checkUsernameDuplicate(data: username) { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let isDuplicated = responseData as? Bool {
                    completion(isDuplicated)
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
}

// MARK: - Layout

extension SignupUserInfoViewController {
    private func setLayout() {
        self.view.addSubviews([
            navigationView,
            progressBarView,
            usernameTitleLabel,
            usernameDescriptionLabel,
            usernameTextField,
            usernameDuplicateButton,
            usernameStatusLabel,
            passwordTitleLabel,
            passwordDescriptionLabel,
            passwordTextField,
            termsLabel,
            nextButton
        ])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        self.progressBarView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom).offset(37)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(6)
        }
        
        self.usernameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.usernameDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.usernameTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(14)
        }
        
        self.usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.usernameDescriptionLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.width.equalToSuperview().multipliedBy(201.0/393.0)
        }
        
        self.usernameDuplicateButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.usernameTextField)
            make.left.equalTo(self.usernameTextField.snp.right).offset(8)
            make.right.equalToSuperview().inset(28)
        }
        
        self.usernameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(self.usernameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(12)
        }
        
        self.passwordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.usernameTextField.snp.bottom).offset(56)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.passwordDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.passwordTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(14)
        }
        
        self.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.passwordDescriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
        
        self.nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(52)
        }
        
        self.termsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.nextButton.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
    }
}
