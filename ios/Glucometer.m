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

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bloodTesterStatusChanged:) name:BLOOD_TESTER_STATUS_CHANGED  object:nil];
        
        [AVAudioSession sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
        
    }
    return self;
}
    
-(void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionRouteChangeReason routeChangeReason = [[info valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable: {
            //Device is plugged-in
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"plugged_in"}];
        }
        break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable : {
            //Device Disconnected
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"plugged_out"}];
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
    switch (status) {
        case TEST_STATUS_WAITING_DEVICE_PLUGIN: {
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"waiting_to_plugin"}];
        }
        break;
        case TEST_STATUS_WAKING_UP_DEVICE: {
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"communicating"}];
        }break;
        case TEST_STATUS_RECOGNIZE_DEVICE: {
             [self sendEventWithName:@"Device_Connection" body:@{@"status":@"communicating"}];
        }break;
        case TEST_STATUS_DEVICE_CHECKE_FINISH: {
             [self sendEventWithName:@"Device_Connection" body:@{@"status":@"insert_paper"}];
        }break;
        case TEST_STATUS_PAPER_USED: {
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"old_paper_user"}];
        }break;
        case TEST_STATUS_PAPER_OUT: {
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"paper_out"}];
        }break;
        case TEST_STATUS_START_TEST: {
            NSInteger progress = [[params valueForKey:PARAM_TEST_PROGRESS] integerValue];
            NSInteger countDown = 10 - progress;
            NSLog(@"count down %ld", (long)countDown);
            [self sendEventWithName:@"test_progress" body:@{@"progress":[NSNumber numberWithInteger:countDown]}];
        }break;
        case TEST_STATUS_TEST_COMPLETE: {
            
            double result = [[params valueForKey:PARAM_TEST_RESULT_VALUE] doubleValue];
            NSString *title = [BloodTester formatValue:result];
            double sugarLevel = result * 16;
            NSLog(@"title %@ sugar %f", title, sugarLevel);
            [self sendEventWithName:@"test_result" body:@{@"result":[NSNumber numberWithDouble:sugarLevel], @"title":title}];
        }break;
        case TEST_STATUS_CHECK_ERROR: {
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"coonection_failed"}];
        }break;
        
        case TEST_STATUS_TIME_OUT_DEVICE_SLEEP: {
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"coonection_failed"}];
        }break;
        case TEST_STATUS_NEED_CALIBRATION:
        case TEST_STATUS_LOW_POWER:
        case TEST_STATUS_TEMPERATURE_LOW_ERROR:
        case TEST_STATUS_TEMPERATURE_HIGH_ERROR:
        case TEST_STATUS_TEST_TIMEOUT:
        case TEST_STATUS_UNKNOW_CAUSE_ERROR :{
            [self sendEventWithName:@"Device_Connection" body:@{@"status":@"coonection_failed"}];
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
