//
//  SRGameViewController.h
//  Air Drum
//
//  Created by Rotek on 5/24/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)startGame:(id)sender;
- (IBAction)stopGame:(id)sender;
@end
