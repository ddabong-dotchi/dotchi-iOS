//
//  BaseViewController.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit
import SnapKit
import MessageUI
import KeychainSwift

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private enum Text {
        static let cancel = "취소하기"
    }
    
    // MARK: UIComponents
    
    lazy var activityIndicator: DotchiActivityIndicatorView = {
        let activityIndicator: DotchiActivityIndicatorView = DotchiActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        
        return activityIndicator
    }()
    
    lazy private var keychainManager: KeychainSwift = KeychainSwift()
    
    // MARK: Properties
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let reportReasons: [String] = ["유해한 콘텐츠", "스팸/홍보", "도배", "도용", "기타"]
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundColor()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: Methods
    
    /// 모든 뷰의 기본 Background color 설정
    private func setBackgroundColor() {
        self.view.backgroundColor = .dotchiBlack
    }
    
    /// BackButton에 pop Action을 간편하게 주는 메서드.
    /// - 필요 시 override하여 사용
    @objc
    func setBackButtonAction(_ button: UIButton) {
        button.setAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    /// CloseButton에 dismiss Action을 간편하게 주는 메서드.
    /// - 필요 시 override하여 사용
    @objc
    func setCloseButtonAction(_ button: UIButton) {
        button.setAction { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    /// 화면 터치 시 키보드 내리는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func hideTabBar() {
        if let tabBarController = self.tabBarController as? DotchiTabBarController {
            tabBarController.hideTabBar()
        }
    }
    
    func showTabBar() {
        if let tabBarController = self.tabBarController as? DotchiTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    func showNetworkErrorAlert() {
        self.makeAlert(title: Messages.networkError.text)
    }
    
    func setUserToken(data: SigninResponseDTO) {
        UserInfo.shared.accessToken = data.accessToken
        UserInfo.shared.refreshToken = data.refreshToken
        
        self.setUserDataToKeychain(data: data)
    }
    
    func setUserInfo(data: UserResponseDTO) {
        UserInfo.shared.userID = data.id
        UserInfo.shared.username = data.username
        UserInfo.shared.nickname = data.nickname
        UserInfo.shared.profileImageUrl = data.imageUrl
    }
    
    private func setUserDataToKeychain(data: SigninResponseDTO) {
        self.keychainManager.set(data.accessToken, forKey: KeychainKeys.accessToken.rawValue)
        self.keychainManager.set(data.refreshToken, forKey: KeychainKeys.refreshToken.rawValue)
//        self.keychainManager.set("\(data.memberID)", forKey: KeychainKeys.userID.rawValue)
//        self.keychainManager.set(data.memberName, forKey: KeychainKeys.username.rawValue)
//        self.keychainManager.set(data.memberImageURL, forKey: KeychainKeys.profileImageUrl.rawValue)
    }
    
    func setSigninDataToKeychain(username: String, password: String) {
        self.keychainManager.set(username, forKey: KeychainKeys.username.rawValue)
        self.keychainManager.set(password, forKey: KeychainKeys.password.rawValue)
    }
    
    func getSigninDataFromKeychain() -> SigninRequestDTO {
        let username: String = self.keychainManager.get(KeychainKeys.username.rawValue) ?? ""
        let password: String = self.keychainManager.get(KeychainKeys.password.rawValue) ?? ""
        
        let data: SigninRequestDTO = SigninRequestDTO(username: username, password: password)
        
        return data
    }
    
    /// Keychain에서 저장된 비밀번호를 가져오는 메서드
    func getPasswordFromKeychain() -> String? {
        return keychainManager.get(KeychainKeys.password.rawValue)
    }
    
    /// Keychain에 비밀번호 업데이트
    func updatePasswordInKeychain(newPassword: String) {
        keychainManager.set(newPassword, forKey: KeychainKeys.password.rawValue)
    }
    
    /// 모든 Keychain 데이터 삭제
    func clearKeychainData() {
        self.keychainManager.delete(KeychainKeys.accessToken.rawValue)
        self.keychainManager.delete(KeychainKeys.refreshToken.rawValue)
        self.keychainManager.delete(KeychainKeys.username.rawValue)
        self.keychainManager.delete(KeychainKeys.password.rawValue)
    }
    
    /// 신고 사유 선택 action sheet
    func reportActionSheet(username: String) -> UIAlertController {
        let reportActionSheet: UIAlertController = UIAlertController(
            title: "신고 사유를 선택해 주세요.",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        var reportUserRequestDTO: ReportUserRequestDTO = ReportUserRequestDTO()
        
        self.reportReasons.forEach { reason in
            reportActionSheet.addAction(
                UIAlertAction(
                    title: reason,
                    style: .default,
                    handler: { action in
                        reportUserRequestDTO.reportReason = reason.toReportReason().rawValue
                        reportUserRequestDTO.target = username
                        self.requestReportUser(data: reportUserRequestDTO) {
                            self.makeAlert(title: "", message: Messages.completedReport.text)
                        }
                    }
                )
            )
        }
        
        reportActionSheet.addAction(
            UIAlertAction(
                title: Text.cancel,
                style: .cancel
            )
        )
        
        return reportActionSheet
    }
    
    /// 서버 통신 시작 시 Activity Indicator를 시작하는 메서드
    func startActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    /// 서버 통신이 끝나면 Activity Indicator를 종료하는 메서드
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension BaseViewController: MFMailComposeViewControllerDelegate {
    
    func sendForgetPasswordMail() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients(["ddabongdotchi@gmail.com"])
            compseVC.setSubject("[따봉도치] 비밀번호를 잊었어요! 🥲")
            compseVC.setMessageBody(
"""
안녕하세요.
서비스를 이용해 주셔서 감사해요.
비밀번호를 변경할 수 있는 링크를 전송해 주신 메일로 회신해 드리겠습니다.
——————————————————————————
User: \(String(describing: UserInfo.shared.userID))
App Version: \(AppInfo.shared.currentAppVersion())
Device: \(self.deviceModelName())
OS Version: \(UIDevice.current.systemVersion)
"""
                , isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
            
        } else {
            self.makeAlert(title: Messages.unabledMailApp.text)
        }
    }
    
    func sendContactMail() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients(["ddabongdotchi@gmail.com"])
            compseVC.setSubject("[따봉도치] 문의해요 👋")
            compseVC.setMessageBody(
"""
안녕하세요.
서비스를 이용해 주셔서 감사해요.
개선했으면 하는 부분 혹은 추가되었으면 하는 기능은 적극 반영해 볼게요.
문의에 대한 답변은 빠른 시일 내에 전송해 주신 메일로 회신드리겠습니다.
————————————————————————
User: \(String(describing: UserInfo.shared.userID))
App Version: \(AppInfo.shared.currentAppVersion())
Device: \(self.deviceModelName())
OS Version: \(UIDevice.current.systemVersion)
"""
                , isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
            
        } else {
            self.makeAlert(title: Messages.unabledMailApp.text)
        }
    }
    
    private func deviceModelName() -> String {
        
        /// 시뮬레이터 확인
        var modelName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? ""
        if modelName.isEmpty == false && modelName.count > 0 {
            return modelName
        }
        
        /// 실제 디바이스 확인
        let device = UIDevice.current
        let selName = "_\("deviceInfo")ForKey:"
        let selector = NSSelectorFromString(selName)
        
        if device.responds(to: selector) {
            modelName = String(describing: device.perform(selector, with: "marketing-name").takeRetainedValue())
        }
        return modelName
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            switch result {
            case .cancelled, .saved: return
            case .sent:
                self.makeAlert(title: Messages.completedSendContactMail.text)
            case .failed:
                self.makeAlert(title: Messages.failedSendContactMail.text)
            @unknown default:
                self.makeAlert(title: Messages.networkError.text)
            }
        }
    }
}

// MARK: - Network

extension BaseViewController {
    
    func requestBlockUser(targetUsername: String, completion: @escaping () -> ()) {
        UserService.shared.requestBlockUser(targetUsername: targetUsername) { networkResult in
            switch networkResult {
            case .success:
                completion()
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    func requestReportUser(data: ReportUserRequestDTO, completion: @escaping () -> ()) {
        UserService.shared.reportUser(data: data) { networkResult in
            switch networkResult {
            case .success:
                completion()
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
    
    func uploadImage(image: UIImage, URL: @escaping (String) -> ()) {
        ImageService.shared.getPreSigned(fileName: "\(Date())_image.jpg") { result in
            switch result {
            case .success(let response):
                if let imageResponse = response as? ImageResponseDTO {
                    let preSignedUrl = imageResponse.preSignedUrl
                    let imageUrl = imageResponse.imageUrl
                    
                    guard let imageData = image.jpegData(compressionQuality: 0.8)
                    else {
                        debugPrint("Failed to convert image to data")
                        self.showNetworkErrorAlert()
                        return
                    }
                    
                    ImageService.shared.uploadImageWithPreSignedUrl(preSignedUrl: preSignedUrl, imageData: imageData) { uploadResult in
                        switch uploadResult {
                        case .success:
                            URL(imageUrl)
                        default:
                            self.showNetworkErrorAlert()
                        }
                    }
                }
                
                else {
                    print("Failed to cast response to ImageResponseDTO. Response: \(response)")
                    self.showNetworkErrorAlert()
                }
            default:
                self.showNetworkErrorAlert()
            }
        }
    }
}
