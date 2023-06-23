//
//  FileCache.swift
//  tryui
//
//  Created by Елизавета Шерман on 22.06.2023.
//

import Foundation

class FileCache {
    private(set) var listofitems = [TodoItem]()
    
    init(listofitems: [TodoItem] = [TodoItem]()) {
        self.listofitems = listofitems
    }
    
    func additem(item: TodoItem) {
        if let findi = listofitems.firstIndex(where: {item.id == $0.id}) {
            listofitems[findi] = item
        } else {
            listofitems.append(item)
        }
    }
    
    func deleteitem(id: String) -> TodoItem?{
        var item: TodoItem? = nil
        if let findi = listofitems.firstIndex(where: {id == $0.id}) {
            item = listofitems[findi]
            listofitems.remove(at: findi)
        }
        return item
    }
    
    func readfromfileJSON(filename: String){
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).json")
        var d: Data?
        do {
            d = try Data(contentsOf: fileURL)
        } catch {
            print("Ошибка получения Data: \(error.localizedDescription)")
            return
        }
        
        guard let data = d else {
            print("Error! Невозможно распаковать data")
            return
        }
        
        var dictionary: [String:Any] = [:]
        do {
            guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else
            {
                print("Error! Невозможно преобразовать данные")
                return
            }
            dictionary = dict
        } catch {
            print("Ошибка парсинга: \(error.localizedDescription)")
            return
        }
        
        guard let todoitemsarray = dictionary["ToDoItem"] as? [[String:Any]] else {
            print("Error! Невозможно преобразовать данные")
            return
        }
        
        var array: [TodoItem] = []
        for todoitemsdict in todoitemsarray {
            if let item  = TodoItem.parse(json: todoitemsdict) {
                array.append(item)
            }
        }
        self.listofitems = array
    }
    
    func savetofileJSON(filename: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).json")
        var array: [Any] = []
        for item in listofitems {
            array.append(item.json)
        }
        do {
            let dict: [String:Any] = ["ToDoItem": array]
            let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
            try data.write(to: fileURL)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func readfromfileCSV(filename: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).csv")
       
        do {
            var array: [TodoItem] = []
            let csvarray = try String(contentsOf: fileURL).components(separatedBy: "\n")
            for item in csvarray {
                if let item  = TodoItem.parse(csv: item) {
                    array.append(item)
                }
            }
            self.listofitems = array
        } catch {
            print("Ошибка получения Data: \(error.localizedDescription)")
        }
        
    }
    
    
    func savetofileCSV(filename: String) {
        let str = "id,text,importance,deadline,flag,createdate,changedate"
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).csv")
        var array: [String] = [str]
        for item in listofitems {
            array.append(item.csv)
        }
        
        let strcsv = array.joined(separator: "\n")
        do {
            try strcsv.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}

