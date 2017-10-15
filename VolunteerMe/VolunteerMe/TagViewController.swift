//
//  TagViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/13/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {

  @IBOutlet weak var tagLabel: UILabel!

  var isSelected: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    tagLabel.backgroundColor = Color.PRIMARY_COLOR
    tagLabel.textColor
    tagLabel.layer.cornerRadius = 8.0

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
