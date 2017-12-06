//
//  SRHitDetector.h
//  HeadHit
//
//  Created by Rotek on 3/7/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import <Foundation/Foundation.h>

/* define notification sending object dictionary key */
#define HIT_HORIZONTAL_DEGREE   @"Hit horizontal degree"  //打击指向的水平方向
#define HIT_VERTICAL_DEGREE      @"Hit vertical degree"     //打击指向的垂直方向

UIKIT_EXTERN NSString *const HitDetectedNotification;
@interface SRHitDetector : NSObject

+ (id)sharedInstance;

- (void)reset;
- (void)startUpdate;
- (void)stopUpdate;
- (void)startHitDetect;
- (void)stopHitDetect;
- (void)changeDetectSensitivity:(float)rate;
- (float)detectSensitivity;

- (float)horizontalDegree;
- (float)verticalDegree;

@end
