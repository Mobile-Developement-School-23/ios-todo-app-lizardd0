//
//  TaskView.swift
//  tryui
//
//  Created by Елизавета Шерман on 23.06.2023.
//

import Foundation
import UIKit

class TaskText: UITextView {
    private var isChanged: ((Bool) -> ())?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .tertiarySystemBackground
        text = "Что нужно сделать?"
        textColor = .lightGray
        font = .systemFont(ofSize: 17)
        textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        layer.cornerRadius = 16
        isScrollEnabled = false
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func callbackChanged(callback: @escaping (Bool) -> ()) {
        isChanged = callback
    }
    
    func getText() -> String? {
        if textColor == .lightGray {
            return nil
        }
        return text
    }
    
}

extension TaskText: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что нужно сделать?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        isChanged?(!textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
}
