//
//  ImportanceView.swift
//  tryui
//
//  Created by Елизавета Шерман on 23.06.2023.
//

import Foundation
import UIKit

class ImportanceStack: UIStackView {
    var importance: TodoItem.Importance = TodoItem.Importance.ordinary

    var importanceSwitch: UISegmentedControl!
    
    private func getImportanceSwitch() -> UISegmentedControl {
        let check = UISegmentedControl()
        let twoPoints = UIImage(systemName: "exclamationmark.2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .bold))?.withTintColor(.red, renderingMode: .alwaysOriginal)
        check.insertSegment(with: UIImage(systemName: "arrow.down"), at: 0, animated: false)
        check.insertSegment(withTitle: "нет", at: 1, animated: false)
        check.insertSegment(with: twoPoints, at: 2, animated: false)

        check.selectedSegmentIndex = 1
        check.widthAnchor.constraint(equalToConstant: 150).isActive = true

        check.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        check.translatesAutoresizingMaskIntoConstraints = false
        return check
    }
    
    @objc func changeSwitch(importanceCheck: UISegmentedControl) {
        switch importanceCheck.selectedSegmentIndex{
        case 0:
            importance = TodoItem.Importance.unimportant
        case 1:
            importance = TodoItem.Importance.ordinary
        case 2:
            importance = TodoItem.Importance.important
        default:
            importance = TodoItem.Importance.ordinary
        }
        
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    
    func getImportance() -> TodoItem.Importance? {
        return importance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        importanceSwitch = getImportanceSwitch()
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        axis = .horizontal
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(label)
        addArrangedSubview(importanceSwitch)
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
