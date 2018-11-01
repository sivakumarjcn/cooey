
#import "RNCooey.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "VoiceBPMonitor.h"

NSString * const VOICE_BP_BATTERY_EVENT = @"voice_bp_battery";
NSString * const VOICE_BP_CONNECTION_EVENT = @"voice_bp_connection";
NSString * const VOICE_BP_RESULTS_EVENT = @"voice_bp_results";
NSString * const VOICE_BP_SYS_PROGRESS_EVENT = @"voice_bp_sys_progress";
NSString * const VOICE_BP_ERROR_EVENT = @"voice_bp_error";

NSString * const GLUCO_DEVICE_CONNECTION = @"gluco_device_connection";
NSString * const GLUCO_DEVICE_RESULT = @"gluco_test_result";
NSString * const GLUCO_DEVICE_PROGRESS = @"gluco_test_progress";

NSString * const WEIGH_DEVICE_CONNECTION = @"wt_connectionStatus";
NSString * const WEIGH_DEVICE_READING_STATUS = @"wt_readingStatus";
NSString * const WEIGH_SCALE_RESULT = @"weighingScaleResult";


@implementation RNCooey

RCT_EXPORT_MODULE(Cooey)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}



- (NSArray<NSString *> *)supportedEvents {
    return @[
             VOICE_BP_CONNECTION_EVENT,
             VOICE_BP_BATTERY_EVENT,
             VOICE_BP_RESULTS_EVENT,
             VOICE_BP_SYS_PROGRESS_EVENT,
             VOICE_BP_ERROR_EVENT,
             GLUCO_DEVICE_CONNECTION,
             GLUCO_DEVICE_RESULT,
             GLUCO_DEVICE_PROGRESS,
             WEIGH_DEVICE_CONNECTION,
             WEIGH_DEVICE_READING_STATUS,
             WEIGH_SCALE_RESULT
             ];
}

- (void)startObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passEvent:)
                                                 name:@"RNCOOEY_NOTIFICATION"
                                               object:nil];
    
}

- (void)passEvent:(NSNotification *)notification {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
    NSString *eventName = [[userInfo valueForKey:@"eventName"] copy];
    if(eventName) {
        [userInfo removeObjectForKey:@"eventName"];
        [self sendEventWithName:eventName body:userInfo];
    }
    
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
  
