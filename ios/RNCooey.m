
#import "RNCooey.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "VoiceBPMonitor.h"

NSString * const VOICE_BP_BATTERY_EVENT = @"voice_bp_battery";
NSString * const VOICE_BP_CONNECTION_EVENT = @"voice_bp_connection";
NSString * const VOICE_BP_RESULTS_EVENT = @"voice_bp_results";
NSString * const VOICE_BP_SYS_PROGRESS_EVENT = @"voice_bp_sys_progress";
NSString * const VOICE_BP_ERROR_EVENT = @"voice_bp_error";

@implementation RNCooey

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
             VOICE_BP_CONNECTION_EVENT,
             VOICE_BP_BATTERY_EVENT,
             VOICE_BP_RESULTS_EVENT,
             VOICE_BP_SYS_PROGRESS_EVENT,
             VOICE_BP_ERROR_EVENT
             ];
}

- (void)startObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passEvent:)
                                                 name:@"RNCOOEY_NOTIFICATION"
                                               object:nil];
    
}

- (void)passEvent:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if([userInfo valueForKey:@"eventName"]) {
        [self sendEventWithName:[userInfo valueForKey:@"eventName"] body:userInfo];
    }
    
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
  
