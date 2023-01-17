# CoachMarks

Demo
  ---

!((https://github.com/megaganjotsingh/CoachMarks/blob/main/coachMarks.gif))_

Easy to Use
  ---
  
  ### Define all coach marks 

  ```swift
         let coachMarks: [CoachMark] = [
              CoachMark(
                  rect: Your view's frame,
                  caption: "Tap task for  task details & messages",
                  shape: .roundedRect(cornerRadius: 10)
              ),
              CoachMark(
                  rect: Your view's frame,
                  caption: "Tap name for patient notes & all task details",
                  shape: .square
              ),
         ]
  ```

### You can simply add above coach marks to view
  
  ```swift
        let coachMarksView = CoachMarksView(frame: view.bounds, coachMarks: coachMarks)
        view.addSubview(coachMarksView)
  ```
  
### Now run the coach marks by calling start() function
  
  ```swift
        coachMarksView.start()
  ```
  
  Collaboration
---

I tried to build an easy to use API, but I'm sure there are ways of improving and adding more features, If you think that we can do the Coach Marks more powerful please contribute with this project.
