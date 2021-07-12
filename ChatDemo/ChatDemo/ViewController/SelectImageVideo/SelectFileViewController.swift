//
//  SelectFileViewController.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 23/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit

protocol SelectFileDelegate{
    func selctFileItemwith(item : String)
}


class SelectFileViewController: UIViewController {

    @IBOutlet weak var view_background: UIView!
    var delegate : SelectFileDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureKeypad = UITapGestureRecognizer.init(target: self, action: #selector(handleKeypadTapGesture(sender:)))
        view_background.addGestureRecognizer(tapGestureKeypad)

        // Do any additional setup after loading the view.
    }
    
    @objc func handleKeypadTapGesture(sender : UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK:- Button Action
    @IBAction func btn_galleryAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate.selctFileItemwith(item: "Gallery")
    }
    
    @IBAction func btn_cameraAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate.selctFileItemwith(item: "Camera")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
