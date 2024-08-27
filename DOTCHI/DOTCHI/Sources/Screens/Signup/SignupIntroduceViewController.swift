//
//  SignupIntroduceViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/16/24.
//

import UIKit
import SnapKit

final class SignupIntroduceViewController: BaseViewController {
    
    private enum Text {
        static let introduceTitle = "간단한 소개글을 작성해 보세요."
        static let introduceDescription = "작성하신 소개글은 추후 회원님의\n프로필에 방문한 사람들에게 보여집니다!"
        static let introduceCount = "(0/40)"
        static let next = "다음"
    }
    
    // MARK: UIComponents
    
    private let navigationView: DotchiNavigationView = DotchiNavigationView(type: .back)
    
    private let progressBarView = ProgressBarView()
    
    private let introduceTitleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.introduceTitle
        return label
    }()
    
    private let introduceTextView: PlaceholderTextView = {
        let textView: PlaceholderTextView = PlaceholderTextView()
        textView.backgroundColor = .dotchiMgray
        textView.font = .sub
        textView.textColor = .dotchiLgray
        textView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        textView.contentInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.placeholder = Text.introduceCount
        textView.placeholderFont = .sub
        textView.placeholderTextColor = .dotchiBlack40
        textView.makeRounded(cornerRadius: 8)
        return textView
    }()
    
    private let introduceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .subSbold
        label.textColor = .dotchiLgray
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        
        let attributedText = NSAttributedString(
            string: Text.introduceDescription,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.subSbold,
                .foregroundColor: UIColor.dotchiLgray
            ]
        )
        
        label.attributedText = attributedText
        label.numberOfLines = 2
        
        return label
    }()
    
    private let nextButton: DoneButton = {
        let button: DoneButton = DoneButton(type: .system)
        button.setTitle(Text.next, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private let maxCount = 40
    private var signupRequestData = SignupRequestDTO()
    
    // MARK: Initializer
    
    init(signupRequestData: SignupRequestDTO) {
        super.init(nibName: nil, bundle: nil)
        
        self.signupRequestData = signupRequestData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setBackButtonAction(self.navigationView.backButton)
        self.setNextButtonAction()
        self.setIntroduceTextViewDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setUI()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.progressBarView.setProgress(step: .three)
    }
    
    private func setNextButtonAction() {
        self.nextButton.setAction {
            self.signupRequestData.description = self.introduceTextView.text ?? ""
            
            self.navigationController?.pushViewController(SignupProfileImageViewController(signupRequestData: self.signupRequestData), animated: true)
        }
    }
    
    private func setIntroduceTextViewDelegate() {
        self.introduceTextView.delegate = self
    }
}

// MARK: - UITextViewDelegate

extension SignupIntroduceViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= maxCount
    }
}

// MARK: - Layout

extension SignupIntroduceViewController {
    private func setLayout() {
        self.view.addSubviews([
            navigationView,
            progressBarView,
            introduceTitleLabel,
            introduceTextView,
            introduceDescriptionLabel,
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
        
        self.introduceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.introduceTextView.snp.makeConstraints { make in
            make.top.equalTo(self.introduceTitleLabel.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(100)
        }
        
        self.introduceDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.introduceTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        self.nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(52)
        }
    }
}
