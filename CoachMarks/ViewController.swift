//
//  ViewController.swift
//  CoachMarks
//
//  Created by Admin on 17/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var lbl1: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let coachMarks: [CoachMark] = [
            CoachMark(
                rect: btn1.extendedFrame,
                caption: "Tap task for  task details & messages",
                shape: .roundedRect(cornerRadius: 10)
            ),
            CoachMark(
                rect: btn2.extendedFrame,
                caption: "Tap name for patient notes & all task details",
                shape: .square
            ),
            CoachMark(
                rect: lbl.extendedFrame,
                caption: "Swipe for more options",
                shape: .round
            ),
            CoachMark(
                rect: lbl1.extendedFrame,
                caption: "All your patients & task history",
                shape: .round
            )
        ]
        
        let coachMarksView = CoachMarksView(frame: self.view.bounds, coachMarks: coachMarks)
      
        self.view.addSubview(coachMarksView)
        coachMarksView.start()
    }
}

extension UIView {
    var extendedFrame: CGRect {
        var rect = frame
        rect.origin.y -= 4
        rect.origin.x -= 6
        rect.size.width += 12
        rect.size.height += 8
        return rect
    }
}
