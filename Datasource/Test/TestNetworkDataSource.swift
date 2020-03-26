//
//  TestNetworkDataSource.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 24/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation
import XCTest
@testable import Places

class TestNetworkDataSource: XCTestCase {
    var datasource: NetworkDataSource!
    var session: URLSessionMock!
    var dataTask: URLSessionDataTaskMock!
    var placesResponse = """
    {"html_attributions":[],"next_page_token":"1234","results":[{"geometry":{"location":{"lat":52.3666969,"lng":4.8945398},"viewport":{"northeast":{"lat":52.4311573,"lng":5.0791619},"southwest":{"lat":52.278174,"lng":4.7287589}}},"icon":"https://maps.gstatic.com/mapfiles/place_api/icons/geocode-71.png","id":"583c21d6b8c8d9922969236a70104244512786a2","name":"Amsterdam","photos":[{"height":720,"photo_reference":"CmRaAAAAJjVrNVuSsVxgiw836jqzbZfuPrQky1DZgstavFaXMA5ITU9BnnpVuMWRDszkk05L1A_MLqYMuVVs_SFzeS9MlKcDdDCDFD8smndn5r91AZqPuuEgglC2aCxgG8ibs_1xEhCC-pmZUXD9tbuzRbFwOM37GhSZK0J1YuhMJnn33BjVX15telz7Zw","width":1080}],"place_id":"ChIJVXealLU_xkcRja_At0z9AGY","reference":"ChIJVXealLU_xkcRja_At0z9AGY","scope":"GOOGLE","types":["locality","political"],"vicinity":"Amsterdam"},{"geometry":{"location":{"lat":52.372693,"lng":4.894381999999999},"viewport":{"northeast":{"lat":52.3740649302915,"lng":4.895647230291501},"southwest":{"lat":52.3713669697085,"lng":4.892949269708496}}},"icon":"https://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png","id":"958811f303b3e79d74c9e8ce996dddc54477d37b","name":"Hotel NH Collection Amsterdam Grand Hotel Krasnapolsky","opening_hours":{"open_now":true},"photos":[{"height":2988,"photo_reference":"CmRaAAAAAN4SmpUMTLxPKSLyX6ucurMe5aY3lLvzeRQlComZ79V3e2JSvJcLkCG1Lm7Gng3orXPAv4YidbGMsLhUiGbWxjnvd3yjLg61yNWJsb8oju_vmeQIHS5RtJPSQADqEL6kEhBID6Q0G-aT3z8pPpVhFrylGhTJDC62oj0JcEAWlK2QcxXYDMTMvg","width":5312}],"place_id":"ChIJ_5j_RccJxkcRtPh7den4sB8","plus_code":{"compound_code":"9VFV+3Q Amsterdam, Netherlands","global_code":"9F469VFV+3Q"},"rating":4.5,"reference":"ChIJ_5j_RccJxkcRtPh7den4sB8","scope":"GOOGLE","types":["lodging","point_of_interest","establishment"],"user_ratings_total":3661,"vicinity":"Dam 9, Amsterdam"},{"geometry":{"location":{"lat":52.373704,"lng":4.893591},"viewport":{"northeast":{"lat":52.3749684302915,"lng":4.895110280291503},"southwest":{"lat":52.3722704697085,"lng":4.892412319708498}}},"icon":"https://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png","id":"2bec474fffea928d260efa6eb0948a4a0e8abbc1","name":"De Roode Leeuw","opening_hours":{"open_now":true},"photos":[{"height":3010,"photo_reference":"CmRaAAAAvSeuXqEhvrPdNZ-o8r-bIxXH5E8p-bYT1UDhKHt7R45eo2Mf3500Hxg9g4m2FJZP4NC-rwHwCYpEa1WTjYeIYncCYhMaKAADFqFZrSH7OMGQrEH2jA4PURJ3dLlIiT5MEhB7B6TjGv_r7o5Yf5JOiVCTGhTxCMo6vLc_r2sKbF5A0dYu_kaAIw","width":4515}],"place_id":"ChIJ1UTIFscJxkcRTjMiVuX6pNM","plus_code":{"compound_code":"9VFV+FC Amsterdam, Netherlands","global_code":"9F469VFV+FC"},"rating":4,"reference":"ChIJ1UTIFscJxkcRTjMiVuX6pNM","scope":"GOOGLE","types":["lodging","point_of_interest","establishment"],"user_ratings_total":436,"vicinity":"Damrak 93-94, Amsterdam"}]}
    """    // swiftlint:disable:previous line_length

