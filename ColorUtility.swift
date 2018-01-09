//
//  ColorUtility.swift
//  Surprix
//
//  Created by Administrator on 02/01/2018.
//  Copyright © 2018 Luca Giorgetti. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    struct CustomColor {
        static let yellowSet = UIColor.init(netHex: 0xFFEE58)
        static let redSet = UIColor(netHex: 0xF73B3B)
        static let orangeSet = UIColor.init(netHex: 0xFFFFBB33)
    }
}

func getColorByName(color: String) -> UIColor{
    switch color {
    case "Orange":
        return UIColor.CustomColor.orangeSet
    case "Red":
        return UIColor.CustomColor.redSet
    case "Yellow":
        return UIColor.CustomColor.yellowSet
    default:
        return UIColor.CustomColor.yellowSet
    }
}

public extension UIView {
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

func pinBackground(_ view: UIView, to stackView: UIStackView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    stackView.insertSubview(view, at: 0)
    view.pin(to: stackView)
}
