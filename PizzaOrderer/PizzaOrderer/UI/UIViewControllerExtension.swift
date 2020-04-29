//
//  UIViewControllerExtension.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 09..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {

    struct StatusBarVisibility {
        static var shouldHide = false
        static var isAnimating = false
    }

    var screenBounds: CGRect { UIScreen.main.bounds }

    func showAlertDialog() {

        if !StatusBarVisibility.isAnimating {

            StatusBarVisibility.isAnimating = true

            let window = UIApplication.shared.delegate?.window
            let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let windowFrame = window??.frame ?? CGRect()
            let withoutSafeArea = view.safeAreaInsets.top == 0

            let alertView = AlertView()
            let spacingView = UIView()

            alertView.isHidden = true
            spacingView.isHidden = true

            window??.windowLevel = .statusBar
            window??.addSubview(alertView)
            window??.addSubview(spacingView)
            window??.bringSubviewToFront(alertView)

            alertView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(statusBarHeight)
            }

            spacingView.backgroundColor = .white

            spacingView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(statusBarHeight)
            }

            let showTransformTranslation = CGAffineTransform(translationX: 0, y: -statusBarHeight)
            let hideTransformTranslation = withoutSafeArea ? CGAffineTransform(translationX: 0, y: -(2 * statusBarHeight)) : showTransformTranslation

            alertView.transform = hideTransformTranslation
            spacingView.transform = showTransformTranslation

            StatusBarVisibility.shouldHide = true
            window??.rootViewController?.setNeedsStatusBarAppearanceUpdate()

            if withoutSafeArea {
                window??.frame = CGRect(x: 0, y: statusBarHeight, width: windowFrame.width, height: windowFrame.height - statusBarHeight)
                spacingView.isHidden = false
            }

            alertView.isHidden = false

            UIView.animate(withDuration: 0.3, animations: {

                alertView.transform = withoutSafeArea ? showTransformTranslation : .identity
            }) { _ in

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

                    UIView.animate(withDuration: 0.3, animations: {
                        alertView.transform = hideTransformTranslation
                    }) { _ in

                        if withoutSafeArea {
                            window??.frame = windowFrame
                        }

                        StatusBarVisibility.shouldHide = false
                        window??.rootViewController?.setNeedsStatusBarAppearanceUpdate()

                        alertView.removeFromSuperview()
                        spacingView.removeFromSuperview()

                        StatusBarVisibility.isAnimating = false
                    }
                }
            }
        }
    }
}
