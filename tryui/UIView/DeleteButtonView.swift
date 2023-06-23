//
//  DeleteButtonView.swift
//  tryui
//
//  Created by Елизавета Шерман on 23.06.2023.
//

import Foundation
import UIKit

class deleteButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Удалить", for: .normal)
        setTitleColor(.red, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
        layer.cornerRadius = 16
        backgroundColor = .tertiarySystemBackground
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        isEnabled = false
//        addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
