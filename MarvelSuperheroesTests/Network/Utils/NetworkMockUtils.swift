//
//  NetworkMockUtils.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import OHHTTPStubs

public class NetworkStub {
    
    public static let `default` = NetworkStub()
    
    public static let defaultRequestResponseTime = TimeInterval(0.5)

    public func defaultStub(urlEndsWith: String, jsonMock: String, type: AnyClass) {
        stub(condition: pathEndsWith(urlEndsWith) ) { _ in
            let stubPath = OHPathForFile("\(jsonMock).json", type)
            let response = fixture(filePath: stubPath ?? "",
                                   headers: ["Content-Type": "application/json"])
            response.requestTime = NetworkStub.defaultRequestResponseTime
            return response
        }
    }

    public func removeStubs() {
        HTTPStubs.removeAllStubs()
    }
}

public class TestClass {
    init() {}
}

public func bundle() -> Bundle {
    return Bundle(for: TestClass.self)
}

public final class JSONReaderUtils {
    
    public static func getData(for file: String) -> [String: Any] {
        let data = readDictionaryJson(fileName: file)
        return data ?? [:]
    }

    public static func getDataArray(for file: String) -> [[String: Any]] {
        let data = readArrayJson(fileName: file)
        return data ?? []
    }

    public static func readDictionaryJson(fileName: String) -> [String: Any]? {
        do {
            if let file = bundle().url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    return object
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    public static func readArrayJson(fileName: String) -> [[String: Any]]? {
        do {
            if let file = bundle().url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    return object
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
