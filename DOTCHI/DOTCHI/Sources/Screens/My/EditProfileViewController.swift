//
//  EditProfileViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/10/24.
//

import UIKit
import SnapKit

class EditProfileViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let userService = UserService.shared
    
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private var imageView = UIImageView()
    private let cameraButton = UIButton()
    private let nicknameLabel = UILabel()
    private var nicknameTextField = UITextField()
    private let descriptionLabel = UILabel()
    private var descriptionTextView = UITextView()
    private var descriptionPlaceholderLabel = UILabel()
    private var nicknameStatusLabel = UILabel()
    private var isNicknameChecked = false
    private var isNicknameDuplicated = false
    private let nicknameLimit = 7
    private let descriptionLimit = 40
    private let nicknameDuplicateButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    
    private var originalNickname: String?
    private var originalDescription: String?
    private var originalImageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupConstraints()
        
        nicknameTextField.delegate = self
        descriptionTextView.delegate = self
        
        configureDescriptionPlaceholder()
        fetchMyData()
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        self.view.addSubviews([
            closeButton,
            titleLabel,
            imageView,
            cameraButton,
            nicknameLabel,
            nicknameTextField,
            nicknameDuplicateButton,
            nicknameStatusLabel,
            descriptionLabel,
            descriptionTextView,
            saveButton
        ])
        
        self.view.backgroundColor = UIColor.dotchiScreenBackground
        
        closeButton.setImage(UIImage(named: "icnClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        titleLabel.text = "프로필 수정"
        titleLabel.textColor = UIColor.dotchiWhite
        titleLabel.font = .subTitle
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "imgRClover")
        
        cameraButton.setImage(UIImage(named: "imgCamera"), for: .normal)
        cameraButton.backgroundColor = UIColor.dotchiBlack70
        cameraButton.layer.cornerRadius = 15
        cameraButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
        
        nicknameLabel.text = "닉네임을 설정해 주세요."
        nicknameLabel.textColor = UIColor.dotchiLgray
        nicknameLabel.font = .sub
        
        nicknameTextField.placeholder = "최대 7글자"
        nicknameTextField.layer.cornerRadius = 8
        nicknameTextField.layer.borderWidth = 1
        nicknameTextField.backgroundColor = .dotchiMgray
        nicknameTextField.textColor = .dotchiLgray
        nicknameTextField.font = .head2
        nicknameTextField.tintColor = UITextField().tintColor
        
        let leftPaddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 48))
        nicknameTextField.leftView = leftPaddingView1
        nicknameTextField.leftViewMode = .always
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.dotchiWhite.withAlphaComponent(0.3),
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        ]
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "최대 7글자", attributes: attributes)
        
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange(_:)), for: .editingChanged)
        
        nicknameDuplicateButton.setTitle("중복확인", for: .normal)
        nicknameDuplicateButton.backgroundColor = UIColor.dotchiGreen
        nicknameDuplicateButton.setTitleColor(UIColor.white, for: .normal)
        nicknameDuplicateButton.titleLabel?.font = .head2
        nicknameDuplicateButton.layer.cornerRadius = 8
        nicknameDuplicateButton.addTarget(self, action: #selector(checkForDuplicateNickname), for: .touchUpInside)
        nicknameDuplicateButton.isEnabled = false
        updateNicknameDuplicateButtonAppearance()
        
        nicknameStatusLabel.font = .sSub
        
        descriptionLabel.text = "간단한 소개를 작성해 주세요."
        descriptionLabel.textColor = UIColor.dotchiLgray
        descriptionLabel.font = .sub
        
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.backgroundColor = .dotchiMgray
        descriptionTextView.textColor = .dotchiLgray
        descriptionTextView.font = .head2
        descriptionTextView.delegate = self
        
        descriptionPlaceholderLabel.text = "최대 40글자"
        descriptionPlaceholderLabel.textColor = UIColor.dotchiWhite.withAlphaComponent(0.3)
        descriptionPlaceholderLabel.font = .head2
        descriptionTextView.addSubview(descriptionPlaceholderLabel)
        descriptionPlaceholderLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView).offset(13)
            make.leading.equalTo(descriptionTextView).offset(18)
        }
        
        let leftPaddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 13))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 13))
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 13, left: 15, bottom: 0, right: 15)
        descriptionTextView.addSubview(leftPaddingView2)
        descriptionTextView.addSubview(rightPaddingView)
        
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.titleLabel?.font = .head2
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        saveButton.isEnabled = false
        updateSaveButtonAppearance()
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        let closeButton = view.subviews.compactMap { $0 as? UIButton }.first
        closeButton?.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(10)
            make.leading.equalTo(safeArea).offset(10)
            make.width.height.equalTo(30)
        }
        
        let titleLabel = view.subviews.compactMap { $0 as? UILabel }.first
        titleLabel?.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(10)
            make.centerX.equalTo(safeArea)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel!.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea)
            make.width.height.equalTo(116)
        }
        
        let cameraButton = view.subviews.compactMap { $0 as? UIButton }.first { $0.currentImage == UIImage(named: "imgCamera") }
        cameraButton?.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerX.equalTo(imageView.snp.trailing).offset(-10)
            make.centerY.equalTo(imageView.snp.bottom).offset(-10)
        }
        
        let nicknameLabel = view.subviews.compactMap { $0 as? UILabel }.first { $0.text == "닉네임을 설정해 주세요." }
        nicknameLabel?.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.equalTo(safeArea).offset(28)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel!.snp.bottom).offset(10)
            make.leading.equalTo(safeArea).offset(28)
            make.height.equalTo(48)
            make.trailing.equalTo(nicknameDuplicateButton.snp.leading).offset(-8)
        }
        
        nicknameDuplicateButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTextField)
            make.trailing.equalTo(safeArea).offset(-28)
            make.height.equalTo(48)
            make.width.equalTo(128)
        }
        
        nicknameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5)
            make.leading.equalTo(nicknameTextField)
        }
        
        let introduceLabel = view.subviews.compactMap { $0 as? UILabel }.first { $0.text == "간단한 소개를 작성해 주세요." }
        introduceLabel?.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(30)
            make.leading.equalTo(safeArea).offset(28)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel!.snp.bottom).offset(10)
            make.leading.equalTo(safeArea).offset(28)
            make.trailing.equalTo(safeArea).offset(-28)
            make.height.equalTo(138)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).offset(-32)
            make.leading.equalTo(safeArea).offset(28)
            make.trailing.equalTo(safeArea).offset(-28)
            make.height.equalTo(52)
        }
    }
    
    private func configureDescriptionPlaceholder() {
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func checkForDuplicateNickname() {
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(message: "닉네임을 입력해 주세요.")
            return
        }
        
        userService.checkNicknameDuplicate(data: nickname) { [weak self] result in
            DispatchQueue.main.async { [self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let isDuplicated = response as? Bool {
                        self.isNicknameDuplicated = isDuplicated
                        self.isNicknameChecked = true
                        self.nicknameStatusLabel.text = isDuplicated ? "중복된 닉네임입니다." : "사용 가능 닉네임입니다."
                        self.nicknameStatusLabel.textColor = isDuplicated ? .dotchiOrange : .dotchiGreen
                        self.nicknameTextField.layer.borderColor = isDuplicated ? UIColor.dotchiOrange.cgColor : UIColor.dotchiGreen.cgColor
                        
                        self.checkForUnsavedChanges()
                        
                    } else {
                        print("서버에서 올바른 응답을 받지 못했습니다.")
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
    
    // MARK: - UITextFieldDelegate
    
    @objc private func nicknameTextFieldDidChange(_ textField: UITextField) {
        let nickname = textField.text ?? ""
        
        if nickname.count > nicknameLimit {
            textField.text = String(nickname.prefix(nicknameLimit))
        }
        
        let isNicknameChanged = (nickname != originalNickname)
        nicknameDuplicateButton.isEnabled = isNicknameChanged
        updateNicknameDuplicateButtonAppearance()
        
        if isNicknameChanged || nickname == originalNickname {
            nicknameStatusLabel.text = ""
            nicknameStatusLabel.textColor = UIColor.clear
            nicknameTextField.layer.borderColor = UIColor.dotchiMgray.cgColor
        }
        
        isNicknameChecked = false
        checkForUnsavedChanges()
    }
    
    private func updateNicknameDuplicateButtonAppearance() {
        let isEnabled = nicknameDuplicateButton.isEnabled
        nicknameDuplicateButton.backgroundColor = isEnabled ? UIColor.dotchiGreen : UIColor.dotchiGreen.withAlphaComponent(0.5)
        nicknameDuplicateButton.setTitleColor(isEnabled ? UIColor.white : UIColor.white.withAlphaComponent(0.5), for: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= nicknameLimit
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= descriptionLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        if text.count > descriptionLimit {
            textView.text = String(text.prefix(descriptionLimit))
        }
        configureDescriptionPlaceholder()
        checkForUnsavedChanges()
    }
    
    private func checkForUnsavedChanges() {
        let currentNickname = nicknameTextField.text ?? ""
        let currentDescription = descriptionTextView.text ?? ""
        let currentImageUrl = imageView.image != UIImage(named: "imgRClover") ? "CustomImageURL" : originalImageUrl
        
        let hasChanges = (currentNickname != originalNickname) ||
        (currentDescription != originalDescription) ||
        (currentImageUrl != originalImageUrl)
        
        if currentNickname != originalNickname {
            saveButton.isEnabled = hasChanges && isNicknameChecked && !isNicknameDuplicated
        } else {
            saveButton.isEnabled = hasChanges
        }
        
        updateSaveButtonAppearance()
    }
    
    private func updateSaveButtonAppearance() {
        let isEnabled = saveButton.isEnabled
        saveButton.backgroundColor = isEnabled ? UIColor.dotchiGreen : UIColor.dotchiGreen.withAlphaComponent(0.5)
        saveButton.setTitleColor(isEnabled ? UIColor.white : UIColor.white.withAlphaComponent(0.5), for: .normal)
    }
    
    @objc private func saveProfile() {
        UserService.shared.editUser(nickname: nicknameTextField.text ?? "", description: descriptionTextView.text, profileImage: imageView.image) { result in
            switch result {
            case .success(let response):
                self.dismiss(animated: true, completion: nil)
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    @objc private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            checkForUnsavedChanges()
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Network
    
    private func fetchMyData() {
        userService.getUser { [weak self] result in
            switch result {
            case .success(let data):
                if let userResponse = data as? UserResponseDTO {
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
    
    private func updateUI(with userData: UserResponseDTO) {
        DispatchQueue.main.async { [weak self] in
            self?.nicknameTextField.text = userData.nickname
            self?.descriptionTextView.text = userData.description
            self?.configureDescriptionPlaceholder()
            self?.originalNickname = userData.nickname
            self?.originalDescription = userData.description
            self?.originalImageUrl = userData.imageUrl
            if let url = URL(string: userData.imageUrl) {
                self?.imageView.loadImage(from: url)
            } else {
                print("Invalid image URL: \(userData.imageUrl)")
            }
            self?.checkForUnsavedChanges()
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
