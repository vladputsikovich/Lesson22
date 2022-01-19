//
//  AdvertBottomView.swift
//  Lesson22
//
//  Created by Владислав Пуцыкович on 18.01.22.
//

import UIKit

class AdvertBottomView: UIView {

    private var imageView = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        createImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createImageView() {
        imageView.frame = frame
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        addSubview(imageView)

    }
    
    func configOf(advert: Advert) {
        imageView.image = advert.image
        imageView.contentMode = .scaleToFill
    }

}
