//
//  NetworkingService.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 07.07.2023.
//

import Foundation

protocol NetworkingService {
    func getFromServer() async throws -> [TodoItem]
    func updateDataOnServer(items: [TodoItem]) async throws -> [TodoItem]
    func getItemRequest(id: String) async throws
    func postRequest(item: TodoItem) async throws
    func putRequest(item: TodoItem) async throws
    func deleteRequest(item: TodoItem) async throws
}