    let placeResponse = """
    {"html_attributions":[],"result":{"formatted_address":"Kethelweg 220, 3135 GP Vlaardingen, Netherlands","formatted_phone_number":"010 470 0322","geometry":{"location":{"lat":51.92323529999999,"lng":4.362401499999999},"viewport":{"northeast":{"lat":51.9244857802915,"lng":4.363990680291502},"southwest":{"lat":51.9217878197085,"lng":4.361292719708498}}},"icon":"https://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png","id":"49566554c13214806f9179f9edb2efd77b6c9c3a","international_phone_number":"+31 10 470 0322","name":"Hotel Restaurant Campanile Rotterdam Vlaardingen","photos":[{"height":1365,"photo_reference":"CmRaAAAALk3keGmNQqDGoh4M765ZPGJcb-E-cyVPdWjJfqOCWhqa3tle402p94YrDvO5u7KwtY1FxnBmB01jJE0W7hAheJk6FyqMt8a81WAuohiE6kmTiV2iQRXaBxY_cpzmlbFFEhBZNUGKQej7mZLzu5zhpJ_uGhRrSV0V6jckrOMPgPIBjnONa0FO5A","width":2048},{"height":460,"photo_reference":"CmRaAAAACT1FHmQrAxzLdDUkgKvtPLwr3m-u7y_i1qHZdH3gdQETosn4MssGE0OSN1In5NXTC-AMosIrtWrYCAbKvb-4q0tglNPuBOwtl6QtMHra9ff97_6GyiJGl665_nYiWeDlEhB5EmYE-0cdu2y2mRNqsN-QGhQLYmZhaFuCxhyh5Nd8ICTw59QOSA","width":840},{"height":3984,"photo_reference":"CmRaAAAAUzdjY0Vf63hZZh_iUxhEKdCJw98kicKMHAppo5DaTJ2KgE_xWs8ipgn3b3bwP-MbqHKfC4vulifBetIYcfIkAb57w9sYkwY0F_l_LPZHB9LWwJORdnKs1yl703guihD6EhBs0heY6ahm6puFUvYLX1wrGhQysJjqWSBoJp7gLHXGRl2i0-l7IA","width":2988},{"height":460,"photo_reference":"CmRaAAAA8LKCaNWiPOntpNnLRhdoGoQPHstIHjdjxv9_KaTIGTFU2KCdA3Tetcn_XO3CIggviblYuUnHulDESy3vvqWp-YbpXJ83zKTG2hmNtbPOl2wvwo5mDZP0V6RPJ4K7FLShEhCnlKf0OiyFewYqEeu4zaK9GhTQb6yq9A6PsMeheiEbIxWKbJ-H-A","width":840},{"height":3712,"photo_reference":"CmRaAAAA3QdaRVL5AFltaDzVisno61NJC-b1Hc3D9VHMvR0hd4rtqd1Bejg10pTihK9x-987nBOr8HwFRw5YhkRsEtR-sZWC6wbqq3QE7zecAYfwJYsMUi2HjhI5vaIa6gL-fLAcEhAnhEj6-wClm7ReABBJFqgEGhTfeLHKOw8zOJigdKBT85iRCusefA","width":5568},{"height":460,"photo_reference":"CmRaAAAAp6udGCuKIaLtKA7nHjdCfwwPydVLrr2MlPr4N70diGo2r5SXQdSOu3wsJ_09Y3H-MNrJzUnPJfIo-RiEzGk3geKQUQgIosRT4PRUwbf0qJYt8LFBIJRnZTglVSA1GdpHEhDNlJOE4HnGqQ12TEmOI7LHGhTkjJhmu4FgM3I8u-vmd-_e2Jo5jw","width":840},{"height":3712,"photo_reference":"CmRaAAAAUo_SF_TWqLxtA8YfYo45HNvjRTLkah2FQN4vTZd_6dS94RZ3XlXCgCfzxn6zgm4ZQrvLfcA8zDNv80z3gjxGnrwl0IJCs7yuc0E4y8P_mBGzKhoInEUEqD1l4ghI03qwEhDZJ23AS4ZmTNFZx3YbaO1eGhSr-YzjMbSGsY4bLAnXwFZ7tIpV-g","width":5568},{"height":460,"photo_reference":"CmRaAAAAHaZ3AMMhcWoD2C3kaQTMbXS2xRmi71XRdwsMfs42DYm-CxJ2VzKoBX8hFe9NN2hJ6rgmeaoRbR8mh4591a7egunZGQGa7j3I39hVIr2WMdAr_e7jlQ0dtGNDu3OIoClOEhDdxiTGz9YQt8bEhGCJFwbRGhT3w9NfAAtwspRXKCle8lP583iD2g","width":840},{"height":3712,"photo_reference":"CmRaAAAArS4XLTPwsu0dhNDsmB3uISrNZkJ4hwpK3ktUvsRBbT10HDI-RgDU2yjeEGy_gOpEZeiYqK0e8gtJiyKbk1yhmNvuSnYddTulMrPdGljU0Mmodqqew5yBEvIzLdf1Q6j3EhDMhU3rO6K87iKWRBodvlyGGhQU5eVfLeZLnJPxHCTO-_Du_1vHdQ","width":5568},{"height":5568,"photo_reference":"CmRaAAAAOaEuRq5_jHIT3V-YGe4QM0iOhU2u6skhcI968LstP8mpzoJxkky4fJMMHW2iAkwS9AqLzOWsUq93r-4WSnS92GqPTpd89AfTpoi4ZqRKQ4VJ6G3kcwNGAYrTpD0e7PeOEhBSfHP3Yry8DsnqssGcxau8GhTvAGmec0Im35k0D1GHVXg8e32cig","width":3712}],"place_id":"ChIJj9ZAOaNKxEcRM2nEwybezZE","plus_code":{"compound_code":"W9F6+7X Vlaardingen, Netherlands","global_code":"9F36W9F6+7X"},"rating":3.5,"reference":"ChIJj9ZAOaNKxEcRM2nEwybezZE","reviews":[{"author_name":"Kero VandenAkker","author_url":"https://www.google.com/maps/contrib/115354373834800574316/reviews","language":"en","profile_photo_url":"https://lh3.googleusercontent.com/a-/AOh14GgW5rlTIctY1G9O9A3ve_a_pGa_65aKqPPaBYo=s128-c0x00000000-cc-rp-mo-ba5","rating":5,"relative_time_description":"3 weeks ago","text":"nice 3 star hotel, excellent food, easily accessible by car. And not expensive!","time":1583089654},{"author_name":"westpulveris","author_url":"https://www.google.com/maps/contrib/104676173154338552294/reviews","language":"en","profile_photo_url":"https://lh3.googleusercontent.com/a-/AOh14Gghs4oHpojTWHa_wwMFyuRv1tk13IsaG-J5ciIn=s128-c0x00000000-cc-rp-mo-ba3","rating":4,"relative_time_description":"6 months ago","text":"It's a cosy and clean place to stay for a few days. It's rather cheap and for this price really comfortable. Everyday we were given new facilities (such as cups and cookies) and even a special Easter gift!","time":1569093133},{"author_name":"Roelof Duyverman","author_url":"https://www.google.com/maps/contrib/103245021715638974884/reviews","language":"en","profile_photo_url":"https://lh3.googleusercontent.com/a-/AOh14GiIqGjXpzZr7W3pKuailAShVP-r7B_gi6tUKtO5tQ=s128-c0x00000000-cc-rp-mo-ba4","rating":3,"relative_time_description":"4 months ago","text":"Cleaning could be better, bathrooms need a serious update. Friendly reception staff.","time":1573661703},{"author_name":"Rosie Scott","author_url":"https://www.google.com/maps/contrib/115349988005804881728/reviews","language":"en","profile_photo_url":"https://lh3.googleusercontent.com/a-/AOh14GgfRc-r-RWExBTF0jfTjhmWffsIBRnPVtztkFQ6iw=s128-c0x00000000-cc-rp-mo","rating":4,"relative_time_description":"6 months ago","text":"Convenient for visiting surrounding area while being quiet. Lovely friendly staff.","time":1567149754},{"author_name":"George Tudorie","author_url":"https://www.google.com/maps/contrib/104504451855327976335/reviews","language":"en","profile_photo_url":"https://lh3.googleusercontent.com/a-/AOh14Ggig6TLE8dv-Uh-PBS0l_Gz3336v6SeBJXfX4GuYg=s128-c0x00000000-cc-rp-mo-ba4","rating":5,"relative_time_description":"3 months ago","text":"Nice, private and easy to do find","time":1576218743}],"scope":"GOOGLE","types":["parking","lodging","restaurant","food","point_of_interest","establishment"],"url":"https://maps.google.com/?cid=10506297763799787827","user_ratings_total":373,"utc_offset":60,"vicinity":"Kethelweg 220, Vlaardingen","website":"https://www.campanile.com/fr/hotels/campanile-rotterdam-west-vlaardingen/?utm_source=google&utm_medium=maps&utm_content=NLD2&utm_campaign=Campanile"},"status":"OK"}
    """    // swiftlint:disable:previous line_length

