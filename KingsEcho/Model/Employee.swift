//
//  Employee.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import Foundation

// Model represent simple data structure

struct Employees: Decodable {
    let status: String
    let data: [EmployeeData]
}

struct EmployeeData: Decodable {
    let id, employeeSalary, employeeAge : Int
    let employeeName : String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}
