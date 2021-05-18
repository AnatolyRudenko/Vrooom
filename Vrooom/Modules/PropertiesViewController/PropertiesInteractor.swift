//
//  PropertiesInteractor.swift
//  Vrooom
//
//  Created by Admin on 17.05.2021.
//  Copyright © 2021 Rudenko. All rights reserved.
//

import UIKit

final class PropertiesInteractor: PropertiesInteractorProtocol {
    
    weak var presenter: PropertiesPresenterProtocol!
    
    required init(presenter: PropertiesPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getCarImage() -> UIImage {
        return ImageManager().defaultImage
    }
}
