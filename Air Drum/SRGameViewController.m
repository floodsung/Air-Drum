//
//  SRGameViewController.m
//  Air Drum
//
//  Created by Rotek on 5/24/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import "SRGameViewController.h"

@interface SRGameViewController ()

@end

@implementation SRGameViewController


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

- (void)startGame:(id)sender
{
    NSLog(@"start game");
    
}

- (void)stopGame:(id)sender
{
    NSLog(@"stop game");

}



@end
