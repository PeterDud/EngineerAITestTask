//
//  Extensions.swift
//  EngineerAITestTask
//
//  Created by Peter Dudar  on 26/10/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String : String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
    
    func getQueryValue(by key: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == key })?.value
    }
}
