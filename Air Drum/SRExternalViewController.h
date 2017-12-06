//
//  SRExternalViewController.h
//  Air Drum
//
//  Created by Rotek on 5/24/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kCymbal,
    kLeftTom,
    kMiddleTom,
    kRightTom,
    kHiHatCymbal,
    kSnareDrum,
    kBassDrum,
    kFloorTom,
    kNoneInstrument,
}instrumentType;

@interface SRExternalViewController : UIViewController

- (id)initWithFrame:(CGRect)frame;

@end
