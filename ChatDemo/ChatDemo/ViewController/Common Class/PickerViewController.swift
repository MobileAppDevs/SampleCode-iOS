//
//  PickerViewController.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 23/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import Foundation

enum PickerType{
    case date
    case text
}

class PickerViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var pickerBGView             : UIView!
    @IBOutlet weak var pickerView               : UIPickerView!
    @IBOutlet weak var datePicker               : UIDatePicker!
    @IBOutlet weak var pickerToolbarView        : UIView!
    @IBOutlet weak var btnDone                  : UIButton!
    @IBOutlet weak var btnCancel                : UIButton!
    var pickerType                              : PickerType!
    var doneButtonTextColor                     : UIColor?
    var cancelButtonTextColor                   : UIColor?
    var doneButtonText                          : String?
    var cancelButtonText                        : String?
    var selectedIndex                           : Int?
    var pickerRowHeight                         : CGFloat?
    private var pickerDoneBlock                 : PickerDone!
    private var datepickerDoneBlock             : DatePickerDone!
    var pickerDataArray                         : [Any]             = []
    internal typealias PickerDone                                   = (_ value: String, _ index : Int?) -> Void
    internal typealias DatePickerDone                               = (_ value: Date) -> Void
    static let sharedInstance                   : PickerViewController = {
        let instance = UIStoryboard(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        return instance
    }()
    

    //end
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDone.setTitle("DONE", for: .normal)
        self.btnCancel.setTitle("CANCEL", for: .normal)
        //Set Picker at 0 Index
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    //end

    //MARK: - IBAction
    @IBAction func btnDoneTapped(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
        
        if self.pickerType == .date{
            self.dismiss(animated: true) {
                self.datepickerDoneBlock(self.datePicker.date)
            }
        }else{
            let value : String?
            
            if pickerDataArray.count == 0{
                return
            }else{
                value = pickerDataArray[self.selectedIndex ?? 0] as? String
            }
            
            self.dismiss(animated: true) {
                self.pickerDoneBlock(value ?? "", self.selectedIndex ?? 0)
            }
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    //end
}

//MARK: - UIPickerView Delegate, DataSource And Functions
extension PickerViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    
    //MARK: - Open Picker View
    /*
     - This is a class function which is used to open picker on a ViewController
     */
    
    class func openPickerView(viewC: UIViewController, dataArray: [Any], completionHandler: @escaping PickerDone) {
        
        PickerViewController.sharedInstance.pickerDoneBlock = completionHandler
        
        PickerViewController.sharedInstance.openPicker(viewC: viewC, dataArray: dataArray, completionHandler: completionHandler)
    }
    
    func openPicker(viewC: UIViewController, dataArray: [Any], completionHandler: @escaping PickerDone){
        
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewC.present(self, animated: true, completion: nil)
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        
        self.datePicker.isHidden = true
        self.pickerView.isHidden = false
        
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
        
        self.pickerType = .text
        
        self.pickerDataArray = dataArray
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.selectedIndex = 0
        
        self.btnDone.setTitle(doneButtonText ?? "DONE", for: .normal)
        self.btnDone.setTitleColor(doneButtonTextColor ?? UIColor.black, for: .normal)
        
        self.btnCancel.setTitle(cancelButtonText ?? "CANCEL", for: .normal)
        self.btnCancel.setTitleColor(cancelButtonTextColor ?? UIColor.black, for: .normal)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.pickerDataArray[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerRowHeight ?? 40
    }
}

//MARK: - UIDatePicker Delegate, DataSource and Functions
extension PickerViewController{
    //MARK: - Open Date Picker View
    /*
     - This is a class function which is used to open date picker on a ViewController
     */
    
    class func openDatePickerView(viewC: UIViewController, currentDate: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, pickerMode: UIDatePicker.Mode, completionHandler: @escaping DatePickerDone) {
        
        PickerViewController.sharedInstance.datepickerDoneBlock = completionHandler
        
        PickerViewController.sharedInstance.openDatePicker(viewC: viewC, currentDate: currentDate, minimumDate: minimumDate, maximumDate: maximumDate, pickerMode: pickerMode, completionHandler: completionHandler)
    }
    
    func openDatePicker(viewC: UIViewController, currentDate: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, pickerMode: UIDatePicker.Mode, completionHandler: @escaping DatePickerDone){
        
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewC.present(self, animated: true, completion: nil)
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        self.datePicker.isHidden = false
        self.pickerView.isHidden = true
        
        self.pickerType = .date
        
        self.datePicker.datePickerMode = pickerMode
        
        self.datePicker.maximumDate = maximumDate //?? NSDate() //NSDate(timeIntervalSinceNow: -1.577e+8)
        self.datePicker.date = currentDate ?? Date()
        self.datePicker.minimumDate = minimumDate //?? NSDate() //NSDate(timeIntervalSince1970: -1000000000)
        
        self.btnDone.setTitle(doneButtonText ?? "DONE", for: .normal)
        self.btnDone.setTitleColor(doneButtonTextColor ?? UIColor.black, for: .normal)
        
        self.btnCancel.setTitle(cancelButtonText ?? "CANCEL", for: .normal)
        self.btnCancel.setTitleColor(cancelButtonTextColor ?? UIColor.black, for: .normal)

    }
}
