//
//  VoiceBPMonitor.h
//  RNCooey
//
//  Created by Sivakumar J on 09/07/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#endif
#import <VoiceBPLibrary/VoiceBPLibrary.h>

@interface VoiceBPMonitor : RCTEventEmitter <RCTBridgeModule>
@property BPMonitorConnectionManager *bpConnectionManager;

@end
