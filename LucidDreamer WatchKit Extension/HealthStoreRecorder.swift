//
//  HealthStoreRecorder.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-08.
//

import Foundation
import HealthKit

protocol HealthRecorderObserver{
    func healthKitPermissionDenied()
    func healthKitReturnedData(samples:[HKQuantitySample])
    func healthKitReturnedNothing()
}

class HealthRecorder{
    
    private static var recorder:HealthRecorder = HealthRecorder()
    
    private var healthStore:HKHealthStore?
    
    private var notify:HealthRecorderObserver?
    
    private let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    private let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    
    private init(){
        
    }
    
    public static func getSharedInstance() -> HealthRecorder{
        return recorder
    }
    
    func addListener(obs:HealthRecorderObserver){
        self.notify = obs
    }
    
    func fetchData(startDate:Date, endDate:Date){
      
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query:HKSampleQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil){ (query:HKSampleQuery,sample:[HKSample]?,error:Error?) in
            
            guard let samples = sample else {
                self.notify?.healthKitReturnedNothing()
                return
            }
            
            if let samples = samples as? [HKQuantitySample]{
                if(samples.count >= 0){
                    self.notify?.healthKitReturnedData(samples: samples)
                }
                else{
                    self.notify?.healthKitReturnedNothing()
                }
            }
            else{
                self.notify?.healthKitReturnedNothing()
            }
        }
        
        self.healthStore?.execute(query)
        
    }
    
    func requestHealthKitAccess(){
        self.healthStore = HKHealthStore()
        let typesToRead = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore?.requestAuthorization(toShare: nil, read: typesToRead, completion: {(success,error) -> Void in
            
            //for some reason, there were errors or the request was not succesful
            if !(error == nil && success){
                self.notify?.healthKitPermissionDenied()
            }
        })
        
    }
    
}
