//
/**
 The MIT License (MIT)
 Copyright (c) 2018 Michal Smaga
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
 is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or
 substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

extension UITextView {
    
    @discardableResult
    public func shouldBeginEditing(handler: @escaping () -> Bool) -> Self {
        return update { $0.shouldBeginEditing = handler }
    }
    
    @discardableResult
    public func shouldEndEditing(handler: @escaping () -> Bool) -> Self {
        return update { $0.shouldEndEditing = handler }
    }
    
    @discardableResult
    public func didBeginEditing(handler: @escaping () -> Void) -> Self {
        return update { $0.didBeginEditing = handler }
    }
    
    @discardableResult
    public func didEndEditing(handler: @escaping () -> Void) -> Self {
        return update { $0.didEndEditing = handler }
    }
    
    @discardableResult
    public func shouldChangeText(handler: @escaping (_ range: NSRange, _ replacementText: String) -> Bool) -> Self {
        return update { $0.shouldChangeText = handler }
    }
    
    @discardableResult
    public func onChange(handler: @escaping (_ text: String) -> Void) -> Self {
        return update { $0.didChange = { textView in
            handler(textView.text)
            }
        }
    }
    
    @discardableResult
    public func didChangeSelection(handler: @escaping () -> Void) -> Self {
        return update { $0.didChangeSelection = handler }
    }
}


extension UITextView {
    @discardableResult
    fileprivate func update(handler: (_ delegate: TextViewDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: TextViewDelegate(),
                               delegates: &TextViewDelegate.delegates,
                               bind: UITextView.bind) {
                                handler($0.delegate)
        }
        return self
    }
    
    @objc public override func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &TextViewDelegate.delegates)
        UITextView.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UITextView, _ delegate: TextViewDelegate?) {
        delegator.delegate = nil
        delegator.delegate = delegate
    }
}


fileprivate final class TextViewDelegate: NSObject, UITextViewDelegate, DelegateProtocol {
    fileprivate static var delegates = Set<DelegateWrapper<UITextView, TextViewDelegate>>()
    
    override required init() {
        super.init()
    }
    
    fileprivate var shouldBeginEditing: (() -> Bool)?
    fileprivate func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return shouldBeginEditing?() ?? true
    }
    
    fileprivate var shouldEndEditing: (() -> Bool)?
    fileprivate func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return shouldEndEditing?() ?? true
    }
    
    fileprivate var didBeginEditing: (() -> Void)?
    fileprivate func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing?()
    }
    
    fileprivate var didEndEditing: (() -> Void)?
    fileprivate func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditing?()
    }
    
    fileprivate var shouldChangeText: (( _ range: NSRange, _ replacementText: String) -> Bool)?
    fileprivate func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return shouldChangeText?(range, text) ?? true
    }
    
    fileprivate var didChange: ((UITextView) -> Void)?
    fileprivate func textViewDidChange(_ textView: UITextView) {
        didChange?(textView)
    }
    
    fileprivate var didChangeSelection: (() -> Void)?
    fileprivate func textViewDidChangeSelection(_ textView: UITextView) {
        didChangeSelection?()
    }
    
//
// TODO:
//
//    @available(iOS 10.0, *)
//    fileprivate func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        return true
//    }
//
//
//    @available(iOS 10.0, *)
//    fileprivate func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        return true
//    }
//
//
//    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
//    fileprivate func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//
//        return true
//    }
//
//
//    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
//    fileprivate func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
//
//        return true
//    }
    
    
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(TextViewDelegate.textViewShouldBeginEditing(_:)):
            return shouldBeginEditing != nil
        case #selector(TextViewDelegate.textViewShouldEndEditing(_:)):
            return shouldEndEditing != nil
        case #selector(TextViewDelegate.textViewDidBeginEditing(_:)):
            return didBeginEditing != nil
        case #selector(TextViewDelegate.textViewDidEndEditing(_:)):
            return didEndEditing != nil
        case #selector(TextViewDelegate.textView(_:shouldChangeTextIn:replacementText:)):
            return shouldChangeText != nil
        case #selector(TextViewDelegate.textViewDidChange(_:)):
            return didChange != nil
        case #selector(TextViewDelegate.textViewDidChangeSelection(_:)):
            return didChangeSelection != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}
