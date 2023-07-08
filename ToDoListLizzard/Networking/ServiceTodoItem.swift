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
