//
//  Glucometer.m
//  RNCooey
//
//  Created by Sivakumar J on 29/08/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Glucometer.h"
#import "BloodTester.h"
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Glucometer()
@property (nonatomic, strong) BloodTester *bloodTester;
@end

@implementation Glucometer

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;
@synthesize bloodTester;

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
        self.bloodTester = [[BloodTester alloc] init];
        [self.bloodTester setupAudio];
        
        [AVAudioSession sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
        
        
        [self.bloodTester setTestType:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bloodTesterStatusChanged:) name:@"bloodTesterStatusChanged"  object:nil];
    }
    
    return self;
}

RCT_EXPORT_METHOD(setUp) {
    
}

RCT_EXPORT_METHOD(startMeasuring:(NSInteger)testType) {
    // 1 - fasting
    // 2 - after meal
    // 3 - random
    [self.bloodTester wakeupDevice];
    [self.bloodTester setTestType:testType];
}

RCT_EXPORT_METHOD(stopMeasuring) {
    //reset
    [self.bloodTester setTestType:0];
}


-(void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionRouteChangeReason routeChangeReason = [[info valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable: {
            //Device is plugged-in
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"plugged_in"}];
            if(self.bloodTester) {
              [self.bloodTester setTestType:1];
            }
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable : {
            //Device Disconnected
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"plugged_out"}];
        }
        case AVAudioSessionRouteChangeReasonCategoryChange: {
            
        }
        default:
            break;
    }
}



-(void)bloodTesterStatusChanged:(NSNotification*)notification {
    NotifyStatus *notifyStatus = (NotifyStatus*)notification.object;
    NSDictionary *params = notifyStatus.params;
    DNUTestStatus status = notifyStatus.status;
    NSLog(@"GLUCODEVICE status %ld", (long)status);
    switch (status) {
        case TEST_STATUS_WAITING_DEVICE_PLUGIN: {
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"plugged_out"}];
        }
            break;
        case TEST_STATUS_WAKING_UP_DEVICE: {
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"communicating"}];
        }
            break;
        case TEST_STATUS_RECOGNIZE_DEVICE: {
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"recognized"}];
        }
            break;
        case TEST_STATUS_PAPER_INSERTED: {
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"readyToTest"}];
        }
            break;
        case TEST_STATUS_DEVICE_CHECKE_FINISH: {
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"insert_paper"}];
        }
            break;
        case TEST_STATUS_PAPER_USED: {
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"old_paper_used"}];
        }
            break;
        case TEST_STATUS_PAPER_OUT: {
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"paper_out"}];
        }
            break;
        case TEST_STATUS_START_TEST: {
            NSInteger progress = [[params valueForKey:@"test_progress"] integerValue];
            NSInteger countDown = 10 - progress;
            NSLog(@"count down %ld", (long)countDown);
            [self sendEventWithName:@"gluco_test_progress" body:@{@"progress":[NSNumber numberWithInteger:countDown]}];
        }
            break;
        case TEST_STATUS_TEST_COMPLETE: {
            
            double result = [[params valueForKey:@"test_value"] doubleValue];
            NSString *title = [BloodTester formatValue:result];
            double sugarLevel = result * 16;
            NSLog(@"title %@ sugar %f", title, sugarLevel);
            [self sendEventWithName:@"gluco_test_result" body:@{@"result":[NSNumber numberWithDouble:sugarLevel], @"title":title}];
        }
            break;
        case TEST_STATUS_CHECK_ERROR: {
        }
            break;
        case TEST_STATUS_TIME_OUT_DEVICE_SLEEP:
         
        case TEST_STATUS_NEED_CALIBRATION:
        case TEST_STATUS_LOW_POWER:
        case TEST_STATUS_TEMPERATURE_LOW_ERROR:
        case TEST_STATUS_TEMPERATURE_HIGH_ERROR:
        case TEST_STATUS_TEST_TIMEOUT:
        case TEST_STATUS_UNKNOW_CAUSE_ERROR :{
            [self sendEventWithName:@"gluco_device_connection" body:@{@"status":@"connection_failed"}];
        }break;
            
        default:
            break;
    }
}

-(void)sendEventWithName:(NSString*)eventName body:(NSDictionary *)body {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:body];
    [userInfo setValue:eventName forKey:@"eventName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RNCOOEY_NOTIFICATION" object:nil userInfo:userInfo];
}

@end
