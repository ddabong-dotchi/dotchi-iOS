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
    
    private func setupNavigationBar() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 24
        profileImageView.layer.masksToBounds = true
        profileImageView.image = UIImage(named: "imgTest")
        contentView.addSubview(profileImageView)
        
        editButton.setImage(UIImage(named: "icnEdit"), for: .normal)
        editButton.backgroundColor = UIColor.dotchiBlack70
        editButton.layer.cornerRadius = 15
        editButton.addTarget(self, action: #selector(openEditProfile), for: .touchUpInside)
        contentView.addSubview(editButton)
        
        nameLabel.font = UIFont.body
        nameLabel.textColor = UIColor.dotchiWhite
        contentView.addSubview(nameLabel)
        
        descriptionLabel.font = UIFont.subSbold
        descriptionLabel.textColor = UIColor.dotchiLgray
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
        contentView.addSubview(descriptionLabel)
        
        configureSeparator(separator1)
        configureSeparator(separator2)
        configureSeparator(separator3)
        
        informationLabel.font = UIFont.subTitle
        informationLabel.textColor = UIColor.dotchiWhite
        informationLabel.text = "정보"
        contentView.addSubview(informationLabel)
        
        configureButton(button: contactButton, title: "문의하기", imageName: "icnNext", action: #selector(contactUs))
        contentView.addSubview(contactButton)
        
        configureButton(button: termsLinkButton, title: "서비스 이용 약관", imageName: "icnNext", action: #selector(openTerms))
        contentView.addSubview(termsLinkButton)
        
        configureButton(button: privacyLinkButton, title: "개인정보 처리 방침", imageName: "icnNext", action: #selector(openPrivacyPolicy))
        contentView.addSubview(privacyLinkButton)
        
        accountInfoLabel.font = UIFont.subTitle
        accountInfoLabel.textColor = UIColor.dotchiWhite
        accountInfoLabel.text = "계정 정보"
        contentView.addSubview(accountInfoLabel)
        
        configureButton(button: modifyAccountInfoButton, title: "계정 정보 수정", imageName: "icnNext", action: #selector(openModifyAccountInfo))
        contentView.addSubview(modifyAccountInfoButton)
        
        configureButton(button: blockedAccountsButton, title: "차단 사용자 관리", imageName: "icnNext", action: #selector(openBlockedAccounts))
        contentView.addSubview(blockedAccountsButton)
        
        let title = "로그아웃"
        let attributedString = NSAttributedString(string: title, attributes: [
            .font: UIFont.subSbold2,
            .foregroundColor: UIColor.dotchiLgray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        logoutButton.setAttributedTitle(attributedString, for: .normal)
        logoutButton.contentHorizontalAlignment = .left
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        contentView.addSubview(logoutButton)
        
        let deleteTitle = "탈퇴하기"
        let deleteAttributedString = NSAttributedString(string: deleteTitle, attributes: [
            .font: UIFont.subSbold2,
            .foregroundColor: UIColor.dotchiLgray.withAlphaComponent(0.8),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        deleteAccountButton.setAttributedTitle(deleteAttributedString, for: .normal)
        deleteAccountButton.contentHorizontalAlignment = .left
        deleteAccountButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        contentView.addSubview(deleteAccountButton)
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
        label.font = UIFont.subSbold2
        label.textColor = UIColor.dotchiLgray
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
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        separator1.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(separator1.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(20)
        }
        
        contactButton.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        termsLinkButton.snp.makeConstraints { make in
            make.top.equalTo(contactButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        privacyLinkButton.snp.makeConstraints { make in
            make.top.equalTo(termsLinkButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        separator2.snp.makeConstraints { make in
            make.top.equalTo(privacyLinkButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        accountInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(separator2.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(20)
        }
        
        modifyAccountInfoButton.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        blockedAccountsButton.snp.makeConstraints { make in
            make.top.equalTo(modifyAccountInfoButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        separator3.snp.makeConstraints { make in
            make.top.equalTo(blockedAccountsButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(separator3.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    @objc private func openEditProfile() {
        let profileEditVC = ProfileEditViewController()
        profileEditVC.modalPresentationStyle = .fullScreen
        profileEditVC.modalTransitionStyle = .coverVertical
        
        self.present(profileEditVC, animated: true, completion: nil)
    }
    
    @objc private func contactUs() {
        self.sendMail()
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
    
    @objc private func openModifyAccountInfo() {
        
    }
    
    @objc private func openBlockedAccounts() {
        
    }
    
    @objc private func logout() {
        
    }
    
    @objc private func deleteAccount() {
        
    }
    
    private func fetchMyData() {
        userService.getUser { [weak self] result in
            switch result {
            case .success(let data):
                if let userResponse = data as? UserResultDTO {
                    self?.updateUI(with: userResponse)
                    
                } else {
                    print("Invalid data format received")
                }
            case .requestErr(let message):
                print("Request error: \(message)")
            case .pathErr:
                print("Path error")
            case .serverErr:
                print("Server error")
            case .networkFail:
                print("Network failure")
            }
        }
    }
    
    private func updateUI(with userData: UserResultDTO) {
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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
