//
//  ShuttleBusView.swift
//  JUN-tong
//
//  Created by Seong ho Hong on 2017. 10. 27..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class ShuttleBusView: UIViewController {
    
    @IBOutlet weak var shuttleBusCollectionView: UICollectionView!
    
    @IBOutlet weak var centerStationLabel: UILabel!
    @IBOutlet weak var leftStationLabel: UILabel!
    @IBOutlet weak var rightStationLabel: UILabel!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    
    let shuttleBusController = ShuttleBusController()
    var prevOffset: CGPoint?
    var aStationIndex: Int?
    var currentIndex: Int?
    var onceOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setShuttleIndex),
                                               name: NSNotification.Name(rawValue: "setAShuttleIndex"), object: nil)
        
        view.addSubview(shuttleBusCollectionView)
        
        shuttleBusCollectionView.dataSource = self
        shuttleBusCollectionView.delegate = self
        
        shuttleBusCollectionView.register(UINib(nibName: "ShuttleBusInfo", bundle: nil), forCellWithReuseIdentifier: "ShuttleBusInfo")
        setCollectionViewLayout()
    }
    
    @IBAction func favoriteButtionClick(_ sender: Any) {
        UserDefaults.standard.set(AshuttleStation[currentIndex!], forKey: "mainStation")
        aStationIndex = currentIndex
        setFavoriteButton(stationIndex: aStationIndex!)
        shuttleBusController.setShuttleBusIndex(shuttleBusName: AshuttleStation[aStationIndex!])
    }
    
    @objc func setShuttleIndex(_ notification: Notification) {
        aStationIndex = notification.userInfo!["aShuttleIndex"] as? Int
        currentIndex = aStationIndex
        setStationLabel(stationIndex: aStationIndex!)
        setFavoriteButton(stationIndex: aStationIndex!)
    }
    
    func setFavoriteButton(stationIndex: Int) {
        if aStationIndex == stationIndex {
            favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "redHeart"), for: .normal)
        } else {
            favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "blackHeart"), for: .normal)
        }
    }
    
    func setCollectionViewLayout() {
        let layout = ShuttleBusCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        layout.itemSize = CGSize(width: self.view.bounds.width - 64 - 10, height: self.view.bounds.height/2 + 20)
        
        shuttleBusCollectionView.collectionViewLayout = layout
        shuttleBusCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func setStationLabel(stationIndex: Int) {
        if stationIndex == 0 {
            self.leftStationLabel.isHidden = true
            self.centerStationLabel.text = AshuttleStation[stationIndex]
            self.rightStationLabel.text = AshuttleStation[stationIndex+1]
        } else if stationIndex == AshuttleStation.count-1 {
            self.leftStationLabel.text = AshuttleStation[stationIndex-1]
            self.centerStationLabel.text = AshuttleStation[stationIndex]
            self.rightStationLabel.isHidden = true
        } else {
            self.rightStationLabel.isHidden = false
            self.leftStationLabel.isHidden = false
            self.leftStationLabel.text = AshuttleStation[stationIndex-1]
            self.centerStationLabel.text = AshuttleStation[stationIndex]
            self.rightStationLabel.text = AshuttleStation[stationIndex+1]
        }
    }
}

extension ShuttleBusView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AshuttleStation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ShuttleBusInfo", for: indexPath) as? ShuttleBusCollectionViewCell {
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension ShuttleBusView: UICollectionViewDelegate {
    //즐겨찾기 인텍스 부터 시작
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: aStationIndex!, section: 0)
            self.shuttleBusCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: false)
            onceOnly = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        prevOffset = scrollView.contentOffset
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let currentOffset = targetContentOffset.pointee
        let visibleItemIndexPath = shuttleBusCollectionView.indexPathsForVisibleItems
        var indexPath: IndexPath?
        
        if let prev = prevOffset {
            if prev.x <  currentOffset.x {
                if var max = visibleItemIndexPath.first {
                    for item in visibleItemIndexPath where item.row > max.row {
                        max = item
                    }
                    indexPath = max
                }
            } else {
                if var min = visibleItemIndexPath.first {
                    for item in visibleItemIndexPath where item.row < min.row {
                        min = item
                    }
                    indexPath = min
                }
            }
        }
        
        setStationLabel(stationIndex: (indexPath?.row)!)
        setFavoriteButton(stationIndex: (indexPath?.row)!)
        self.currentIndex = indexPath?.row
    }
}

class ShuttleBusCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let cv = self.collectionView {
            
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth + 5
            
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                var candidateAttributes: UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    
                    if let candAttrs = candidateAttributes {
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttrs.center.x - proposedContentOffsetCenterX
                        
                        if fabsf(Float(a)) < fabsf(Float(b)) {
                            candidateAttributes = attributes
                        }
                        
                    } else { // == First time in the loop == //
                        
                        candidateAttributes = attributes
                        continue
                    }
                    
                }
                
                return CGPoint(x : candidateAttributes!.center.x - halfWidth, y : proposedContentOffset.y)
            }
        }
        // Fallback
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}
