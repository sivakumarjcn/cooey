//
//  VoiceBPMonitor.m
//  RNCooey
//
//  Created by Sivakumar J on 09/07/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "VoiceBPMonitor.h"
#import <VoiceBPLibrary/VoiceBPLibrary.h>

@interface VoiceBPMonitor()
@property (nonatomic, strong) BPMonitorConnectionManager *bpConnectionManager;
@end



@implementation VoiceBPMonitor

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;
@synthesize bpConnectionManager;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}



- (instancetype)init {
    if (self = [super init]) {
        self.bpConnectionManager = [[BPMonitorConnectionManager alloc] init];
        __weak VoiceBPMonitor *weakSelf = self;
        [self.bpConnectionManager setOnReciveBatteryStatus:^(NSString *status) {
                NSLog(@"battery status %@", status);
            if(weakSelf) {
                [weakSelf sendEventWithName:@"voice_bp_battery" body:@{@"status":[NSNumber numberWithBool:status]}];
            }
           
        }];
        [self.bpConnectionManager setOnConnectionStatus:^(NSString *status) {
            NSLog(@"connection status %@", status);
            BOOL value = false;
            if( [status caseInsensitiveCompare:@"Connected"] == NSOrderedSame ) {
                 value = true;
            }
            if(weakSelf) {
                  [weakSelf sendEventWithName:@"voice_bp_connection" body:@{@"status":@(value)}];
            }
          
        }];
        [self.bpConnectionManager setOnComplete:^(CGFloat systolic, CGFloat diastolic, CGFloat heartrate, NSString *errorCode) {
            NSLog(@"data systolic %f, diastolic %f, heart rate %f, errorcode %@", systolic, diastolic, heartrate, errorCode);
            if(weakSelf) {
                if([errorCode integerValue] == 200) {
                    [weakSelf sendEventWithName:@"voice_bp_results" body:@{@"systolic":[NSNumber numberWithFloat:systolic],@"diastolic":[NSNumber numberWithFloat:diastolic],@"heartRate":[NSNumber numberWithFloat:heartrate]}];
                }else {
                    [weakSelf sendEventWithName:@"voice_bp_error" body:@{@"errorCode":errorCode,@"error":@"Error"}];
                }
            }
        }];
        
        [self.bpConnectionManager setOnRecivedBPContinousValue:^(NSString * systolicValue) {
            if(systolicValue && weakSelf) {
                NSCharacterSet *unwantedChars = [NSCharacterSet characterSetWithCharactersInString:@"\"[]"];
                NSString *requiredString = [[systolicValue componentsSeparatedByCharactersInSet:unwantedChars] componentsJoinedByString: @""];
                NSNumber *progress = [NSNumber numberWithInteger:[requiredString integerValue]];
                [weakSelf sendEventWithName:@"voice_bp_sys_progress" body:@{@"progress":progress}];
            }
    
        }];
        
    }
    return self;
}

-(void)sendEventWithName:(NSString*)eventName body:(NSDictionary *)body {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:body];
    [userInfo setValue:eventName forKey:@"eventName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RNCOOEY_NOTIFICATION" object:nil userInfo:userInfo];
}

RCT_EXPORT_METHOD(connectBPMonitor) {
    [self.bpConnectionManager connect];
}

RCT_EXPORT_METHOD(takeReading) {
    [self.bpConnectionManager takeReading];
    
}

@end
