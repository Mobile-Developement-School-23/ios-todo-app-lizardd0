//
//  ServiceTodoItem.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 07.07.2023.
//

import Foundation
import UIKit

struct ServiceTodoIem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int?
    let flag: Bool
    let color: String?
    let createdate: Int
    let changedate: Int?
    let lastupdatedby: String
    
    init(id: String = UUID().uuidString, text: String, importance: String, deadline: Int? = nil, flag: Bool = false, color: String? = "#FF0000", createdate: Int = Int(Date().timeIntervalSince1970), changedate: Int? = nil, lastupdatedby: String) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.flag = flag
        self.color = color
        self.createdate = createdate
        self.changedate = changedate
        self.lastupdatedby = lastupdatedby
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case flag = "done"
        case color
        case createdate = "created_at"
        case changedate = "changed_at"
        case lastupdatedby = "last_updated_by"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.text, forKey: .text)
        var imp: String = ""
        switch self.importance {
        case TodoItem.Importance.unimportant.rawValue:
            imp = "low"
        case TodoItem.Importance.ordinary.rawValue:
            imp = "basic"
        case TodoItem.Importance.important.rawValue:
            imp = "important"
        default:
            break
        }
        try container.encode(imp, forKey: .importance)
        try container.encodeIfPresent(self.deadline, forKey: .deadline)
        try container.encode(self.flag, forKey: .flag)
        try container.encodeIfPresent(self.color, forKey: .color)
        try container.encode(self.createdate, forKey: .createdate)
        try container.encodeIfPresent(self.changedate, forKey: .changedate)
        try container.encode(self.lastupdatedby, forKey: .lastupdatedby)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        let baseImportance = try container.decode(String.self, forKey: .importance)
        var newImportance = TodoItem.Importance.ordinary
        switch baseImportance {
        case "low":
            newImportance = TodoItem.Importance.unimportant
        case "basic":
            newImportance = TodoItem.Importance.ordinary
        case "important":
            newImportance = TodoItem.Importance.important
        default:
            break
        }
        self.importance = newImportance.rawValue
        self.deadline = try container.decodeIfPresent(Int.self, forKey: .deadline)
        self.flag = try container.decode(Bool.self, forKey: .flag)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.createdate = try container.decode(Int.self, forKey: .createdate)
        self.changedate = try container.decode(Int.self, forKey: .changedate)
        self.lastupdatedby = try container.decode(String.self, forKey: .lastupdatedby)
    }
}

struct ResponseList: Codable {
    var status: String?
    var list = [ServiceTodoIem]()
    var revision: Int?
    
    init(status: String? = nil, list: [ServiceTodoIem], revision: Int? = nil) {
        self.status = status
        self.list = list
        self.revision = revision
    }
}

struct ResponseItem: Codable {
    var status: String?
    var element: ServiceTodoIem
    var revision: Int?
    
    init(status: String? = nil, element: ServiceTodoIem, revision: Int? = nil) {
        self.status = status
        self.element = element
        self.revision = revision
    }
}


enum NetworkingError: Error {
    case wrongURL
    case unexpectedResponse(URLResponse)
    case failedResponse(HTTPURLResponse)
}


class Converter {
    func serviceItemToClassic(item: ServiceTodoIem) -> TodoItem {
        var importance: TodoItem.Importance
        switch item.importance {
        case "low": importance = TodoItem.Importance.unimportant
        case "basic": importance = TodoItem.Importance.ordinary
        case "important": importance = TodoItem.Importance.important
        default: importance = TodoItem.Importance.ordinary
        }
        var deadline: Date?
        if let intdate = item.deadline {
            deadline = Date(timeIntervalSince1970: TimeInterval(intdate))
        }
        let createdate = Date(timeIntervalSince1970: TimeInterval(item.createdate))
        var changedate: Date?
        if let intdate = item.changedate {
            changedate = Date(timeIntervalSince1970: TimeInterval(intdate))
        }
        let todoitem = TodoItem(id: item.id, text: item.text, importance: importance, deadline: deadline, flag: item.flag, createdate: createdate, changedate: changedate)
        return todoitem
    }
    
    func serviceListToClassicList(list: [ServiceTodoIem]) -> [TodoItem] {
        var listofitems = [TodoItem]()
        for item in list {
            let todoitem = serviceItemToClassic(item: item)
            listofitems.append(todoitem)
        }
        return listofitems
    }
    
    func classicItemtoService(item: TodoItem) -> ServiceTodoIem {
        var importance: String
        switch item.importance {
        case TodoItem.Importance.unimportant: importance = "low"
        case TodoItem.Importance.important: importance = "important"
        case TodoItem.Importance.ordinary: importance = "basic"
        }
        var deadline: Int?
        if let date = item.deadline?.timeIntervalSince1970 {
            deadline = Int(date)
        }
        let createdate = Int(item.createdate.timeIntervalSince1970)
        var changedate: Int?
        if let date = item.changedate?.timeIntervalSince1970 {
            changedate = Int(date)
        }
//        let lastUpdatedBy = UIDevice.current.identifierForVendor?.uuidString ?? "iPhone"
        let serviceitem = ServiceTodoIem(id: item.id, text: item.text,
                                         importance: importance,
                                         deadline: deadline,
                                         flag: item.flag,
                                         color: "#FF0000",
                                         createdate: createdate,
                                         changedate: changedate,
                                         lastupdatedby: "device")
        
        return serviceitem
    }
    
    func classicListToServiceList(list: [TodoItem]) -> [ServiceTodoIem] {
        var listofitems = [ServiceTodoIem]()
        for item in list {
            let serviceitem = classicItemtoService(item: item)
            listofitems.append(serviceitem)
        }
        return listofitems
    }
    
    
}
