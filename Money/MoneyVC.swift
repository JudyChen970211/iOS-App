//  MoneyVC.swift
//  FinalProject

import UIKit

class MoneyVC: UIViewController {

    @IBAction func History_Button(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_History", sender: self)
    }
    @IBAction func Today_Button(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_Today", sender: self)
    }
    
    @IBAction func Statistics_Button(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_statistics", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
