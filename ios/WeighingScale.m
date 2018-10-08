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
#if !TARGET_IPHONE_SIMULATOR
@property (nonatomic, strong)ScaleReadingManager *scaleReadingManager;
@property (nonatomic, strong) ScaleConnectionManager *scaleConnectionManager;
#endif

@end

@implementation WeighingScale

RCT_EXPORT_MODULE()


@synthesize bridge = _bridge;
#if !TARGET_IPHONE_SIMULATOR
@synthesize scaleReadingManager;
@synthesize scaleConnectionManager;
#endif

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
        #if !TARGET_IPHONE_SIMULATOR
        self.scaleConnectionManager = [[ScaleConnectionManager alloc] init];
        self.scaleReadingManager = [[ScaleReadingManager alloc] init];
        
        __weak WeighingScale *weakSelf = self;
        
        [self.scaleConnectionManager setOnStatusUpdate:^(NSString * _Nonnull status) {
           [weakSelf sendEventWithName:@"connectionStatus" body:@{@"status":status}];
        }];
        [self.scaleReadingManager setOnStatusUpdate:^(NSString * _Nonnull status) {
            [weakSelf sendEventWithName:@"readingStatus" body:@{@"status":status}];
        }];
        
 
        [self.scaleReadingManager setGetValue:^(CGFloat weight, CGFloat bmi, CGFloat fatPercent, CGFloat waterPercent, CGFloat musclePercent, CGFloat bonePercent) {
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            [result setObject:[NSNumber numberWithFloat:weight] forKey:@"weight"];
             [result setObject:[NSNumber numberWithFloat:bmi] forKey:@"bmi"];
             [result setObject:[NSNumber numberWithFloat:fatPercent] forKey:@"fatPercent"];
             [result setObject:[NSNumber numberWithFloat:waterPercent] forKey:@"waterPercent"];
             [result setObject:[NSNumber numberWithFloat:musclePercent] forKey:@"musclePercent"];
             [result setObject:[NSNumber numberWithFloat:bonePercent] forKey:@"bonePercent"];
            
            [weakSelf sendEventWithName:@"weighingScaleResult" body:result];
        }];
        #endif
    }
    
    return self;
}


RCT_EXPORT_METHOD(pairDevice: (NSDictionary*) userData ) {
    #if !TARGET_IPHONE_SIMULATOR
    NSInteger age = [[userData valueForKey:@"age"] integerValue];
    NSInteger gender = [[userData valueForKey:@"gender"] integerValue];
    NSInteger height = [[userData valueForKey:@"height"] integerValue];
    
    [self.scaleConnectionManager setUserDataWithAge:age height:height genflag:gender];
    
    [self.scaleConnectionManager scan];
    #endif
}

RCT_EXPORT_METHOD(takeReading: (NSDictionary*) userData) {
     #if !TARGET_IPHONE_SIMULATOR
    NSInteger age = [[userData valueForKey:@"age"] integerValue];
    NSInteger gender = [[userData valueForKey:@"gender"] integerValue];
    NSInteger height = [[userData valueForKey:@"height"] integerValue];
    
    [self.scaleReadingManager setUsrage:age];
    [self.scaleReadingManager setUsrgender:gender];
    [self.scaleReadingManager setUsrheight:height];
    [self.scaleReadingManager scan];
    #endif
}

RCT_EXPORT_METHOD(stopDevice) {
    //no method available
}

-(void)sendEventWithName:(NSString*)eventName body:(NSDictionary *)body {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:body];
    [userInfo setValue:eventName forKey:@"eventName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RNCOOEY_NOTIFICATION" object:nil userInfo:userInfo];
}
    
@end
