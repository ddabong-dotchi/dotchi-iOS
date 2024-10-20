//
//  SignupProfileImageViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 7/16/24.
//

import UIKit
import SnapKit

final class SignupProfileImageViewController: BaseViewController {
    
    private enum Text {
        static let profileImageTitle = "대표 사진을 등록해 주세요!"
        static let next = "다음"
    }
    
    // MARK: UIComponents
    
    private let navigationView: DotchiNavigationView = DotchiNavigationView(type: .back)
    
    private let progressBarView = ProgressBarView()
    
    private let profileImageTitleLabel = {
        let label = UILabel()
        label.font = .head
        label.textColor = .dotchiWhite
        label.text = Text.profileImageTitle
        return label
    }()
    
    private let profileImageView = {
        let imageView = UIImageView()
        imageView.image = .imgDefaultProfile
        imageView.makeRounded(cornerRadius: 30)
        return imageView
    }()
    
    private let setImageButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private let photoIconImageView = {
        let imageView = UIImageView()
        imageView.image = .icnPhoto
        return imageView
    }()
    
    private let nextButton: DoneButton = {
        let button: DoneButton = DoneButton(type: .system)
        button.setTitle(Text.next, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private var signupRequestData = SignupEntity()
    private let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private let imagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
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
        self.setImagePickerController()
        self.setNextButtonAction()
        self.setSetImageButtonAction()
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
            self.signupRequestData.profileImage = self.profileImageView.image ?? .imgDefaultProfile
            
            self.requestSignup(profileImage: self.signupRequestData.profileImage, data: self.signupRequestData.toSignupRequestDTO()) { signupResponseData in
                self.navigationController?.pushViewController(SignupCompleteViewController(signupRequestData: self.signupRequestData), animated: true)
            }
        }
    }
    
    private func setSetImageButtonAction() {
        let defaultImageAction = UIAlertAction(title: "기본 이미지", style: .default) { _ in
            self.profileImageView.image = .imgDefaultProfile
        }
        
        let albumAction = UIAlertAction(title: "내 앨범 불러오기", style: .default) { _ in
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        self.actionSheet.addAction(defaultImageAction)
        self.actionSheet.addAction(albumAction)
        self.actionSheet.addAction(cancelAction)
        
        self.setImageButton.setAction {
            self.present(self.actionSheet, animated: true, completion: nil)
        }
    }
    
    private func setImagePickerController() {
        self.imagePickerController.delegate = self
    }
}

// MARK: - UIImagePickerControllerDelegate

extension SignupProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.profileImageView.image = image
            }
        }
    }
}

// MARK: - Network

extension SignupProfileImageViewController {
    private func requestSignup(profileImage: UIImage, data: SignupRequestDTO, completion: @escaping (SignupResponseDTO) -> ()) {
        self.startActivityIndicator()
        var signupRequestData = data
        
        self.uploadImage(image: profileImage) { url in
            signupRequestData.imageUrl = url
            
            UserService.shared.requestSignup(data: signupRequestData) { networkResult in
                switch networkResult {
                case .success(let responseData):
                    if let result = responseData as? SignupResponseDTO {
                        completion(result)
                    }
                default: self.showNetworkErrorAlert()
                }
                self.stopActivityIndicator()
            }
        }
    }
}

// MARK: - Layout

extension SignupProfileImageViewController {
    private func setLayout() {
        self.view.addSubviews([
            navigationView,
            progressBarView,
            profileImageTitleLabel,
            profileImageView,
            photoIconImageView,
            setImageButton,
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
        
        self.profileImageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageTitleLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150.constraintMultiplierTargetValue.adjustedW)
        }
        
        self.photoIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32.constraintMultiplierTargetValue.adjustedW)
            make.bottom.equalTo(self.profileImageView)
            make.right.equalTo(self.profileImageView.snp.right).offset(16)
        }
        
        self.setImageButton.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(self.profileImageView)
        }
        
        self.nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(52)
        }
    }
}
