//
//  NetworkResponse.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 3/2/23.
//

import Foundation

enum NetworkResponse<Output, Error> {
    case success(output: Output)
    case error(error: Error)
}
