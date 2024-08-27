//
//  SignupCompleteViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/16/24.
//

import UIKit
import SnapKit

final class SignupCompleteViewController: BaseViewController {
    
    private enum Text {
        static let title = "축하합니다!\n따봉도치의 행운을 받았습니다"
        static let lucky = "행운"
        static let description = "나만의 따봉도치를 만들어 행운을 주고받아 보세요!"
        static let start = "시작하기"
    }
    
    // MARK: UIComponents
    
    private let imageView = {
        let imageView = UIImageView(image: .imgSignupComplete)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.title
        label.setColor(to: Text.lucky, with: .dotchiGreen)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.font = .sub
        label.textColor = .dotchiLgray
        label.text = Text.description
        label.textAlignment = .center
        return label
    }()
    
    private let startButton: DoneButton = {
        let button: DoneButton = DoneButton(type: .system)
        button.setTitle(Text.start, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private var signupRequestData = SignupEntity()
    
    // MARK: Initializer
    
    init(signupRequestData: SignupEntity) {
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
        self.setStartButtonAction()
    }
    
    // MARK: Methods
    
    private func setStartButtonAction() {
        self.startButton.setAction {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Layout

extension SignupCompleteViewController {
    private func setLayout() {
        self.view.addSubviews([
            imageView,
            titleLabel,
            descriptionLabel,
            startButton
        ])
        
        self.imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.width.equalToSuperview()
            make.height.equalTo(self.imageView.snp.width).multipliedBy(0.648854)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(27)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(52)
        }
    }
}
