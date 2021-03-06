//
//  PlacesViewController.swift
//  Places
//
//  Created Sebastian Cancinos on 22/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Toast_Swift

class PlacesViewController: UIViewController {
	var presenter: PlacesPresenterProtocol?
    var datasource: PlacesDatasource?
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var typesStack: UIStackView!

	override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = datasource
        collectionView.delegate = datasource
        collectionView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(refreshPlaces(_:)), for: .valueChanged)

        var nib = UINib(nibName: "PlacesCellView", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PlacesCell")

        nib = UINib(nibName: "PlaceTypesCellView", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PlaceTypesCell")

        refreshControl.beginRefreshing()
        presenter?.ready()
    }

    override func viewWillAppear(_ animated: Bool ) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true,
                                                   animated: animated)
    }

    @objc private func refreshPlaces(_ sender: Any) {
        presenter?.refresh()
    }
}

extension PlacesViewController: PlacesViewProtocol {
    func update(locations: [Location]) {
        datasource?.locations = locations
        DispatchQueue.main.async {[weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }

    func show(error: Error) {
        DispatchQueue.main.async {[weak self] in
            self?.refreshControl.endRefreshing()
            self?.view.makeToast(error.localizedDescription)
        }
    }
}

extension PlacesViewController: PlacesListDelegate {
    func filter(by type: LocationType) {
        refreshControl.beginRefreshing()
        presenter?.filter(by: type)
    }

    func selected(_ location: Location) {
        presenter?.select(location)
    }

    func infinteScroll() {
        presenter?.infiniteScroll()
    }
}
