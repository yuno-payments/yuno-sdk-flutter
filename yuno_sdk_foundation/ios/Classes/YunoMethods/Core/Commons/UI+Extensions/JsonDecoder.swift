//
//  JsonDecoder.swift
//  Pods
//
//  Created by steven on 11/09/24.
//
import Foundation
extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from jsonObject: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        return try self.decode(T.self, from: jsonData)
    }
}
