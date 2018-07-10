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
#else
#import <React/RCTBridgeModule.h>
#endif
#import <VoiceBPLibrary/VoiceBPLibrary.h>

extern NSString * const VOICE_BP_BATTERY_EVENT;
extern NSString * const VOICE_BP_CONNECTION_EVENT;
extern NSString * const VOICE_BP_RESULTS_EVENT;
extern NSString * const VOICE_BP_SYS_PROGRESS_EVENT;
extern NSString * const VOICE_BP_ERROR_EVENT;

@interface VoiceBPMonitor : NSObject <RCTBridgeModule>

@end
