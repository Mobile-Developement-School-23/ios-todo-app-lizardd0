//
//  ToDoItem.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    var flag: Bool
    let createdate: Date
    let changedate: Date?
    static let splitter: String = ","

    enum Importance: String {
        case unimportant
        case important
        case ordinary
    }
    
    
    enum CodingKeys: String {
            case id
            case text
            case importance
            case deadline
            case flag
            case createdate
            case changedate
        }
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, flag: Bool = false, createdate: Date = Date(), changedate: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.flag = flag
        self.createdate = createdate
        self.changedate = changedate
    }
    
}


extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard
            let dict = json as? [String: Any],
            let id = dict[CodingKeys.id.rawValue] as? String,
            let text = dict[CodingKeys.text.rawValue] as? String,
            let flag = dict[CodingKeys.flag.rawValue] as? Bool,
            let createdate = dict[CodingKeys.createdate.rawValue] as? Double
        else {
            return nil
        }
        
        let createdatejson = Date(timeIntervalSince1970: createdate)
        
        let importancejson: Importance
        if let importance = dict[CodingKeys.importance.rawValue] as? String {
            if importance == "unimportant" {
                importancejson = Importance.unimportant
            } else if importance == "important"{
                importancejson = Importance.important
            } else {
                importancejson = Importance.ordinary
            }
        } else {
            importancejson = Importance.ordinary
        }
        
        
        let deadline: Date?
        if let deadlinestamp = dict[CodingKeys.deadline.rawValue] as? Double {
            deadline = Date(timeIntervalSince1970: deadlinestamp)
        } else {
            deadline = nil
        }
        
        let changedate: Date?
        if let changedatestamp = dict[CodingKeys.changedate.rawValue] as? Double {
            changedate = Date(timeIntervalSince1970: changedatestamp)
        } else {
            changedate = nil
        }
        
        let todo = TodoItem(id: id, text: text, importance: importancejson, deadline: deadline, flag: flag, createdate: createdatejson, changedate: changedate)
        
        return todo
    }
    
    
    var json: Any {
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "flag": flag,
            "createdate": createdate.timeIntervalSince1970
        ]
        
        if importance != Importance.ordinary {
            dict["importance"] = "\(importance)"
        }
        
        if let deadline = deadline {
            dict["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let changedate = changedate {
            dict["changedate"] = changedate.timeIntervalSince1970
        }
        
        return dict
    }
    
    static func parse(csv: String) -> TodoItem? {
            let csvstring = csv.components(separatedBy: TodoItem.splitter)
            
            if csvstring.count == 7, csvstring[0] != "", csvstring[1] != "",
                let createdate = Double(csvstring[5]) {
                let createdatecsv = Date(timeIntervalSince1970: createdate)
                
                let deadlinecsv: Date?
                if let deadline = Double(csvstring[3]) {
                    deadlinecsv = Date(timeIntervalSince1970: deadline)
                } else {
                    deadlinecsv = nil
                }
                   
                let changedatecsv: Date?
                if let changedate = Double(csvstring[6]) {
                    changedatecsv = Date(timeIntervalSince1970: changedate)
                } else {
                    changedatecsv = nil
                }
                
                let flagcsv: Bool
                if csvstring[4] == "true" {
                    flagcsv = true
                } else {
                    flagcsv = false
                }
                
                let importancecsv: Importance
                if csvstring[2] == "important" {
                    importancecsv = Importance.important
                } else if csvstring[2] == "unimportant" {
                    importancecsv = Importance.unimportant
                } else {
                    importancecsv = Importance.ordinary
                }
                
                
                let todo = TodoItem(id: csvstring[0], text: csvstring[1], importance: importancecsv, deadline: deadlinecsv, flag: flagcsv, createdate: createdatecsv, changedate: changedatecsv)
                
                return todo
            }
            return nil
        }
    
    var csv: String {
        var csvstring = [String]()
        csvstring.append(id)
        csvstring.append(text)
        if importance != Importance.ordinary {
            csvstring.append("\(importance)")
        } else {
            csvstring.append("")
        }
        
        if let deadline = deadline {
            csvstring.append(String(deadline.timeIntervalSince1970))
        } else {
            csvstring.append("")
        }
        
        csvstring.append("\(flag)")
        
        let createstr = String(createdate.timeIntervalSince1970)
        csvstring.append(createstr)
        
        if let changedate = changedate {
            csvstring.append(String(changedate.timeIntervalSince1970))
        } else {
            csvstring.append("")
        }
        return csvstring.joined(separator: TodoItem.splitter)
    }
}


