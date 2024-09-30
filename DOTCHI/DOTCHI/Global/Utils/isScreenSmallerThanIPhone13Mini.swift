//
//  isScreenSmallerThanIPhone13Mini.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/30/24.
//

import UIKit

// 유틸리티 함수: iPhone 13 mini 해상도보다 작은지 여부를 확인
func isScreenSmallerThanIPhone13Mini() -> Bool {
    let screenSize = UIScreen.main.bounds.size
    // iPhone 13 mini 해상도: 375 x 812 (points)
    return screenSize.width < 375 || screenSize.height < 812
}
