//
//  StackView.swift
//  tryui
//
//  Created by Елизавета Шерман on 23.06.2023.
//

import Foundation
import UIKit


class Stack: UIStackView {
    
    func configureLine() -> UIView {
        let line = UIView()
        line.frame = CGRect()
        line.backgroundColor = .systemGroupedBackground
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .tertiarySystemBackground
        axis = .vertical
        layer.cornerRadius = 16
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 17, bottom: 12, trailing: 16)
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
