//
//  DefaultNetworkingService.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 07.07.2023.
//

import Foundation

class DefaultNetworkingService: NetworkingService {
    private let baseURL = "https://beta.mrdekk.ru/todobackend"
    private let token = "duali"
    private var revision = 0
    private let urlSession = URLSession.shared
    let converter = Converter()
    
    var isDirty = false
    
    func getFromServer() async throws -> [TodoItem] {
        guard let url = URL(string: "\(baseURL)/list") else {
            throw NetworkingError.wrongURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)"]
        let (data, response) = try await urlSession.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 {
                throw NetworkingError.wrongURL // check pls
            }
        }
        let dataDecode = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = dataDecode.revision {
            self.revision = rev
        }
        return converter.serviceListToClassicList(list: dataDecode.list)
    }
    
    
    func updateDataOnServer(items: [TodoItem]) async throws -> [TodoItem] {
        guard let url = URL(string: "\(baseURL)/list") else {
            throw NetworkingError.wrongURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)", "X-Last-Known-Revision": "\(self.revision)"]
        let serviceList = converter.classicListToServiceList(list: items)
        let responseList = ResponseList(list: serviceList)
        request.httpBody = try JSONEncoder().encode(responseList)
        let (data, response) = try await urlSession.data(for: request)
        print(response)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 {
                isDirty = true
                throw NetworkingError.unexpectedResponse(response) // check pls
            }
        }
        let dataDecode = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = dataDecode.revision {
            self.revision = rev
        }
        return converter.serviceListToClassicList(list: dataDecode.list)
    }
    
    
    func getItemRequest(id: String) async throws {
        guard let url = URL(string: "\(baseURL)/list/\(id)") else {
            throw NetworkingError.wrongURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)"]
        let (data, response) = try await urlSession.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 ||  response.statusCode == 404 {
                isDirty = true
                throw NetworkingError.failedResponse(response) // check pls
            }
        }
        let dataDecode = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = dataDecode.revision {
            self.revision = rev
        }
    }
    
    
    func postRequest(item: TodoItem) async throws {
        guard let url = URL(string: "\(baseURL)/list") else {
            throw NetworkingError.wrongURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)", "X-Last-Known-Revision": "\(self.revision)"]
        print("\(self.revision)")
        let element = converter.classicItemtoService(item: item)
        print(element)
        let responseItem = ResponseItem(element: element)
        request.httpBody = try JSONEncoder().encode(responseItem)
        let (data, response) = try await urlSession.data(for: request)
        print(response)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 ||  response.statusCode == 404 {
                isDirty = true
                throw NetworkingError.failedResponse(response) // check pls
            }
        }
        let dataDecode = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = dataDecode.revision {
            self.revision = rev
        }
    }
    
    
    func putRequest(item: TodoItem) async throws {
        guard let url = URL(string: "\(baseURL)/list/\(item.id)") else {
            throw NetworkingError.wrongURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)", "X-Last-Known-Revision": "\(self.revision)"]
        let element = converter.classicItemtoService(item: item)
        let responseItem = ResponseItem(element: element)
        request.httpBody = try JSONEncoder().encode(responseItem)
        let (data, response) = try await urlSession.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 ||  response.statusCode == 404 {
                isDirty = true
                throw NetworkingError.failedResponse(response) // check pls
            }
        }
        let dataDecode = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = dataDecode.revision {
            self.revision = rev
        }
    }
    
    
    func deleteRequest(item: TodoItem) async throws {
        guard let url = URL(string: "\(baseURL)/list/\(item.id)") else {
            throw NetworkingError.wrongURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)", "X-Last-Known-Revision": "\(self.revision)"]
        let element = converter.classicItemtoService(item: item)
        let responseItem = ResponseItem(element: element)
        request.httpBody = try JSONEncoder().encode(responseItem)
        let (data, response) = try await urlSession.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 ||  response.statusCode == 404 {
                isDirty = true
                throw NetworkingError.failedResponse(response) // check pls
            }
        }
        let dataDecode = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = dataDecode.revision {
            self.revision = rev
        }
    }
}
