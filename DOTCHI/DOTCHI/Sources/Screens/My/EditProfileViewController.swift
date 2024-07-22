//
//  EditProfileViewController.swift
//  DOTCHI
//
//  Created by KimYuBin on 7/10/24.
//

import UIKit
import SnapKit

class EditProfileViewController: BaseViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imageView = UIImageView()
    private var nicknameTextField = UITextField()
    private var introduceTextView = UITextView()
    private var introducePlaceholderLabel = UILabel()
    private var isNicknameDuplicated = false
    
    private let nicknameLimit = 7
    private let introduceLimit = 40
    private let checkButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupConstraints()
        
        introduceTextView.delegate = self
        
        configureIntroducePlaceholder()
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        self.view.backgroundColor = UIColor.dotchiScreenBackground
        
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "icnClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "프로필 수정"
        titleLabel.textColor = UIColor.dotchiWhite
        titleLabel.font = .subTitle
        self.view.addSubview(titleLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "imgRClover")
        self.view.addSubview(imageView)
        
        let cameraButton = UIButton(type: .custom)
        cameraButton.setImage(UIImage(named: "imgCamera"), for: .normal)
        cameraButton.backgroundColor = UIColor.dotchiBlack70
        cameraButton.layer.cornerRadius = 15
        cameraButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
        self.view.addSubview(cameraButton)
        
        let nicknameLabel = UILabel()
        nicknameLabel.text = "닉네임을 설정해주세요."
        nicknameLabel.textColor = UIColor.dotchiLgray
        nicknameLabel.font = .sub
        self.view.addSubview(nicknameLabel)
        
        nicknameTextField.placeholder = "최대 7글자"
        nicknameTextField.layer.cornerRadius = 8
        nicknameTextField.backgroundColor = .dotchiMgray
        nicknameTextField.textColor = .dotchiLgray
        nicknameTextField.font = .head2
        nicknameTextField.tintColor = UITextField().tintColor

        let leftPaddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: nicknameTextField.frame.height))
        nicknameTextField.leftView = leftPaddingView1
        nicknameTextField.leftViewMode = .always
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.dotchiWhite.withAlphaComponent(0.3),
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        ]
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "최대 7글자", attributes: attributes)
        
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange(_:)), for: .editingChanged)
        self.view.addSubview(nicknameTextField)
        
        checkButton.setTitle("중복확인", for: .normal)
        checkButton.backgroundColor = UIColor.dotchiGreen
        checkButton.setTitleColor(UIColor.white, for: .normal)
        checkButton.titleLabel?.font = .head2
        checkButton.layer.cornerRadius = 8
        checkButton.addTarget(self, action: #selector(checkForDuplicateNickname), for: .touchUpInside)
        self.view.addSubview(checkButton)
        
        let introduceLabel = UILabel()
        introduceLabel.text = "간단한 소개를 작성해주세요."
        introduceLabel.textColor = UIColor.dotchiLgray
        introduceLabel.font = .sub
        self.view.addSubview(introduceLabel)
        
        introduceTextView.layer.cornerRadius = 8
        introduceTextView.backgroundColor = .dotchiMgray
        introduceTextView.textColor = .dotchiLgray
        introduceTextView.font = .head2
        introduceTextView.delegate = self
        self.view.addSubview(introduceTextView)

        introducePlaceholderLabel.text = "최대 40글자"
        introducePlaceholderLabel.textColor = UIColor.dotchiWhite.withAlphaComponent(0.3)
        introducePlaceholderLabel.font = .head2
        introduceTextView.addSubview(introducePlaceholderLabel)
        introducePlaceholderLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceTextView).offset(13)
            make.leading.equalTo(introduceTextView).offset(18)
        }

        let leftPaddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 13))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 13))
        introduceTextView.textContainerInset = UIEdgeInsets(top: 13, left: 15, bottom: 0, right: 15)
        introduceTextView.addSubview(leftPaddingView2)
        introduceTextView.addSubview(rightPaddingView)
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.backgroundColor = UIColor.dotchiGreen
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.titleLabel?.font = .head2
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        self.view.addSubview(saveButton)
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
        
        let nicknameLabel = view.subviews.compactMap { $0 as? UILabel }.first { $0.text == "닉네임을 설정해주세요." }
        nicknameLabel?.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.equalTo(safeArea).offset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel!.snp.bottom).offset(10)
            make.leading.equalTo(safeArea).offset(20)
            make.height.equalTo(48)
            make.trailing.equalTo(checkButton.snp.leading).offset(-8) // 여기서 수정
        }

        checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTextField)
            make.trailing.equalTo(safeArea).offset(-28)
            make.height.equalTo(48)
            make.width.equalTo(128)
        }
        
        let introduceLabel = view.subviews.compactMap { $0 as? UILabel }.first { $0.text == "간단한 소개를 작성해주세요." }
        introduceLabel?.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.leading.equalTo(safeArea).offset(20)
        }
        
        introduceTextView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel!.snp.bottom).offset(10)
            make.leading.equalTo(safeArea).offset(20)
            make.trailing.equalTo(safeArea).offset(-20)
            make.height.equalTo(138)
        }
        
        let saveButton = view.subviews.compactMap { $0 as? UIButton }.first { $0.titleLabel?.text == "저장하기" }
        saveButton?.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).offset(-20)
            make.leading.equalTo(safeArea).offset(20)
            make.trailing.equalTo(safeArea).offset(-20)
            make.height.equalTo(52)
        }
    }
    
    // MARK: - Placeholder 관리
    
    private func configureIntroducePlaceholder() {
        introducePlaceholderLabel.isHidden = !introduceTextView.text.isEmpty
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        configureIntroducePlaceholder()
        guard let text = textView.text else { return }
        let remaining = introduceLimit - text.count
        
        if text.count > introduceLimit {
            let endIndex = text.index(text.startIndex, offsetBy: introduceLimit)
            textView.text = String(text.prefix(upTo: endIndex))
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func checkForDuplicateNickname() {
        // TODO: 닉네임 중복 확인 로직 추가
        isNicknameDuplicated = true // 테스트 코드
        if isNicknameDuplicated {
            nicknameTextField.layer.borderColor = UIColor.dotchiOrange.cgColor
            nicknameTextField.layer.borderWidth = 1
            nicknameTextField.makeRounded(cornerRadius: 8)
        } else {
            nicknameTextField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @objc private func saveProfile() {
        // TODO: 프로필 저장 로직 추가
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text Field Limit
    
    @objc func nicknameTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        // 최대 글자 수 초과 시 텍스트 자르기
        if text.count > nicknameLimit {
            let endIndex = text.index(text.startIndex, offsetBy: nicknameLimit)
            textField.text = String(text.prefix(upTo: endIndex))
        }
    }
}
