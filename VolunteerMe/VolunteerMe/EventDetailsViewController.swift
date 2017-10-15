//
//  EventDetailsViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/15/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

  @IBOutlet weak var eventImage: UIImageView!
  @IBOutlet weak var registerButtonBackground: UIView!
  @IBOutlet weak var registerButtonLabel: UILabel!
  @IBOutlet weak var descriptionText: UILabel!
  @IBOutlet weak var map: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
      registerButtonBackground.backgroundColor = Color.PRIMARY_COLOR
      registerButtonBackground.layer.cornerRadius = 8.0


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