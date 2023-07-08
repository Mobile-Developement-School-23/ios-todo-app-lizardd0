//
//  ScrollView.swift
//  tryui
//
//  Created by Елизавета Шерман on 24.06.2023.
//

import Foundation
import UIKit

class ScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGroupedBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
