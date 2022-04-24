//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/8/22.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: "avatar-placeholder")!
    let cache = NetworkManager.shared.cash

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        //clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = placeholderImage

    }

    func downloadAvatarImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }

            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }

        task.resume()
    }
}
