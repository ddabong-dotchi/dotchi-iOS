//
//  UIView+.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit

enum VerticalLocation {
    case bottom
    case top
    case left
    case right
    case bottomRight
    case nadoBotttom
}

extension UIView {
    @discardableResult
    func makeShadow(color: UIColor,
                    opacity: Float,
                    offset: CGSize,
                    radius: CGFloat) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        return self
    }
    
    @discardableResult
    func setGradient(colors: [CGColor],
                     locations: [NSNumber] = [0.0, 1.0],
                     startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                     endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)) -> Self {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = self.bounds
        layer.addSublayer(gradient)
        return self
    }
    
    func addSubView<T: UIView>(_ subview: T, completionHandler closure: ((T) -> Void)? = nil) {
        addSubview(subview)
        closure?(subview)
    }
    
    func addSubViews<T: UIView>(_ subviews: [T], completionHandler closure: (([T]) -> Void)? = nil) {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .gray, opacity: Float = 0.2, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -4), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
        case .bottomRight:
            addShadow(offset: CGSize(width: 3, height: 3), color: color, opacity: opacity, radius: radius)
        case .nadoBotttom:
            addShadow(offset: CGSize(width: 0, height: 4), color: color, opacity: opacity, radius: radius)
        }
        
    }
    
    /// UIView의 그림자를 설정하는 메서드
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.07, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    /// UIView 의 모서리가 둥근 정도를 설정하는 메서드
    func makeRounded(cornerRadius : CGFloat?) {
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        
        self.layer.masksToBounds = true
    }
    
    /// UIView 의 모서리가 둥근 정도를 방향과 함께 설정하는 메서드
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func setAction(target: Any, action: Selector) {
        let recognizer = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(recognizer)
    }
    
    func toUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    // UIView에 터치 이벤트를 설정하는 메서드
    func setViewAction(_ action: @escaping () -> Void) {
        // 터치 제스처 인식기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        
        // 터치 이벤트를 받을 수 있도록 설정
        self.isUserInteractionEnabled = true
        
        // 터치 이벤트 실행 시 동작할 액션을 저장
        objc_setAssociatedObject(self, &UIView.actionKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // 터치가 발생했을 때 실행되는 메서드
    @objc private func handleTap() {
        if let action = objc_getAssociatedObject(self, &UIView.actionKey) as? () -> Void {
            action()
        }
    }
    
    // AssociatedObject Key 저장소
    private static var actionKey: UInt8 = 0
    
    /// UIView에 그라데이션 배경을 설정하는 메서드
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 위쪽 중앙에서 시작
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 아래쪽 중앙에서 끝남
        gradientLayer.frame = self.bounds

        // 기존 그라데이션 레이어 제거 (중복 방지)
        if let existingGradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingGradientLayer.removeFromSuperlayer()
        }

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
