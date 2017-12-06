//
//  SRHitDetector.m
//  HeadHit
//
//  Created by Rotek on 3/7/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import "SRHitDetector.h"
#import <CoreMotion/CoreMotion.h>
#import "SRMath.h"

NSString *const HitDetectedNotification = @"HitDetectedNotification";


  
@interface SRHitDetector ()
{
    float _degree0;
    float _degree1;
    float _degree2;
    float _degree3;
    //float _degree4;
    float _sensitivity;
}

@property (nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSNumber *directionDegree;

@end

@implementation SRHitDetector
@synthesize motionManager = _motionManager;
@synthesize timer = _timer;
@synthesize directionDegree = _directionDegree;

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static SRHitDetector *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (float)horizontalDegree
{
    return [self.directionDegree floatValue];
}

- (float)verticalDegree
{
    return _degree3;
}

#pragma mark - Private Methods

- (id)init
{
    if (self = [super init]) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.01f;
        
        _degree0 = 0;
        _degree1 = 0;
        _degree2 = 0;
        _degree3 = 0;
        //_degree4 = 0;
        _sensitivity = 5.0f;
    }
    
    return self;
}

- (void)startUpdate
{
    if (self.motionManager.isDeviceMotionAvailable) {
        if (!self.motionManager.isDeviceMotionActive) {
            [self.motionManager startDeviceMotionUpdates];

            NSLog(@"Start device motion");
        }
    } else NSLog(@"Device motion unavailable");
    
}

- (void)stopUpdate
{
    if (self.motionManager.isDeviceMotionAvailable) {
        if (self.motionManager.isDeviceMotionActive) {
            [self.motionManager stopDeviceMotionUpdates];
            NSLog(@"Stop device motion");
        }
    } else NSLog(@"Device motion unavailable");
}

- (void)startHitDetect
{
        
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.015f target:self selector:@selector(updateDataAndAnalyse) userInfo:nil repeats:YES];

}

- (void)stopHitDetect
{
    [self.timer invalidate];
}

- (void)reset
{
    [self stopHitDetect];
    [self stopUpdate];
    [self startUpdate];
    [self startHitDetect];
}

- (void)changeDetectSensitivity:(float)rate
{
    _sensitivity = rate;
}

- (float)detectSensitivity
{
    return _sensitivity;
}

- (void)updateDataAndAnalyse
{
    float _currentDegree = [self calculateCurrentDegree];
    //NSLog(@"degree = %f",_currentDegree);
    // Update data
    _degree0 = _degree1;
    _degree1 = _degree2;
    _degree2 = _degree3;
    _degree3 = _currentDegree;
    //_degree4 = _currentDegree;
    
    // Analyse
    
    
    // timeInterval :0.01 delta: 1.3
    // timeInterval: 0.02 delta: 15

    float delta = fabsf(_degree0 - _degree1) + fabsf(_degree1 - _degree2) + fabsf(_degree2 - _degree3);
    if ((_degree0 >= _degree1) && (_degree1 >= _degree2) && (_degree2 < _degree3)) {
       // NSLog(@"Basic hit detected");
        //NSLog(@"delta is %f",delta);

        if (delta > _sensitivity) {
            NSLog(@"Hit detected");
            //NSLog(@"delta is %f,direction:%f",delta,[self.directionDegree floatValue]);
            
            // Wrap the object to send
            NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:self.directionDegree,HIT_HORIZONTAL_DEGREE,[NSNumber numberWithFloat:_degree3],HIT_VERTICAL_DEGREE, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:HitDetectedNotification object:message];
        }
    }
}

- (float)calculateCurrentDegree
{
    GLKQuaternion currentAttitude = GLKQuaternionMake(self.motionManager.deviceMotion.attitude.quaternion.x, self.motionManager.deviceMotion.attitude.quaternion.y, self.motionManager.deviceMotion.attitude.quaternion.z, self.motionManager.deviceMotion.attitude.quaternion.w);
    
    GLKVector3 initVector = GLKVector3Make(0, 1, 0);
    GLKVector3 currentVector = GLKQuaternionRotateVector3(currentAttitude, initVector);
    
    GLKVector3 gravity = GLKVector3Make(0, 0, -1);
    
    GLKQuaternion delta = [SRMath createFromVector0:currentVector vector1:gravity];
    float degree = GLKQuaternionAngle(delta) * 180.0 / M_PI;
    
    
    // Calculate direction degree
    GLKVector3 projectionVector = GLKVector3Normalize(GLKVector3Make(currentVector.x, currentVector.y, 0));
    GLKQuaternion theta = [SRMath createFromVector0:initVector vector1:projectionVector];
    float direction = GLKQuaternionAngle(theta) * 180.0 / M_PI;
    
    self.directionDegree = [[NSNumber alloc] initWithFloat: projectionVector.x >= 0 ? direction : - direction];
    
    
    
    
    
    
    return degree;
    
}

@end
