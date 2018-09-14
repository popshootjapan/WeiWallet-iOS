//
//  PageControl.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/30.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PageControl: UIControl {
    
    let titles = BehaviorRelay<[String]>(value: [])
    let selectedIndex = BehaviorRelay<Int>(value: 0)
    let currentContentOffset = BehaviorRelay<CGFloat>(value: 0)
    
    private let disposeBag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        
        return collectionView
    }()
    
    private let selectionIndicatorView: UIView = {
        let view: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 2.0))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 1
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        collectionView.delegate = self
        addSubview(collectionView)
        
        selectionIndicatorView.frame.origin.y = frame.height - selectionIndicatorView.frame.height
        selectionIndicatorView.autoresizingMask = [.flexibleTopMargin]
        addSubview(selectionIndicatorView)
        
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        updateSelectionIndicatorViewAnimated(animated: false)
    }
    
    private func bind() {
        titles.asDriver()
            .drive(collectionView.rx.items(cellType: Cell.self))
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(titles.asDriver(), selectedIndex.asDriver()) { ($0, $1) }
            .drive(onNext: { [weak self] titles, index in
                guard !titles.isEmpty else {
                    return
                }
                let indexPath = IndexPath(item: index, section: 0)
                self?.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)
        
        currentContentOffset.asDriver()
            .drive(onNext: { [weak self] progress in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectionIndicatorView.frame.origin.x = progress * strongSelf.frame.width
            })
            .disposed(by: disposeBag)
    }
    
    private func updateSelectionIndicatorViewAnimated(animated: Bool) {
        guard titles.value.count > 0 else {
            return
        }
        
        guard
            let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let attributes = collectionView.layoutAttributesForItem(at: indexPath) else {
                selectionIndicatorView.frame.size.width = 0.0
                return
        }
        
        UIView.animate(withDuration: animated ? 0.1 : 0.0) {
            self.selectionIndicatorView.frame.origin.x = attributes.frame.minX - self.collectionView.contentOffset.x
            self.selectionIndicatorView.frame.size.width = attributes.frame.width
        }
    }
}

extension PageControl: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex.accept(indexPath.row)
        sendActions(for: .valueChanged)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width / CGFloat(titles.value.count),
            height: collectionView.frame.height
        )
    }
}

extension PageControl {
    class Cell: UICollectionViewCell, InputAppliable {
        static let reuseIdentifier = "Cell"
        
        typealias Input = String
        
        func apply(input: String) {
            titleLabel.text = input
        }
        
        let titleLabel = UILabel()
        
        override var isSelected: Bool {
            didSet {
                if isSelected {
                    titleLabel.textColor = UIColor.white
                    titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
                } else {
                    titleLabel.textColor = UIColor.lightGray
                    titleLabel.font = UIFont.systemFont(ofSize: 15)
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            isSelected = false
            titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            titleLabel.textAlignment = .center
            addSubview(titleLabel)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            titleLabel.frame.size = frame.size
            titleLabel.center.x = bounds.midX
            titleLabel.center.y = bounds.midY
        }
    }
}

