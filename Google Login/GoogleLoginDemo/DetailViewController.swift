//
//  DetailViewController.swift
//  GoogleLoginDemo
//
//  Created by Sumendra on 18/05/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var googleManager : GoogleLoginManager?
    
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblUserEmail:UILabel!
    @IBOutlet weak var imgUser:UIImageView!
    
    var user : UserDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {
            return
        }
        lblUserName?.text = user.name
        lblUserEmail?.text = user.email
        showUserImage()
        // Do any additional setup after loading the view.
    }
    
    func showUserImage(){
        if let url = user?.image{
            if let data = try? Data(contentsOf: url){
             imgUser?.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func btnLogoutClicked(_ sender:UIButton){
        googleManager?.signOutFromGoogle()
        goToHomeViewController()
    }
    
    func goToHomeViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateInitialViewController() as! UINavigationController
        loginVC.navigationBar.isHidden = true
        self.view.window?.rootViewController = loginVC
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
