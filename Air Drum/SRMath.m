//
//  SRMath.m
//  3D Protractor
//
//  Created by Rotek on 12-12-25.
//  Copyright (c) 2012年 Rotek. All rights reserved.
//

#import "SRMath.h"

@implementation SRMath

+ (double)changePrecision:(int)precision WithNumber:(double)number
{
    /* example: number = 3.4684;
     * buffer1 = 3468;
     * buffer2 = 8 > 5;
     * buffer3 = 346 + 1 = 347;
     * buffer4 = 3.47;
     */
    double buffer0 = fabs(number);
    int buffer1 = (int)(buffer0 * pow(10, precision +1));
    int buffer2 = buffer1 % 10;
    int buffer3 = buffer1 / 10;

    
    if (buffer2 >= 5) {
        buffer3 += 1;
    }
    
    double buffer4 = (double)buffer3 / pow(10, precision);
    return number >= 0 ? buffer4 : buffer4 * -1;
    
    
}

+ (GLKQuaternion)GLKQuaternion:(GLKQuaternion)q1 rotateWithQuaternion:(GLKQuaternion)q2
{
    GLKQuaternion q;
    q.w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
    q.x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
    q.y = q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z;
    q.z = q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x;
    
    q = GLKQuaternionNormalize(q);
    return q;
    
}



+ (GLKQuaternion)createFromVector0:(GLKVector3)v0 vector1:(GLKVector3)v1
{
    GLKVector3 sum = GLKVector3Add(v0, v1);
    if ((sum.x == 0) && (sum.y == 0) && (sum.z == 0)) {
        return GLKQuaternionMakeWithAngleAndVector3Axis(M_PI, GLKVector3Make(1, 0, 0));
    }
    
    GLKVector3 c = GLKVector3CrossProduct(v0, v1);
    float d = GLKVector3DotProduct(v0, v1);
    float s = sqrtf((1+d)*2);
    
    return GLKQuaternionMake(c.x/s, c.y/s, c.z/s, s/2.0f);
}

@end
