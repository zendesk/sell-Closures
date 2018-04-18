import UIKit
import PlaygroundSupport

public class TextViewDemoViewController: BaseViewController, PrintableController {
    @IBOutlet public var printableTextView: UITextView?
    @IBOutlet public var textView: UITextView?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // supposed to simulate a button item created from a xib/storyboard
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right item", style: .plain, target: nil, action: nil)
    }
}

public let viewController = TextViewDemoViewController(nibName: "TextViewDemoViewController", bundle: nil)
public let view = viewController.view!

public func log(_ string: String) {
    viewController.print(text: string)
    print(string)
}
