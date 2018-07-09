//
//  VoiceBPMonitor.m
//  RNCooey
//
//  Created by Sivakumar J on 09/07/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "VoiceBPMonitor.h"


@implementation VoiceBPMonitor
@synthesize bridge = _bridge;
@synthesize bpConnectionManager;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(connectBPMonitor) {
    this.bpConnectionManager = [[BPMonitorConnectionManager alloc] init];
    [this.bpConnectionManager setOnComplete:];
    [this.bpConnectionManager connect];
}

RCT_EXPORT_METHOD(takeReading) {
    [this.BPMonitorConnectionManager takeReading];
    
}

@end
