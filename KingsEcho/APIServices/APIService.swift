//
//  APIService.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import Foundation

class APIService : NSObject {
    
    private let sourcesURL = URL(string: "https://dummy.restapiexample.com/api/v1/employees")!
    
    func apiToGetEmployeeData(completion : @escaping (Employees) -> () ) {
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let empData = try! jsonDecoder.decode(Employees.self, from: data)
                let emd = try? jsonDecoder.decode(Employees.self, from: data)
                
                    completion(empData)
            }
            
        }.resume()
    }
}
