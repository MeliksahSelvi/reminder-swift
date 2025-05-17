//
//  CalendarCell.swift
//  reminder
//
//  Created by Melik on 16.05.2025.
//

import UIKit

protocol CalendarCellDelegate: AnyObject {
    func didClickCalendarCell(date: Date)
    func getDisplayedDates(date : Date?) -> [Date]
}

class CalendarCell: UICollectionViewCell {
    
    private var horizontalCollectionView: UICollectionView? = nil
    private weak var delegate: CalendarCellDelegate?
    private var currentCenterX: CGFloat = 0
    private var displayedDates: [Date] = DateUtil.surroundingDays(date: nil, count: 4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func configure(delegate : CalendarCellDelegate){
        self.delegate = delegate
    }
    
    func refreshManually(){
        self.currentCenterX = horizontalCollectionView!.contentOffset.x + horizontalCollectionView!.bounds.size.width / 2
        self.animateCells(centerX: currentCenterX)
    }
}

private extension CalendarCell {
    
    func setupViews(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        horizontalCollectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        horizontalCollectionView!.backgroundColor = .systemBackground
        horizontalCollectionView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        horizontalCollectionView!.dataSource = self
        horizontalCollectionView!.delegate = self
        horizontalCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView!.showsHorizontalScrollIndicator = false
        horizontalCollectionView!.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        
        
        let todayIndex = displayedDates.count / 2
        let indexPath = IndexPath(item: todayIndex, section: 0)
        horizontalCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        
        contentView.addSubview(horizontalCollectionView!)
        buildConstraints()
    }
    
    func buildConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(horizontalCollectionView!.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(horizontalCollectionView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        constraints.append(horizontalCollectionView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(horizontalCollectionView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

extension CalendarCell: UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         UICollectionViewDelegateFlowLayout,
                                         UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedDates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            return UICollectionViewCell()
        }
        cell.configure(date: displayedDates[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.bounds.width / 5, height: contentView.bounds.height - 10)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX : CGFloat = horizontalCollectionView!.contentOffset.x + horizontalCollectionView!.bounds.size.width / 2
        let centerPoint = CGPoint(x: centerX, y: horizontalCollectionView!.bounds.size.height / 2)

        let cellWidth : CGFloat = contentView.bounds.width / 5
        let diff = currentCenterX - centerX
        
        if abs(diff) > cellWidth {

            if let indexPath = horizontalCollectionView!.indexPathForItem(at: centerPoint) {
                
                if let cell = horizontalCollectionView!.cellForItem(at: indexPath) as? DateCell {
                    self.displayedDates = self.delegate?.getDisplayedDates(date: cell.date) ?? []
                    horizontalCollectionView!.reloadData()
                    let todayIndex = displayedDates.count / 2
                    let indexPath2 = IndexPath(item: todayIndex, section: 0)
                    horizontalCollectionView?.scrollToItem(at: indexPath2, at: .centeredHorizontally, animated: false)
                    self.delegate?.didClickCalendarCell(date: cell.date!)
                }
            }
            self.currentCenterX = centerX
        }
        
        self.animateCells(centerX: centerX)
    }
    
    func animateCells(centerX: CGFloat) {
        for cell in horizontalCollectionView!.visibleCells as! [DateCell] {
            let cellCenterX = cell.center.x
            let distance = abs(cellCenterX - centerX)
            let maxDistance = horizontalCollectionView!.bounds.size.width / 2
            
            let ratio = min(distance / maxDistance,1.0)
            
            let fontSize = 17 - (8 * ratio)
            let alpha = max(1 - ratio,0.3)
            
            cell.dateLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
            cell.dateLabel.alpha = alpha
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DateCell {
            self.displayedDates = self.delegate?.getDisplayedDates(date: cell.date) ?? []
            self.horizontalCollectionView!.reloadData()
            let todayIndex = displayedDates.count / 2
            let indexPath2 = IndexPath(item: todayIndex, section: 0)
            horizontalCollectionView?.scrollToItem(at: indexPath2, at: .centeredHorizontally, animated: false)
            self.animateCells(centerX: cell.center.x)
            self.delegate?.didClickCalendarCell(date: cell.date!)
        }
    }
}
