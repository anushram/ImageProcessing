//
//  OptionsListVC.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 14/07/22.
//

import UIKit

class OptionsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var optionList: UITableView!
    
    // MARK: UITableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cells"
        let optionCell = optionList.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OptionsTVC
        return optionCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 79
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 2 {
            self.performSegue(withIdentifier: "toBypixel", sender: self)
            return
        }
        let imgSource: imageProcess = indexPath.row == 0 ? .enlarge : .extract
        self.performSegue(withIdentifier: "extentionconvert", sender: imgSource)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? ImagePickerVC {
            view.identifier = sender as! imageProcess
        }
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
