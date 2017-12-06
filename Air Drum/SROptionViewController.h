//  Air Drum
//
//  Created by Rotek on 5/23/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SROptionViewController : UIViewController
@property (nonatomic,weak) IBOutlet UILabel *screenAutoLockLabel;
@property (weak, nonatomic) IBOutlet UILabel *sensitivityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *screenAutoLockSwitch;

@property (weak, nonatomic) IBOutlet UISlider *sensitivitySilder;
@property (nonatomic,strong) UIButton *reCalibrateButton;
@property (nonatomic,strong) UIButton *defaultButton;
- (IBAction)screenLock:(id)sender;

@end
