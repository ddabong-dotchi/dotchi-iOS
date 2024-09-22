//
//  EditAccountInfoViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 8/20/24.
//

import UIKit

class EditAccountInfoViewController: BaseViewController {
    private let userService = UserService.shared
    
    private let infoLabel = UILabel()
    private let idLabel = UILabel()
    private let idInfoLabel = UILabel()
    private let passwordLabel = UILabel()
    private let passwordInfoLabel = UILabel()
    private let changePasswordButton = UIButton()
    
    private let passwordVerticalStackView = UIStackView()
    private let passwordHorizontalStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.dotchiScreenBackground
        
        setupSubviews()
        setupNavigationBar()
        setupConstraints()
        fetchMyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    private func setupSubviews() {
        self.view.addSubviews([
            infoLabel,
            idLabel,
            idInfoLabel,
            passwordHorizontalStackView
        ])
        
        infoLabel.text = "가입한 계정 정보"
        infoLabel.setStyle(.sub, .dotchiWhite)
        
        idLabel.text = "아이디"
        idLabel.setStyle(.bigButton, .dotchiWhite)
        
        idInfoLabel.setStyle(.subSbold, .dotchiLgray)
        
        passwordLabel.text = "비밀번호"
        passwordLabel.setStyle(.bigButton, .dotchiWhite)
        
        passwordInfoLabel.text = "**********"
        passwordInfoLabel.setStyle(.subSbold, .dotchiLgray)
        
        changePasswordButton.setTitle("변경하기", for: .normal)
        changePasswordButton.setTitleColor(UIColor.dotchiGreen, for: .normal)
        changePasswordButton.titleLabel?.font = .button
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        
        passwordVerticalStackView.axis = .vertical
        passwordVerticalStackView.spacing = 8
        passwordVerticalStackView.alignment = .leading
        passwordVerticalStackView.addArrangedSubviews([passwordLabel, passwordInfoLabel])
        
        passwordHorizontalStackView.axis = .horizontal
        passwordHorizontalStackView.spacing = 16
        passwordHorizontalStackView.alignment = .top
        passwordHorizontalStackView.addArrangedSubview(passwordVerticalStackView)
        passwordHorizontalStackView.addArrangedSubview(changePasswordButton)
    }
    
    // MARK: - Setup NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.title = "계정 정보 수정"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icnBack"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Button Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changePasswordButtonTapped() {
        let changePasswordVC = ChangePasswordViewController()
        changePasswordVC.modalPresentationStyle = .fullScreen
        changePasswordVC.modalTransitionStyle = .coverVertical
        
        self.present(changePasswordVC, animated: true, completion: nil)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        idInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        passwordHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(idInfoLabel.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(28)
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
            self?.idInfoLabel.text = userData.username
        }
    }
}
