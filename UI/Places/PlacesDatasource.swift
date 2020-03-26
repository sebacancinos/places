//
//  PlacesDatasource.swift
//  Places
//
//  Created by Sebastian Cancinos on 22/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation
import UIKit

class PlacesDatasource: NSObject {
    var locations: [Location]?
    weak var delegate: PlacesListDelegate?
}

extension PlacesDatasource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1

        case 1:
            return locations?.count ?? 0

        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellId: String
        if indexPath.section == 0 {
            cellId = "PlaceTypesCell"
        } else {
            cellId = "PlacesCell"
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

        if let cell = cell as? PlacesCellView,
            let location = locations?[indexPath.item] {

            _ = PlacesCellRouter.createModule(for: cell, with: location)
            cell.presenter?.ready()
        } else if let cell = cell as? PlaceTypesCellView {
            let cellRouter = PlaceTypesCellRouter.createModule(for: cell)

            cellRouter.delegate = delegate
            cell.presenter?.ready()
        }

        return cell
    }
}

extension PlacesDatasource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let location = locations?[indexPath.item] else { return }

        delegate?.selected(location)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 30)
        } else {
            return CGSize(width: (collectionView.frame.size.width / 2) - 5, height: 150)
        }
    }
}

extension PlacesDatasource: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y / scrollView.frame.size.height

        if position > 0.6 {
            delegate?.infinteScroll()
        }
    }
}
