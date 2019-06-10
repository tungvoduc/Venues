//
//  APIRequestProtocol.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case incorrectDataFormat
}

protocol APIRequestProtocol {
    associatedtype ResquestDataType
    associatedtype ResponseDataType
    
    func createRequest(_ data: ResquestDataType) throws -> URLRequest
    func parseResponse(_ data: Data) throws -> ResponseDataType
}
