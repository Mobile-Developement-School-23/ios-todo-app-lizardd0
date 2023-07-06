//
//  URLSession.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 06.07.2023.
//

import Foundation


extension URLSession {
    func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data,
                let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        }
    }
}
