//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import SwiftUI
import Combine
import Network

extension NWPath.Status {
    public var friendlyString: String {
        switch self {
        case .requiresConnection:
            return "requiresConnection"
        case .satisfied:
            return "satisfied"
        case .unsatisfied:
            return "unsatisfied"
        default:
            return "unknown"
        }
    }
}

public class NetworkStateViewModel: NSObject, ObservableObject{
    
    //let objectWillChange = PassthroughSubject<Void, Never>()
    
    //    @Published var someVar: Int = 0 {
    //      willSet { objectWillChange.send() }
    //    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published public private(set) var pathStatus: NWPath.Status = NWPath.Status.unsatisfied
    @Published public private(set) var isExpensive: Bool = false
    
    public override init() {
        super.init()
        
        monitor.pathUpdateHandler = { path in
            self.pathStatus = path.status
            self.isExpensive = path.isExpensive
        }
        //        let cellMonitory = NWPathMonitor(requiredInterfaceType: .cellular)
        //        let wifiMonitory = NWPathMonitor(requiredInterfaceType: .wifi)
        
        self.pathStatus = monitor.currentPath.status
        self.isExpensive = monitor.currentPath.isExpensive
                
        monitor.start(queue: queue)
    }
}
