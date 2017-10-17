//
//  ViewController.swift
//  KF768Reproducer
//
//  Created by dino.law on 17/10/2017.
//  Copyright © 2017 inD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

final class ViewController: UIViewController {
    
    private let posterView = UIImageView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private var posterURL: Driver<URL?> = Driver.empty()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterView.clipsToBounds = true
        posterView.contentMode = .scaleAspectFill
        view.addSubview(posterView)
        posterView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        posterURL = Observable.create { observer in
            print("Subscribed")
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now() + 5, repeating: 5)
            
            let cancel = Disposables.create {
                print("Disposed")
                timer.cancel()
            }
            
            var next = 0
            timer.setEventHandler {
                if cancel.isDisposed {
                    return
                }
                let url = URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(next).jpg")
                print("display: \(url?.absoluteString ?? "url failure")")
                
                if next == 0 {
                    observer.on(.next(nil))
                } else {
                    observer.on(.next(url))
                }
                next += 1
            }
            timer.resume()
            
            return cancel
        }
        .asDriver(onErrorJustReturn: nil)
        
        posterURL
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.posterView.kf.setImage(with: $0, options: [.transition(.fade(0.5))])
            })
            .disposed(by: bag)
    }

}

