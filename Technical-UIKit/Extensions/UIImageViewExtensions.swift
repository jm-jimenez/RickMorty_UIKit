//
//  UIImageViewExtensions.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import Foundation
import UIKit

protocol CancelableTask {
    func cancel()
}

extension URLSessionDataTask: CancelableTask { }

extension UIImageView {
    @discardableResult
    func setRemoteImage(url: String, completion: (() -> Void)? = nil) -> CancelableTask? {
        let client = URLSession.shared
        guard let url = URL(string: url) else { return nil }
        let task = client.dataTask(with: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)) { data, _, _ in
            guard let data else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: data)
                completion?()
            }
        }
        task.resume()
        return task
    }
}
