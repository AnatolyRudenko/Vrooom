//
//  ViewController.swift
//  Vrooom
//
//  Created by Admin on 17.09.2020.
//  Copyright © 2020 Rudenko. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var selectedIndex: Int?
    let realm = try! Realm()
    var cars: Results<CarList>?
    var rowHeights:[Int:CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCars()
        tableView.register(UINib(nibName: K.cell.nibName, bundle: nil), forCellReuseIdentifier: K.cell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
         self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func loadCars() {
        cars = realm.objects(CarList.self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.fromListToConfirm {
            if let svc = segue.destination as? ConfirmViewController {
            svc.prepareRealm()
            OperatedCar.newCar = false
            }
        }
    }
    
    //MARK: - load Images
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }

    func getImage(cell: Int) -> UIImage? {
        guard let carName = cars?[cell].name else {return nil}
        let imageName:String = "\(carName).png"
        let imagePath = fileInDocumentsDirectory(imageName)
        guard let loadedImage = self.loadImageFromPath(imagePath) else {return nil }
        return loadedImage
    }
   
    func loadImageFromPath(_ path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("couldn't find image in confirm at path: \(path)")
        }
        return image
    }
}

    //MARK: - UITableViewDelegate, UITableViewDataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListCell = self.tableView.dequeueReusableCell(withIdentifier: K.cell.reuseIdentifier) as! ListCell
        
        cell.nameLabel.text = cars?[indexPath.row].name ?? "Нет имени"
        
        guard let safeImageName = cars?[indexPath.row].imageName else { //if car has no image info
            if let defaultImage = UIImage(named: "NoImage.png") {
                cell.setImage(defaultImage)
            }
            return cell
        }

        guard let preloadedCarImage = UIImage(named: safeImageName) else { //if it's a preloaded image
            if let customImage = getImage(cell: indexPath.row) { //else it's a custom image
                cell.setImage(customImage)
            }
            return cell
        }
        cell.setImage(preloadedCarImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        OperatedCar.index = indexPath.row
        self.performSegue(withIdentifier: K.segues.fromListToConfirm, sender: nil)
    }
}