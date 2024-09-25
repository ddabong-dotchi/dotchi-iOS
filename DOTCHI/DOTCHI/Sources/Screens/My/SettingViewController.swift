//
//  SettingViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/9/24.
//

import UIKit
import SnapKit
import MessageUI

class SettingViewController: BaseViewController {
    private let userService = UserService.shared
    private let authService = AuthService.shared
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let profileImageView = UIImageView()
    private let editButton = UIButton()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let informationLabel = UILabel()
    private let contactButton = UIButton()
    private let termsLinkButton = UIButton()
    private let privacyLinkButton = UIButton()
    private let accountInfoLabel = UILabel()
    private let modifyAccountInfoButton = UIButton()
    private let blockedAccountsButton = UIButton()
    private let logoutButton = UIButton()
    private let deleteAccountButton = UIButton()
    
    private let separator1 = UIView()
    private let separator2 = UIView()
    private let separator3 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dotchiScreenBackground
        
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
        fetchMyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyData()
        hideTabBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // MARK: - Setup NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.title = "설정"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icnBack"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        
        self.scrollView.addSubviews([
            contentView,
            profileImageView,
            editButton,
            nameLabel,
            descriptionLabel,
            informationLabel,
            contactButton,
            termsLinkButton,
            privacyLinkButton,
            accountInfoLabel,
            modifyAccountInfoButton,
            blockedAccountsButton,
            logoutButton,
            deleteAccountButton
        ])
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 24
        profileImageView.layer.masksToBounds = true
        profileImageView.image = UIImage(named: "imgDefaultDummy")
        
        editButton.setImage(UIImage(named: "icnEdit"), for: .normal)
        editButton.backgroundColor = UIColor.dotchiBlack70
        editButton.layer.cornerRadius = 15
        editButton.addTarget(self, action: #selector(openEditProfile), for: .touchUpInside)
        
        nameLabel.setStyle(.body, .dotchiWhite)
        
        descriptionLabel.setStyle(.subSbold, .dotchiLgray)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        if description.count > 20 {
            let firstLineIndex = description.index(description.startIndex, offsetBy: 20)
            let firstLine = String(description.prefix(upTo: firstLineIndex))
            let secondLine = String(description.suffix(from: firstLineIndex))
            descriptionLabel.text = "\(firstLine)\n\(secondLine)"
        } else {
            descriptionLabel.text = description
        }
        
        configureSeparator(separator1)
        configureSeparator(separator2)
        configureSeparator(separator3)
        
        informationLabel.text = "정보"
        informationLabel.setStyle(.subTitle, .dotchiWhite)
        
        configureButton(button: contactButton, title: "문의하기", imageName: "icnNext", action: #selector(contactUs))
        
        configureButton(button: termsLinkButton, title: "서비스 이용 약관", imageName: "icnNext", action: #selector(openTerms))
        
        configureButton(button: privacyLinkButton, title: "개인정보 처리 방침", imageName: "icnNext", action: #selector(openPrivacyPolicy))
        
        accountInfoLabel.text = "계정 정보"
        accountInfoLabel.setStyle(.subTitle, .dotchiWhite)
        
        configureButton(button: modifyAccountInfoButton, title: "계정 정보 수정", imageName: "icnNext", action: #selector(openEditAccountInfo))
        
        configureButton(button: blockedAccountsButton, title: "차단 사용자 관리", imageName: "icnNext", action: #selector(openBlockedAccounts))
        
        let title = "로그아웃"
        let attributedString = NSAttributedString(string: title, attributes: [
            .font: UIFont.subSbold2,
            .foregroundColor: UIColor.dotchiLgray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        logoutButton.setAttributedTitle(attributedString, for: .normal)
        logoutButton.contentHorizontalAlignment = .left
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        let deleteTitle = "탈퇴하기"
        let deleteAttributedString = NSAttributedString(string: deleteTitle, attributes: [
            .font: UIFont.subSbold2,
            .foregroundColor: UIColor.dotchiLgray.withAlphaComponent(0.8),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        deleteAccountButton.setAttributedTitle(deleteAttributedString, for: .normal)
        deleteAccountButton.contentHorizontalAlignment = .left
        deleteAccountButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
    }
    
    private func configureSeparator(_ separator: UIView) {
        separator.backgroundColor = .black
        contentView.addSubview(separator)
    }
    
    private func configureButton(button: UIButton, title: String, imageName: String, action: Selector) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        
        let label = UILabel()
        label.text = title
        label.setStyle(.subSbold2, .dotchiLgray)
        stackView.addArrangedSubview(label)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
        
        button.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        stackView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(116)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.bottom.right.equalTo(profileImageView).inset(-6)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        separator1.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(separator1.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(28)
        }
        
        contactButton.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        termsLinkButton.snp.makeConstraints { make in
            make.top.equalTo(contactButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        privacyLinkButton.snp.makeConstraints { make in
            make.top.equalTo(termsLinkButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        separator2.snp.makeConstraints { make in
            make.top.equalTo(privacyLinkButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        accountInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(separator2.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(28)
        }
        
        modifyAccountInfoButton.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        blockedAccountsButton.snp.makeConstraints { make in
            make.top.equalTo(modifyAccountInfoButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        separator3.snp.makeConstraints { make in
            make.top.equalTo(blockedAccountsButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(separator3.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openEditProfile() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.modalPresentationStyle = .fullScreen
        editProfileVC.modalTransitionStyle = .coverVertical
        
        self.present(editProfileVC, animated: true, completion: nil)
    }
    
    @objc private func contactUs() {
        self.sendContactMail()
    }
    
    @objc private func openTerms() {
        if let url = URL(string: "https://www.dnd.ac/projects/74") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.dnd.ac/projects/74") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func openEditAccountInfo() {
        let editAccountInfoVC = EditAccountInfoViewController()
        navigationController?.pushViewController(editAccountInfoVC, animated: true)
    }
    
    @objc private func openBlockedAccounts() {
        let blacklistVC = BlacklistViewController()
        navigationController?.pushViewController(blacklistVC, animated: true)
    }
    
    @objc private func logout() {
        authService.logout { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.clearKeychainData()
                
                DispatchQueue.main.async {
                    let loginVC = SigninViewController()
                    let navController = UINavigationController(rootViewController: loginVC)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = navController
                        window.makeKeyAndVisible()
                    }
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    @objc private func deleteAccount() {
        makeAlertWithCancel(
            title: "계정을 탈퇴하시겠습니까?",
            message: "탈퇴 후에는 복구가 불가능합니다.",
            okTitle: "탈퇴하기",
            okStyle: .destructive,
            cancelTitle: "취소",
            okAction: { _ in
                self.performDeleteAccount()
            }
        )
    }

    private func performDeleteAccount() {
        authService.deleteAccount { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.clearKeychainData()
                
                DispatchQueue.main.async {
                    let loginVC = SigninViewController()
                    let navController = UINavigationController(rootViewController: loginVC)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = navController
                        window.makeKeyAndVisible()
                    }
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    // MARK: - Network
    
    private func fetchMyData() {
        userService.getUser { networkResult in
            switch networkResult {
            case .success(let data):
                if let userResponse = data as? UserResponseDTO {
                    self.updateUI(with: userResponse)
                } else {
                    print("Invalid data format received")
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    private func updateUI(with userData: UserResponseDTO) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = userData.nickname
            self?.descriptionLabel.text = userData.description
            if let url = URL(string: userData.imageUrl) {
                self?.profileImageView.loadImage(from: url)
            } else {
                print("Invalid image URL: \(userData.imageUrl)")
            }
        }
    }
}
