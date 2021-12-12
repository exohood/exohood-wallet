//
//  CoinSwitchAPI.swift
//  CoinSwitchAPI
//
//  Created by Dominique Stranz on 14/05/2019.
//

import Foundation
#if canImport(CoinpaprikaNetworking)
import CoinpaprikaNetworking
#else
import Coinpaprika
#endif

public typealias CoinSwitchAPI = API

public struct API {
    private let credentials: Credentials
    private let baseUrl: URL
    
    /// Create CoinSwitch API client
    /// - Parameter key: access key, generated by CoinSwitch
    /// - Parameter userIp: client user IP
    /// - Parameter baseUrl: custom API URL - use only to reach alternative servers
    public init(key: String, userIp: String? = nil, baseUrl: URL? = nil) {
        self.credentials = Credentials(key: key, ip: userIp)
        self.baseUrl = baseUrl ?? URL(string: "https://api.coinswitch.co/v2")!
    }
    
    /// Supported coins list
    public func getCoins() -> CoinSwitchRequest<[Coin]> {
        return CoinSwitchRequest<[Coin]>(baseUrl: baseUrl, method: .get, path: "coins", params: [:], credentials: credentials)
    }
    
    /// Supported exchange pairs
    /// - Parameter depositCoin: deposit coin id (optional)
    /// - Parameter destinationCoin: destination coin id (optional)
    public func getPairs(depositCoin: String?, destinationCoin: String?) -> CoinSwitchRequest<[Pair]> {
        var params = [String: Any]()
        params["depositCoin"] = depositCoin
        params["destinationCoin"] = destinationCoin
        return CoinSwitchRequest<[Pair]>(baseUrl: baseUrl, method: .post, path: "pairs", params: params, credentials: credentials)
    }
    
    /// Conversion rate for one exchange pair
    /// - Parameter depositCoin: deposit coin id
    /// - Parameter destinationCoin: destination coin id
    public func getRate(depositCoin: String, destinationCoin: String) -> CoinSwitchRequest<Rate> {
        var params = [String: Any]()
        params["depositCoin"] = depositCoin
        params["destinationCoin"] = destinationCoin
        return CoinSwitchRequest<Rate>(baseUrl: baseUrl, method: .post, path: "rate", params: params, credentials: credentials)
    }
    
    /// Conversion rates for all supported coins
    /// - Parameter depositCoin: deposit coin id (optional)
    /// - Parameter destinationCoin: destination coin id (optional)
    public func getRates(depositCoin: String?, destinationCoin: String?) -> CoinSwitchRequest<[CoinRate]> {
        var params = [String: Any]()
        params["depositCoin"] = depositCoin
        params["destinationCoin"] = destinationCoin
        return CoinSwitchRequest<[CoinRate]>(baseUrl: baseUrl, method: .post, path: "bulk-rate", params: params, credentials: credentials)
    }
    
    /// Create exchange order
    /// - Parameter params: Exchange order params
    public func createOrder(params: NewOrderParams) -> CoinSwitchRequest<NewOrder> {
        return CoinSwitchRequest<NewOrder>(baseUrl: baseUrl, method: .post, path: "order", params: params.asDictionary ?? [:], credentials: credentials)
    }
    
    /// Current order status
    /// - Parameter id: order id from `createOrder` method
    public func getOrder(id: String) -> CoinSwitchRequest<Order> {
        return CoinSwitchRequest<Order>(baseUrl: baseUrl, method: .get, path: "order/\(id)", params: [:], credentials: credentials)
    }
    
    /// List all created orders
    public func getOrders() -> CoinSwitchRequest<ItemsList<Order>> {
        return CoinSwitchRequest<ItemsList<Order>>(baseUrl: baseUrl, method: .get, path: "orders", params: [:], credentials: credentials)
    }
}
