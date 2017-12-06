//  3D Protractor
//
//  Created by Rotek on 12-12-25.
//  Copyright (c) 2012年 Rotek. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface SRMath : NSObject

// 精确到小数点后precision 位


+ (GLKQuaternion)GLKQuaternion:(GLKQuaternion)q1 rotateWithQuaternion:(GLKQuaternion)q2;
+ (GLKQuaternion)createFromVector0:(GLKVector3)v0 vector1:(GLKVector3)v1;



@end

