//
//  ViewController.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var employeeViewModel : EmployeesViewModel!
    
    @IBOutlet weak var textFiled: UITextView!
    
    @IBOutlet var tableView: UITableView!
    
    var data = [EmployeeData]()
    
//    private var dataSource : EmployeeTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        callToViewModelForUIUpdate()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func callToViewModelForUIUpdate(){
        self.employeeViewModel = EmployeesViewModel()
        
        self.employeeViewModel.bindEmployeeViewModelToController = {self.updateDataSource()}
    }
    
    func updateDataSource(){
        print("============\(self.employeeViewModel.empData.data)")
        data = self.employeeViewModel.empData.data
        DispatchQueue.main.async {
//            self.textFiled.text = self.employeeViewModel.empData.data.description
            self.tableView.reloadData()
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table1", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].employeeName
        return cell
    }
    
}
