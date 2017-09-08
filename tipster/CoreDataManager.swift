//
//  CoreDataManager.swift
//  tipster
//
//  Created by Amy Giver on 9/7/17.
//  Copyright © 2017 Anna Propas. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func saveEvent(tipAmount: Double, tipPercentage: Int, totalPaid: Double, originalBill: Double) -> Bool {
        let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: moc) as! Expense
        newEvent.tipAmount = tipAmount
        newEvent.tipPercent = Int32(tipPercentage)
        newEvent.total = totalPaid
        newEvent.originalBill = originalBill
        newEvent.date = Date() as NSDate
        if moc.hasChanges {
            do {
                try moc.save()
                return true
            }
            catch {
                print("Error with saving \(error)")
                return false
            }
        }
        return false
    }
    
    public func fetchEvents() -> [Expense]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        do {
            let results = try moc.fetch(request)
            let expenses = results as! [Expense]
            return expenses
        }
        catch {
            print("Whoops")
            return nil
        }
    }
}
