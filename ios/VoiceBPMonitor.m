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

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

RCT_EXPORT_MODULE()

- (instancetype)init {
    if (self = [super init]) {
        self.bpConnectionManager = [[BPMonitorConnectionManager alloc] init];
        __weak VoiceBPMonitor *weakSelf = self;
        [self.bpConnectionManager setOnReciveBatteryStatus:^(NSString *status) {
                NSLog(@"battery status %@", status);
            [weakSelf sendEventWithName:@"voice_bp_battery" body:@{@"status":status}];
        }];
        [self.bpConnectionManager setOnConnectionStatus:^(NSString *status) {
            NSLog(@"connection status %@", status);
            BOOL value = false;
            if([status isEqualToString:@"connected"]) {
                value = true;
            }
            [weakSelf sendEventWithName:@"voice_bp_connection" body:@{@"status":@(value)}];
        }];
        [self.bpConnectionManager setOnComplete:^(CGFloat systolic, CGFloat diastolic, CGFloat heartrate, NSString *errorCode) {
            NSLog(@"data systolic %f, diastolic %f, heart rate %f, errorcode %@", systolic, diastolic, heartrate, errorCode);
            if([errorCode integerValue] == 200) {
                [weakSelf sendEventWithName:@"voice_bp_results" body:@{@"systolic":@(systolic),@"diastolic":@(diastolic),@"heartRate":@(heartrate)}];
            }else {
                [weakSelf sendEventWithName:@"voice_bp_error" body:@{@"errorCode":errorCode,@"error":@"Error"}];
            }

        }];
    }
    return self;
}

RCT_EXPORT_METHOD(connectBPMonitor) {
    [self.bpConnectionManager connect];
}

RCT_EXPORT_METHOD(takeReading) {
    [self.bpConnectionManager takeReading];
    
}

@end
