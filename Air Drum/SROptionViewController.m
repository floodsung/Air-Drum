//
//  SROptionViewController.m
//  Air Drum
//
//  Created by Rotek on 5/23/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import "SROptionViewController.h"
#import "SRHitDetector.h"
#import <QuartzCore/QuartzCore.h>
@interface SROptionViewController ()

@end

@implementation SROptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.reCalibrateButton = [[UIButton alloc] initWithFrame:CGRectMake(103, 238, 114, 34)];
        [self.view addSubview:self.reCalibrateButton];
        [self.reCalibrateButton addTarget:self action:@selector(resetMotionDetect:) forControlEvents:UIControlEventTouchUpInside];
        [self.reCalibrateButton setImage:[UIImage imageNamed:@"reCalibrateButton"] forState:UIControlStateNormal];
        [self.reCalibrateButton setImage:[UIImage imageNamed:@"reCalibrateButtonDown"] forState:UIControlStateHighlighted];
        
        self.defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(216, 94, 84, 34)];
        [self.view addSubview:self.defaultButton];
        [self.defaultButton addTarget:self action:@selector(setSensitivityToDefault:) forControlEvents:UIControlEventTouchUpInside];
        [self.defaultButton setImage:[UIImage imageNamed:@"defaultButton"] forState:UIControlStateNormal];
        [self.defaultButton setImage:[UIImage imageNamed:@"defaultButtonDown"] forState:UIControlStateHighlighted];
        
        [self shadowConfigurationWithLabel:self.sensitivityLabel];
        [self shadowConfigurationWithLabel:self.screenAutoLockLabel];
        
        [self.screenAutoLockSwitch setOnTintColor:[UIColor colorWithRed:249.0/255.0 green:191.0/255.0 blue:44.0/255.0 alpha:1]];
        
        // Customize UISider
        UIImage *minImage = [[UIImage imageNamed:@"slider_minimum"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        
        [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)shadowConfigurationWithLabel:(UILabel *)label
{
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 2);
    label.layer.shadowRadius = 3.0f;
    label.layer.shadowOpacity = 1.0f;
    label.layer.masksToBounds = NO;
}

- (IBAction)screenLock:(UISwitch *)sender
{
    NSLog(@"screen lock");
    if (sender.isOn) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    } else {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}
- (void)resetMotionDetect:(id)sender {
    [[SRHitDetector sharedInstance] reset];
}
- (IBAction)changeSensitivity:(UISlider *)sender {
    [[SRHitDetector sharedInstance] changeDetectSensitivity:sender.value];
}
- (void)setSensitivityToDefault:(id)sender {
    [[SRHitDetector sharedInstance] changeDetectSensitivity:5.0f];
    self.sensitivitySilder.value = 5.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
