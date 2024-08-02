//
//  SignupNicknameViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/16/24.
//

import UIKit
import SnapKit

final class SignupNicknameViewController: BaseViewController {
    
    private enum Text {
        static let nicknameTitle = "닉네임을 설정해 주세요!"
        static let nicknameDescription = "한글로만 2~7자 입력해 주세요."
        static let checkDuplicate = "중복확인"
        static let duplicatedNickname = "중복된 닉네임입니다."
        static let uniqueNickname = "사용 가능한 닉네임입니다."
    }
    
    // MARK: UIComponents
    
    private let navigationView: DotchiNavigationView = DotchiNavigationView(type: .close)
    
    private let progressBarView = ProgressBarView()
    
    private let nicknameTitleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.nicknameTitle
        return label
    }()
    
    private let nicknameDescriptionLabel = {
        let label = UILabel()
        label.font = .subSbold
        label.textColor = .dotchiLgray
        label.text = Text.nicknameDescription
        return label
    }()
    
    private let nicknameTextField = SignupTextField(type: .username)
    
    private let nicknameDuplicateButton = {
        let button: DoneButton = DoneButton()
        button.setTitle(Text.checkDuplicate, for: .normal)
        return button
    }()
    
    private let nicknameStatusLabel = StatusLabel(warningText: Text.duplicatedNickname, successText: Text.uniqueNickname)

    
    // MARK: Properties
    
    // MARK: Initializer
    
    init(signupRequestData: SignupRequestDTO) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setUI()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.progressBarView.setProgress(step: .two)
    }
// MARK: - Network

extension SignupNicknameViewController {
    private func requestCheckNicknameDuplicate(nickname: String, completion: @escaping (Bool) -> ()) {
        UserService.shared.checkNicknameDuplicate(data: nickname) { networkResult in
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

extension SignupNicknameViewController {
    private func setLayout() {
        self.view.addSubviews([
            navigationView,
            progressBarView,
            nicknameTitleLabel,
            nicknameDescriptionLabel,
            nicknameTextField,
            nicknameDuplicateButton,
            nicknameStatusLabel
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
        
        self.nicknameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.nicknameDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(14)
        }
        
        self.nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameDescriptionLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.width.equalToSuperview().multipliedBy(201.0/393.0)
        }
        
        self.nicknameDuplicateButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.nicknameTextField)
            make.left.equalTo(self.nicknameTextField.snp.right).offset(8)
            make.right.equalToSuperview().inset(28)
        }
        
        self.nicknameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(12)
        }
    }
}