    override func setUp() {
        super.setUp()

        datasource = NetworkDataSource()
        dataTask = URLSessionDataTaskMock()
        session = URLSessionMock()

        session.task = dataTask
        datasource.urlSession = session
        datasource.setup(backend: URL(string: "http://testing.com"), key: "ABCD1234")
    }

    func testGetImage() {
        datasource.getImage(with: "1234", completion: {_ in})
        guard let lastURL = self.session.lastURLCalled else {
            XCTAssertNotNil(self.session.lastURLCalled)
            return
        }

        XCTAssertTrue(lastURL.contains("photoreference=1234"))
        XCTAssertTrue(lastURL.contains("key=ABCD1234"))
        XCTAssertTrue(lastURL.starts(with: "http://testing.com/photo"))
        XCTAssertTrue(self.dataTask.resumeWasCalled)
    }

    func testGetPlaces() {
        session.data = placesResponse.data(using: .unicode)
        let expectation = XCTestExpectation(description: "Get Places")

        datasource.getPlaces(location: "1.12345,34,12345", radius: 150, type: .bakery) {[weak self] result in
            switch result {
            case .success(let places):
                XCTAssertEqual(self?.datasource.placesToken, "1234")
                XCTAssertEqual(places.count, 3)

            case .failure:
                XCTFail("Decoding failed")
            }

            expectation.fulfill()
        }

        guard let lastURL = self.session.lastURLCalled else {
            XCTAssertNotNil(self.session.lastURLCalled)
            return
        }

        XCTAssertTrue(lastURL.contains("location=1.12345,34,12345"))
        XCTAssertTrue(lastURL.contains("radius=150"))
        XCTAssertTrue(lastURL.contains("type=bakery"))
        XCTAssertTrue(lastURL.contains("key=ABCD1234"))
        XCTAssertTrue(lastURL.starts(with: "http://testing.com/nearbysearch/json"))
        XCTAssertTrue(self.dataTask.resumeWasCalled)
    }

