//
//  APIManager.swift
//  testPol
//
//  Created by Pavel Boryseiko on 26/7/17.
//  Copyright © 2017 GRIDSTONE. All rights reserved.
//

import UIKit
import MPOLKit
import Alamofire
import Unbox

public struct SearchResult<T>: Unboxable {

    public let range: CountableRange<Int>
    public let results: [T]

    public init(unboxer: Unboxer) throws {

        let start: Int = try unboxer.unbox(key: CodingKeys.start.rawValue)
        let end: Int = try unboxer.unbox(key: CodingKeys.end.rawValue)

        range = start..<end
        results = try unboxer.unbox(key: CodingKeys.results.rawValue)

    }

    private enum CodingKeys: String {
        case start = "firstItem"
        case end = "lastItem"
        case count = "searchResultsTotal"
        case results = "searchResults"
    }

}

class APIManager: NSObject {

    open func searchEntityOperation<P: TestEntity>(from source: EntitySource, with parameters: Parameterisable, completion: ((DataResponse<SearchResult<P>>) -> Void)? = nil) -> UnboxingGroupOperation<SearchResult<P>> {
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users")!)
        return unboxOperation(with: request, completion: completion)
    }

    // MARK : - Internal Utilities

    private func unboxOperation<T>(with urlRequest: URLRequest, completion: ((DataResponse<T>) -> Void)?) -> UnboxingGroupOperation<T> {
        let provider = URLJSONRequestOperation(urlRequest: urlRequest, sessionManager: SessionManager())
        let unboxer = UnboxingOperation<T>(provider: provider)

        let group = UnboxingGroupOperation(provider: provider, unboxer: unboxer) { (response: DataResponse<T>) in
            completion?(response)
        }

        return group
    }
}
