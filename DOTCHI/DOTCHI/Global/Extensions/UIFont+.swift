//
//  UIFont+.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import UIKit.UIFont

extension UIFont {
    
    static var adjustedFontSize: CGFloat {
        return isScreenSmallerThanIPhone13Mini() ? -4 : 0
    }
    
    class var bigTitle: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 32.0)!
    }
    
    class var dotchiName: UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: 28.0)!
    }
    
    class var title: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 28.0)!
    }
    
    class var head: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 24.0)!
    }
    
    class var body: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 22.0 + adjustedFontSize)!
    }
    
    class var bigButton: UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: 20.0)!
    }
    
    class var subTitle: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 18.0)!
    }
    
    class var dotchiName2: UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: 16.0)!
    }
    
    class var head2: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 16.0)!
    }
    
    class var button: UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: 14.0)!
    }
    
    class var subSbold: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: isScreenSmallerThanIPhone13Mini() ? 12.0 : 14.0)!
    }
    
    class var subSbold2: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 16.0)!
    }
    
    class var sub: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 14.0)!
    }
    
    class var sSub: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: isScreenSmallerThanIPhone13Mini() ? 11.0 : 12.0)!
    }
    
}