    func testGetNextPage() {
        datasource.placesToken = "VWXYZ0987"
        session.data = placesResponse.data(using: .unicode)
        let expectation = XCTestExpectation(description: "Get Next Page for Places")

        datasource.getNextPlaces {[weak self] result in
            switch result {
            case .success(let places):
                XCTAssertEqual(self?.datasource.placesToken, "1234")
                XCTAssertEqual(places.count, 3)

            case .failure:
                XCTFail("Decoding failed")
            }

            expectation.fulfill()
        }

        guard let lastURL = self.session.lastURLCalled else {
            XCTAssertNotNil(self.session.lastURLCalled)
            return
        }

        XCTAssertTrue(lastURL.contains("key=ABCD1234"))
        XCTAssertTrue(lastURL.contains("pagetoken=VWXYZ0987"))
        XCTAssertTrue(lastURL.starts(with: "http://testing.com/nearbysearch/json"))
    }

    func testGetPlaceDetails() {
        session.data = placeResponse.data(using: .unicode)
        let expectation = XCTestExpectation(description: "Get Place Details")

        datasource.getPlaceDetails(placeId: "1234") {result in
            switch result {
            case .success(let place):
                XCTAssertEqual(place.photos?.count, 10)

            case .failure:
                XCTFail("Decoding failed")
            }

            expectation.fulfill()
        }

        guard let lastURL = self.session.lastURLCalled else {
            XCTAssertNotNil(self.session.lastURLCalled)
            return
        }

        XCTAssertTrue(lastURL.contains("place_id=1234"))
        XCTAssertTrue(lastURL.contains("key=ABCD1234"))
        XCTAssertTrue(lastURL.starts(with: "http://testing.com/details/json"))
        XCTAssertTrue(self.dataTask.resumeWasCalled)
    }

}
