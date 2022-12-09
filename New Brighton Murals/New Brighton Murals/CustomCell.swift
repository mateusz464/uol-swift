//
//  CustomCell.swift
//  New Brighton Murals
//
//  Created by Mateusz Golebiowski on 08/12/2022.
//

import UIKit

class CustomCell: UITableViewCell {
        
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var artistLbl: UILabel!
    
    
    func setImage(urlString: String){
        
        let url = NSURL(string: urlString)! as URL
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard
                let data = data,
                let newImage = UIImage(data: data) else {
                print("Couldn't load image from URL")
                return
            }

            DispatchQueue.main.async {
                self.cellImageView.image = newImage
            }
        }
        task.resume()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
