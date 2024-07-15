//
//  BlacklistViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/15/24.
//

import UIKit
import SnapKit

class BlacklistViewController: BaseViewController {
    private let userService = UserService.shared
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var blockedAccounts: [BlacklistResultDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dotchiScreenBackground
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
        fetchBlacklistData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // MARK: - Setup NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.title = "차단된 계정"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icnBack"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    private func createBlockedAccountView(profileImageURL: String?, nickname: String) -> UIView {
        let containerView = UIView()
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 26.5
        profileImageView.layer.masksToBounds = true
        containerView.addSubview(profileImageView)
        
        if let imageURL = profileImageURL, let url = URL(string: imageURL) {
            profileImageView.loadImage(from: url)
        } else {
            profileImageView.image = UIImage(named: "imgDefaultDummy")
        }
        
        let targetNicknameLabel = UILabel()
        targetNicknameLabel.text = nickname
        targetNicknameLabel.font = UIFont.subTitle
        targetNicknameLabel.textColor = UIColor.dotchiWhite
        containerView.addSubview(targetNicknameLabel)
        
        let unblockButton = UIButton(type: .system)
        unblockButton.setTitle("차단 해제", for: .normal)
        unblockButton.setTitleColor(UIColor.dotchiLgray, for: .normal)
        unblockButton.backgroundColor = UIColor.dotchiMgray
        unblockButton.layer.cornerRadius = 6
        unblockButton.titleLabel?.font = UIFont.sub
        containerView.addSubview(unblockButton)
        
        unblockButton.addTarget(self, action: #selector(unblockButtonTapped), for: .touchUpInside)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(53)
        }
        
        targetNicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
        unblockButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(36)
        }
        
        return containerView
    }
    
    private func addBlockedAccountViews() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        for account in blockedAccounts {
            let blockedAccountView = createBlockedAccountView(profileImageURL: account.targetImageUrl, nickname: account.targetNickname)
            contentView.addSubview(blockedAccountView)
        }
        
        var previousView: UIView?
        for (index, view) in contentView.subviews.enumerated() {
            view.snp.makeConstraints { make in
                make.leading.trailing.equalTo(contentView).inset(20)
                make.height.equalTo(53)
                
                if let previousView = previousView {
                    make.top.equalTo(previousView.snp.bottom).offset(13)
                } else {
                    make.top.equalTo(contentView).offset(13)
                }
                
                if index == contentView.subviews.count - 1 {
                    make.bottom.equalToSuperview().inset(20)
                }
            }
            previousView = view
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func unblockButtonTapped() {
        
    }
    
    private func fetchBlacklistData() {
        userService.getBlacklists { [weak self] result in
            switch result {
            case .success(let data):
                if let blacklistResponse = data as? [BlacklistResultDTO] {
                    self?.blockedAccounts = blacklistResponse
                    self?.addBlockedAccountViews()
                } else {
                    print("Invalid data format received: \(data)")
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
}
