//
//  RouteChain.swift
//  Prometheus
//
//  Created by pyretttt pyretttt on 03.05.2022.
//

import UIKit

protocol RouteChainLink: AnyObject {
    var prevLink: RouteChainLink? { get }
    var nextLink: RouteChainLink? { get }
    
    func route(navigationController: UINavigationController?)
}
