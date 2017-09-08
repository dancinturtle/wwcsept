//
//  ViewController.swift
//  tipster
//
//  Created by Anna Propas on 7/6/17.
//  Copyright © 2017 Anna Propas. All rights reserved.
//

import UIKit
//import CoreData

class ViewController: UIViewController {
    var billString = "0"
    var billNum = Double(0.00)
    var model: CoreDataManager!
    
    // add outlets for all targets
    
    
    @IBOutlet var checkmark: [UIButton]!
    
    @IBOutlet weak var billTotal: UILabel!
    @IBOutlet weak var tenPercentTip: UILabel!
    @IBOutlet weak var tenPercentTotal: UILabel!
    @IBOutlet weak var fifteenPercentTip: UILabel!
    @IBOutlet weak var fifteenPercentTotal: UILabel!
    @IBOutlet weak var twentyPercentTip: UILabel!
    @IBOutlet weak var twentyPercentTotal: UILabel!
    @IBOutlet weak var decimalButton: UIButton!
    
    @IBAction func calculatorButtonWasPressed(_ sender: UIButton) {
        if (billString == "0") {
            billString = String(sender.tag)
        } else {
            billString += String(sender.tag)
        }
        updateDisplay()
    }
    
    @IBAction func checkmarkWasPressed(_ sender: UIButton) {
        print("Checkmark pressed")
        var tipPercentage: Int = 0
        var totalSpent: Double = 0
        var tipAmount: Double = 0
        for check in checkmark {
            check.setImage(#imageLiteral(resourceName: "checkmarkbw"), for: .normal)
        }
        sender.setImage(#imageLiteral(resourceName: "checkmarkgreen"), for: .normal)
        switch sender.tag {
        case 1:
            tipPercentage = 10
            totalSpent = Double(tenPercentTotal.text!)!
            tipAmount = Double(tenPercentTip.text!)!
            
           
        case 2:
            tipPercentage = 15
            totalSpent = Double(fifteenPercentTotal.text!)!
            tipAmount = Double(fifteenPercentTip.text!)!
            
        case 3:
            tipPercentage = 20
            totalSpent = Double(twentyPercentTotal.text!)!
            tipAmount = Double(twentyPercentTip.text!)!
        default:
            print("Someting went wrong")
        }
        print("Our data tipPercentage: \(tipPercentage), totalSpent: \(totalSpent), tipAmount: \(tipAmount), originalBill: \(billNum)")
        saveAlert(message: "You just spent \(totalSpent)", title: "Save this expense?", tipAmount: tipAmount, tipPercentage: tipPercentage, totalPaid: totalSpent)
    }
    
    func saveAlert(message: String, title: String, tipAmount: Double, tipPercentage: Int, totalPaid: Double){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action) in
            print("Saving")
            if(self.model.saveEvent(tipAmount: tipAmount, tipPercentage: tipPercentage, totalPaid: totalPaid, originalBill: self.billNum)){
                
                self.billString = "0"
                self.billNum = 0.00
                self.decimalButton.isEnabled = true
                self.updateDisplay()
                for check in self.checkmark {
                    check.setImage(#imageLiteral(resourceName: "checkmarkbw"), for: .normal)
                }
            }
            else {
                print("could not save")
            }
            alert.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            print("Canceling")
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    // add actions for clear and decimal
    @IBAction func clearButtonWasPressed(_ sender: UIButton) {
        billString = "0"
        billNum = 0.00
        decimalButton.isEnabled = true
        updateDisplay()
    }
    @IBAction func decimalButtonWasPressed(_ sender: UIButton) {
        sender.isEnabled = false
        billString += "."
        updateDisplay()
    }
    func fetchExpenses() {
        if let expenses = model.fetchEvents(){
            for expense in expenses{
                print("We had an expense of $\(expense.total) on \(expense.date!)")
            }
        }
        else {
            print("No expenses to view")
        }
    }
    
    // add function to handle updating the view
    
    func updateDisplay() {
        billNum = Double(billString)!
        
        billTotal.text = billString
        
        tenPercentTip.text = String(billNum * 0.1)
        tenPercentTotal.text = String(billNum * 1.1)
        fifteenPercentTip.text = String(billNum * 0.15)
        fifteenPercentTotal.text = String(billNum * 1.15)
        twentyPercentTip.text = String(billNum * 0.2)
        twentyPercentTotal.text = String(billNum * 1.2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = CoreDataManager()
        for check in checkmark {
            check.imageView?.contentMode = .scaleAspectFit
            
        }
        fetchExpenses()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

