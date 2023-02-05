//
//  UIViewExtensions.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

import UIKit

extension UIView {
    func fullFit() {
        guard let parent = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parent.topAnchor.constraint(equalTo: topAnchor),
            parent.trailingAnchor.constraint(equalTo: trailingAnchor),
            parent.bottomAnchor.constraint(equalTo: bottomAnchor),
            parent.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
}
