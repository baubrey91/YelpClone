//
//  MapCollectionViewController.swift
//  Yelp
//
//  Created by Brandon on 4/6/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import UIKit

class MapCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController {
            vc.businesses = businesses
        }
    }
}

extension MapCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.business = businesses[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionViewCell", for: indexPath) as! MapCollectionViewCell
        
        cell.businessLabel.text = businesses[indexPath.row].name
        cell.businessImage.setImageWith(businesses[indexPath.row].imageURL!)
        
        return cell
    }
    
}
