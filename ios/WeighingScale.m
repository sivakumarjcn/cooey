//
//  WeighingScale.m
//  RNCooey
//
//  Created by Sivakumar J on 29/08/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "WeighingScale.h"

@implementation WeighingScale

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}
@end
