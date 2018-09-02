//
//  WeighingScale.m
//  RNCooey
//
//  Created by Sivakumar J on 29/08/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "WeighingScale.h"
#import <CooeyA2WeighingScale/CooeyA2WeighingScale.h>

@interface WeighingScale()
@property (nonatomic, strong)ScaleReadingManager *scaleReadingManager;
@property (nonatomic, strong) ScaleConnectionManager *scaleConnectionManager;
@end

@implementation WeighingScale

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;
@synthesize scaleReadingManager;
@synthesize scaleConnectionManager;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}
    
- (instancetype)init {
    if(self = [super init]) {
        self.scaleConnectionManager = [[ScaleConnectionManager alloc] init];
        self.scaleReadingManager = [[ScaleReadingManager alloc] init];
        [self.scaleConnectionManager setOnStatusUpdate:^(NSString * _Nonnull status) {
            
        }];
        [self.scaleReadingManager setGetValue:^(CGFloat weight, CGFloat bmi, CGFloat fatPercent, CGFloat waterPercent, CGFloat musclePercent, CGFloat bonePercent) {
            
        }];
    }
    return self;
}


RCT_EXPORT_METHOD(pairDevice) {
    [self.scaleConnectionManager scan];
}

RCT_EXPORT_METHOD(takeReading) {
    [self.scaleReadingManager scan];
}
    
@end
