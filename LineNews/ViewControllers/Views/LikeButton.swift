//
//  LikeButton.swift
//  LineNews
//
//  Created by Vlad Ralovich on 21.02.2023.
//

import UIKit

class LikeButton: UIButton {
    
    private enum LikeButtonState {
        case unlike, like
    }
    
    var isLiked: Bool {
        get {
            return likeState == .like
        }
    }
    
    private var likeState: LikeButtonState = .like {
        didSet {
            setImage(UIImage(named: likeState == .unlike ? "heart" : "heart_fill"), for: .normal)
        }
    }
    
    init() {
        super.init(frame: .zero)
        setLike(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleImage() {
        likeState = likeState == .unlike ? .like : .unlike
    }
    
    func setLike(_ flag: Bool) {
        likeState = flag ? .like : .unlike
    }
}
