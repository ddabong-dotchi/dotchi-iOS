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
    
    func setUserInfo(data: SigninResponseDTO) {
        UserInfo.shared.accessToken = data.accessToken
        UserInfo.shared.refreshToken = data.refreshToken
        
        self.setUserDataToKeychain(data: data)
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
    
    /// 신고 사유 선택 action sheet
//    func reportActionSheet(userId: Int) -> UIAlertController {
//        let reportActionSheet: UIAlertController = UIAlertController(
//            title: "신고 사유를 선택해 주세요.",
//            message: nil,
//            preferredStyle: .actionSheet
//        )
//        
//        var reportUserRequestDTO: ReportUserRequestDTO = ReportUserRequestDTO()
//        
//        self.reportReasons.forEach { reason in
//            reportActionSheet.addAction(
//                UIAlertAction(
//                    title: reason,
//                    style: .default,
//                    handler: { action in
//                        reportUserRequestDTO.reason = reason
//                        self.requestReportUser(userId: userId, data: reportUserRequestDTO) {
//                            self.makeAlert(title: "", message: Message.completedReport.text)
//                        }
//                    }
//                )
//            )
//        }
//        
//        reportActionSheet.addAction(
//            UIAlertAction(
//                title: Text.cancel,
//                style: .cancel
//            )
//        )
//        
//        return reportActionSheet
//    }
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
    
    /// 유저 차단
//    func requestBlockUser(userId: Int, completion: @escaping () -> ()) {
//        MemberService.shared.blockUser(userId: userId) { networkResult in
//            switch networkResult {
//            case .success:
//                completion()
//            default:
//                self.showNetworkErrorAlert()
//            }
//        }
//    }
    
    /// 유저 신고
//    func requestReportUser(userId: Int, data: ReportUserRequestDTO, completion: @escaping () -> ()) {
//        MemberService.shared.reportUser(userId: userId, data: data) { networkResult in
//            switch networkResult {
//            case .success:
//                completion()
//            default:
//                self.showNetworkErrorAlert()
//            }
//        }
//    }
}
