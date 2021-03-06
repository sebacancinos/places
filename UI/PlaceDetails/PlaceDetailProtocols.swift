//
//  PlaceDetailProtocols.swift
//  Places
//
//  Created Sebastian Cancinos on 23/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation
import UIKit
import FloatRatingView

// MARK: Wireframe -
protocol PlaceDetailWireframeProtocol: class {

}
// MARK: Presenter -
protocol PlaceDetailPresenterProtocol: class {

    var interactor: PlaceDetailInteractorInputProtocol? { get set }

    func ready()
}

// MARK: Interactor -
protocol PlaceDetailInteractorOutputProtocol: class {

    /* Interactor -> Presenter */
    func show(location: Location)
    func add(photo: UIImage)
}

protocol PlaceDetailInteractorInputProtocol: class {

    var presenter: PlaceDetailInteractorOutputProtocol? { get set }
    var model: Location? { get set }
    /* Presenter -> Interactor */

    func loadLocation()
}

// MARK: View -
protocol PlaceDetailViewProtocol: class {

    var presenter: PlaceDetailPresenterProtocol? { get set }

    /* Presenter -> ViewController */
    var photoStack: UIStackView! { get set }
    var photoScroll: UIScrollView! { get set }
    var ratingView: FloatRatingView! { get set }
    var nameLabel: UILabel! { get set }
    var addressLabel: UILabel! { get set }
    var typesLabel: UILabel! { get set }
}
