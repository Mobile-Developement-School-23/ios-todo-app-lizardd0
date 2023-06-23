//
//  DeadlineView.swift
//  tryui
//
//  Created by Елизавета Шерман on 23.06.2023.
//

import Foundation
import UIKit

class deadlineStack: UIStackView {
    private var date: Date? = nil

    
    func getDate() -> Date? {
        return date
    }
    
    let line: UIView = {
        let line = UIView()
        line.frame = CGRect()
        line.backgroundColor = .clear
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    func setDeadlineDate(dateD: Date?) {
        if let deadlineDate = dateD {
            date = deadlineDate
            deadlineSwitch.isOn = true
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            deadlineButton.setTitle(formatter.string(from: date!), for: .normal)
        } else {
            deadlineSwitch.isOn = false
            deadlineButton.setTitle("", for: .normal)
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .tertiarySystemBackground
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let deadlineButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect()
        button.backgroundColor = .tertiarySystemBackground
        button.setTitle("", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deadlineSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        return uiSwitch
    }()
    
    let stringStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .tertiarySystemBackground
        stack.axis = .horizontal
        stack.heightAnchor.constraint(equalToConstant: 38).isActive = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    let calendar: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.availableDateRange = DateInterval(start: .now, end: Date.distantFuture)
        return calendarView
    }()
    
    @objc private func setDateSwitch(deadlineSwitch: UISwitch) {
        if deadlineSwitch.isOn {
            date = Calendar.current.date(byAdding: .day, value: 1, to: .now)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            deadlineButton.setTitle(formatter.string(from: date!), for: .normal)
        } else {
            date = nil
            UIView.animate(withDuration: 0.5) {
                self.line.isHidden = true
                self.calendar.isHidden = true
            }
            deadlineButton.setTitle("", for: .normal)
        }
    }
    
    @objc func showCalendar() {
        if deadlineSwitch.isOn {
            UIView.animate(withDuration: 0.5) {
                self.line.isHidden.toggle()
                self.calendar.isHidden.toggle()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .tertiarySystemBackground
        axis = .vertical
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        labelStack.addArrangedSubview(textLabel)
        
        labelStack.addArrangedSubview(deadlineButton)
        
        stringStack.addArrangedSubview(labelStack)
        deadlineSwitch.addTarget(self, action: #selector(setDateSwitch), for: .valueChanged)
        stringStack.addArrangedSubview(deadlineSwitch)
        
        addArrangedSubview(stringStack)
        addArrangedSubview(line)
        line.isHidden = true
        addArrangedSubview(calendar)
        calendar.isHidden = true
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension deadlineStack: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        date = dateComponents?.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        deadlineButton.setTitle(formatter.string(from: date!), for: .normal)
    }
}
