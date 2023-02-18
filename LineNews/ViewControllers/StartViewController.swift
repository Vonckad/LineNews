//
//  StartViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit
import SwiftyGif
import SnapKit

class StartViewController: UIViewController {

    let logoAnimationView = LogoAnimationView()
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.startBackgroundColor
        view.addSubview(logoAnimationView)
        logoAnimationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }

}

//MARK: - SwiftyGifDelegate
extension StartViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}
