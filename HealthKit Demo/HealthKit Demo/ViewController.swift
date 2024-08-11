//
//  ViewController.swift
//  HealthKit Demo
//
//  Created by Amit on 24/07/24.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    //MARK: - IBOutlet's
    @IBOutlet weak var stepsCount: UILabel!
    @IBOutlet weak var sleepingHrs: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: - Property
    var healthStore = HKHealthStore()
    
    //MARK: - viewDidLoad
    /*
     this method is calling for initial when this screen will appear
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        self.setUpInitial()
        self.askForHealthKitPermissions()
    }
    
    /*
     Show initial data on screen
     */
    func setUpInitial() {
        self.stepsCount.text = "0 step"
        self.sleepingHrs.text = "Sleep Time : 00 Hr 00 min 00 sec"
        self.energyLabel.text = "Energy : 0 kcal"
    }
    
    // Ask For Permisssions for Get the data from HealthKit
    func askForHealthKitPermissions() {
        //Set Types we need to take permissions set here
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,HKObjectType.quantityType(forIdentifier: .stepCount)!,HKObjectType.categoryType(forIdentifier:HKCategoryTypeIdentifier.sleepAnalysis)!])
        // Request Authorization methods
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            // Successfully get permissions
            if success {
                let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                let startDateString = "\(startDate!)"
                let endDateString = "\(Date())"
                // Call Health Data Gets method for Current Date
                self.fetchHealthData(startDateString, endDateString)
            }
        }
    }
    
    // User can select the date from datepicker then show Health data based on selected date on screen
    @IBAction func datePickerChanged(_ sender: Any) {
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: datePicker.date)
        let startDateString = "\(startDate!)"
        let endDateString = "\(datePicker.date)"
        // Call Health Data Gets method for Selected Date
        self.fetchHealthData(startDateString,endDateString)
    }
    
}

extension ViewController {
    // Access Steps, Sleep Time and Active Energy(Calories Burn)
    func fetchHealthData(_ startDate: String, _ endDate: String) {
        // Formatting Start Date
        let isoDate = startDate
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let startDate = dateFormatter.date(from:isoDate)!
        
        // Formatting End Date
        let endIsoDate = endDate
        let endDateFormatter = DateFormatter()
        endDateFormatter.timeZone = .autoupdatingCurrent
        endDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let endDate = dateFormatter.date(from:endIsoDate)!
        // Call Steps Count Function and get steps count
        self.getSteps(startDate: startDate, endDate: endDate, completion: { steps in
            DispatchQueue.main.async {
                self.stepsCount.text = "\(steps) step"
                // Call Sleeping Hr Method
                self.retrieveSleepAnalysis(startDate: startDate, endDate: endDate)
            }
        })
    }
    
    // Get and Set Steps Counts by start and End Date
    func getSteps(startDate:Date,endDate:Date,completion: @escaping (Int) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            completion(Int(sum.doubleValue(for: HKUnit.count())))
        }
        healthStore.execute(query)
    }
    
    // Get and Set Sleeping Hrs by start and End Date
    func retrieveSleepAnalysis(startDate:Date,endDate:Date) {
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let predicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .strictEndDate
            )
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    return
                }
                if let result = tmpResult {
                    // do something with my data
                    if result.count != 0 {
                        for item in result {
                            if let sample = item as? HKCategorySample {
                                let startDate = sample.startDate
                                let endDate = sample.endDate
                                
                                let diffComponents = Calendar.current.dateComponents([.hour,.minute,.second], from: startDate, to: endDate)
                                DispatchQueue.main.async {
                                    self.sleepingHrs.text = "Sleep Time : \(diffComponents.hour ?? 00) Hr \(diffComponents.minute ?? 00) min \(diffComponents.second ?? 00) sec"
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.sleepingHrs.text = "Sleep Time : 00 Hr 00 min 00 sec"
                        }
                    }
                }
                self.getCaloriesBurn(startDate: startDate, endDate: endDate)
            }
            
            // finally, we execute our query
            healthStore.execute(query)
        }
    }
    
    // Get and Set Calories Burn by start and End Date
    func getCaloriesBurn(startDate:Date,endDate:Date) {
        guard let energyType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Sample type not available")
            return
        }
        let last24hPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        let energyQuery = HKSampleQuery(sampleType: energyType,
                                        predicate: last24hPredicate,
                                        limit: HKObjectQueryNoLimit,
                                        sortDescriptors: nil) {
            (query, sample, error) in
            
            guard
                error == nil,
                let quantitySamples = sample as? [HKQuantitySample] else {
                return
            }
            
            let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
            DispatchQueue.main.async {
                self.energyLabel.text = String(format: "Energy: %.0f kcal", total)
            }
        }
        HKHealthStore().execute(energyQuery)
    }
    
}
