//
//  LWBlueToothManager.swift
//  CoreBlueTooth
//
//  Created by liuwei on 2019/6/26.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit
import CoreBluetooth

class LWBlueToothManager: NSObject {
    
    private lazy var centralManager: CBCentralManager = {
        let options : [String : Any] = [
            CBCentralManagerOptionShowPowerAlertKey : NSNumber(booleanLiteral: true),
            CBCentralManagerOptionRestoreIdentifierKey : "reuseID",
            CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(booleanLiteral: false)]
        let centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(), options: options)
        return centralManager
    }()
    
    lazy var peripherals = [CBPeripheral]()
    
    override init() {
        super.init()
    }
}

extension LWBlueToothManager {
    func startScan() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func connect(peripheral : CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
    
}

extension LWBlueToothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("peripheral connect")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("peripheral failtoconnect")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("peripheral disconnect")
    }
}

extension LWBlueToothManager : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {
            print("services is nil")
            return
        }
        
        for service in services {
            if service.uuid.uuidString == "someUUID" {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard  let characteristics = service.characteristics else {
            print("characteristics is nil")
            return
        }
       
        for characteristic in characteristics {
            if characteristic.uuid.uuidString == "someUUID" {
                
            }
        }
    }
}






