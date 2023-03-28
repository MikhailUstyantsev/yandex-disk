//
//  UserProfileViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import Foundation
import Charts


final class UserProfileViewModel: ChartViewDelegate {
    
    var coordinator: UserProfileCoordinator?
    
    var onUpdate: () -> Void = {}
    
    var occupiedData: Double = 0
    var totalData: Double = 0
    
    var entries = [ChartDataEntry]()
    
    func fetchDiskData() {
        let request = YDRequest.getDiskDataRequest
        YDService.shared.execute(request, expecting: YDGetDiskDataResponse.self) { result in
            switch result {
            case .success(let diskDataResponse):
                self.occupiedData = self.bytesToMegabytes(diskDataResponse.usedSpace)
                self.totalData = self.bytesToMegabytes(diskDataResponse.totalSpace)
                print("Occupied \(self.occupiedData) MB")
                print("Total disk has \(self.totalData) MB")
                self.onUpdate()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    //MARK: - Helper methods
    
    func bytesToMegabytes(_ bytes: Int) -> Double {
        let megabytes = Double(bytes) / 1048576
        let roundedMegabytes = Double(round(100 * megabytes) / 100)
        return roundedMegabytes
    }
    
    deinit {
        print("deinit from UserProfileViewModel")
    }
}
