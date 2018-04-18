import UIKit;import PlaygroundSupport;PlaygroundPage.current.liveView = view
import Closures
//: [Go back](@previous)

PlaygroundPage.current.needsIndefiniteExecution = true

let textView = viewController.textView!

textView.text = ""

textView.onChange { (text) in
    print("onChange: " + text)
}

textView.didBeginEditing {
    print("didBeginEditing")
}



