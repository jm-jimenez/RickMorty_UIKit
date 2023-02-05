//
//  DetailHeaderView.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 4/2/23.
//

import UIKit

final class DetailHeaderView: UIView {

    var view: UIView?
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var outterBorder: UIView!
    @IBOutlet private weak var innerBorder: UIView!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var gradient: UIView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func setViewModel(_ viewModel: DetailHeaderViewModel) {
        image.setRemoteImage(url: viewModel.image)
        name.text = viewModel.name
    }
}

private extension DetailHeaderView {
    func commonInit() {
        let view = UINib(nibName: "DetailHeaderView", bundle: nil).instantiate(withOwner: self)[0] as? UIView ?? UIView()
        translatesAutoresizingMaskIntoConstraints = false
        self.view = view
        addSubview(self.view ?? UIView())
        self.view?.fullFit()
        setupView()
    }

    func setupView() {
        outterBorder.backgroundColor = .white
        innerBorder.backgroundColor = .secondarySystemBackground
        [outterBorder, innerBorder, image].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width ?? 0) / 2
        }
        outterBorder.layer.shadowRadius = 5
        outterBorder.layer.shadowColor = UIColor.black.cgColor
        outterBorder.layer.shadowOpacity = 0.6
        outterBorder.layer.shadowOffset = CGSize(width: 1, height: 3)

        name.font = .preferredFont(forTextStyle: .title1)
    }
}
