//
//  ITSDependencyContainer.swift
//  ITuneSearch
//
//  Created by Oguzhan Yalcin on 27.01.2024.
//

import Foundation
import ITSNetwork
import ITSUtils
import Swinject
import Moya

public class ITSDependencyContainer {

    private let container = Container()

    public static let shared = ITSDependencyContainer()

    init() {
        container.register(ITSNetworkServiceProtocol.self) { _ in
            ITSNetworkService(
                plugins: [
                    NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
                ]
            )
        }.inObjectScope(.container)

        container.register(ITSReachabilityListenerProtocol.self) { _ in
            ITSReachabilityListener()
        }.inObjectScope(.container)
        
        container.register(ITSImageStorageProtocol.self) { r in
            ITSImageStorageURLCache(
                fileCapacity: 512 * 1024 * 1024,
                memoryCapacity: 24 * 1024 * 1024
            )
        }.inObjectScope(.container)

        container.register(ITSImageServiceProtocol.self) { r in
            ITSImageService(cache: Self.getDefaultImageServiceStorage())
        }
    }
    
    public static func getDefaultImageServiceStorage() -> ITSImageStorageProtocol {
        return shared.container.resolve(ITSImageStorageProtocol.self)!
    }
    
    public static func getDefaultNetworkService() -> ITSNetworkServiceProtocol {
        return shared.container.resolve(ITSNetworkServiceProtocol.self)!
    }
    
    public static func getDefaultNetworkListener() -> ITSReachabilityListenerProtocol {
        return shared.container.resolve(ITSReachabilityListenerProtocol.self)!
    }
}
