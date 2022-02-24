//
//  BlurredButton.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit
import RxSwift

class BlurredButton: UIView {
    private var imageView: UIImageView!
    fileprivate var actionSubject = PublishSubject<Void>()
//    var target: Any?
    var selector: Selector?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        actionSubject.onNext(())
//        target.perform(selector)
        
        if let selector = selector {
            
            perform(selector)
        }
        return super.hitTest(point, with: event)
    }
    
    func setup(image: UIImage?) {
        self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    private func setup() {
        insertBlurredView()
        let imageView = UIImageView(frame: .zero)
        addSubview(imageView)
        imageView.bindLayoutToSuperView()
        
        self.imageView = imageView
    }
}

extension Reactive where Base: BlurredButton {
    var tap: Observable<Void> {
        base.actionSubject.asObservable()
    }
}
