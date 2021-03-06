//
//  PlacesCellRouter.swift
//  Places
//
//  Created Sebastian Cancinos on 22/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class PlacesCellRouter: PlacesCellWireframeProtocol {

    weak var view: UICollectionViewCell?

    static func createModule(for view: PlacesCellView, with model: Location) -> UICollectionViewCell {
        // Change to get view from storyboard if not using progammatic UI
        let interactor = PlacesCellInteractor()
        let router = PlacesCellRouter()
        let presenter = PlacesCellPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view

        let datasource = NetworkDataSource()
        datasource.urlSession = URLSession.shared
        interactor.dataSource = datasource
        interactor.model = model

        return view
    }
}
