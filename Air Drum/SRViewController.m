//
//  SRViewController.m
//  Air Drum
//
//  Created by Rotek on 5/22/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import "SRViewController.h"
#import "SRHitDetector.h"
#import "SROptionViewController.h"
#import "SRExternalViewController.h"
#import "SRGameViewController.h"



@interface SRViewController ()<UIScrollViewDelegate>

@property (nonatomic,readonly) SystemSoundID soundID1;  // floor tom
@property (nonatomic,readonly) SystemSoundID soundID2;  // snare drum
@property (nonatomic,readonly) SystemSoundID soundID3;  // cymbal
@property (nonatomic,readonly) SystemSoundID soundID4;  // hi hat cymbal
@property (nonatomic,readonly) SystemSoundID soundID5;  // bass drum
@property (nonatomic,readonly) SystemSoundID soundID6;  // left tom
@property (nonatomic,readonly) SystemSoundID soundID7;  // middle tom
@property (nonatomic,readonly) SystemSoundID soundID8;  // right tom
@property (nonatomic,strong) UIImageView *menuView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *instrumentView;
@property (nonatomic,strong) SROptionViewController *optionViewController;

@property (nonatomic,strong) SRExternalViewController *externalViewController;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) SRGameViewController *gameViewController;


@end

@implementation SRViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Register multi screen notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidChange:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidChange:) name:UIScreenDidDisconnectNotification object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self loadAudio];
    
    
    [self configurateView];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hitDetect:) name:HitDetectedNotification object:nil];
    
    [[SRHitDetector sharedInstance] startHitDetect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self screenDidChange:nil];
    

}


- (void)screenDidChange:(NSNotification *)notification
{
    // To display content on an external display, do the following:
    // 1. Use the screens class method of the UIScreen class to determine if an external display is available.
    NSArray	*screens = [UIScreen screens];
	
    NSUInteger screenCount = [screens count];
    
	if (screenCount > 1)
    {
        // 2. If an external screen is available, get the screen object and look at the values in its availableModes
        // property. This property contains the configurations supported by the screen.
        
        // Select first external screen
		self.externalScreen = [screens objectAtIndex:1]; //index 0 is your iPhone/iPad
		NSArray	*availableModes = [self.externalScreen availableModes];
        
        NSLog(@"external screen: %@,mode:%@",self.externalScreen,availableModes);
        // 3. Select the UIScreenMode object corresponding to the desired resolution and assign it to the currentMode
        // property of the screen object.
        
        // Select the highest resolution in this sample
        NSInteger selectedRow = [availableModes count] - 1;
        self.externalScreen.currentMode = [availableModes objectAtIndex:selectedRow];
        
        // Set a proper overscanCompensation mode
        self.externalScreen.overscanCompensation = UIScreenOverscanCompensationInsetApplicationFrame;
		
        if (self.externalWindow == nil) {
            // 4. Create a new window object (UIWindow) to display your content.
            UIWindow *extWindow = [[UIWindow alloc] initWithFrame:[self.externalScreen bounds]];
            self.externalWindow = extWindow;
        }
        
        // 5. Assign the screen object to the screen property of your new window.
        self.externalWindow.screen = self.externalScreen;
        
        
        // 6. Configure the window (by adding views or setting up your OpenGL ES rendering context).
        
        
        self.externalViewController = [[SRExternalViewController alloc] initWithFrame:self.externalScreen.bounds];
        
        
        // Set the target screen to the external screen

        self.externalWindow.rootViewController = self.externalViewController;
        
        // Configure user interface
        // In this sample, we use the same UI layout when an external display is connected or not.
        // In your real application, you probably want to provide distinct UI layouts for best user experience.
        
        // Add the GL view
        //[self.externalWindow addSubview:self.externalViewController.view];
        
        // 7. Show the window.
        self.externalWindow.hidden = NO;
        
	}
	else //handles disconnection of the external display
    {
        // Release external screen and window
		self.externalScreen = nil;
		self.externalWindow = nil;
        self.externalViewController = nil;

	}

}


- (void)loadAudio
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"floorTomSound"
                                                     ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID1);
    
    path = [[NSBundle mainBundle] pathForResource:@"snareDrumSound"
                                           ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID2);
    
    path = [[NSBundle mainBundle] pathForResource:@"cymbalSound"
                                           ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID3);
    
    path = [[NSBundle mainBundle] pathForResource:@"hiHatCymbalSound"
                                           ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID4);
    
    path = [[NSBundle mainBundle] pathForResource:@"bassDrumSound"
                                           ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID5);
    
    
    path = [[NSBundle mainBundle] pathForResource:@"leftTomSound"
                                           ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID6);
    
    path = [[NSBundle mainBundle] pathForResource:@"middleTomSound"
                                           ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID7);
    
    path = [[NSBundle mainBundle] pathForResource:@"rightTomSound"
                                           ofType:@"wav"];
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID8);
    
}

- (void)configurateView
{
    // UIView configuration
	
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    UIImage *menuImage = [[UIImage alloc] init];
    self.instrumentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightTom"]];
    
    if (screenBounds.size.height > 480) {
        // iPhone 5
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundiPhone5.png"]];
        
        self.instrumentView.frame = CGRectMake(0, screenBounds.size.height - 400.0f, 320.0f, 320.0f);
        [self.view addSubview:self.instrumentView];
        
        menuImage = [UIImage imageNamed:@"menuiPhone5"];
        
        } else {
        // iPhone 4/4s
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundiPhone4.png"]];
        
        self.instrumentView.frame = CGRectMake(0, screenBounds.size.height - 320.0f, 320.0f, 320.0f);
        [self.view addSubview:self.instrumentView];
        
        menuImage = [UIImage imageNamed:@"menuiPhone4"];
    }
    
    
    self.menuView = [[UIImageView alloc] initWithImage:menuImage];
    self.menuView.frame = CGRectMake(0.0f,0.0f, menuImage.size.width, menuImage.size.height);
    [self.view addSubview:self.menuView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2 - 180.0f);
    [self.scrollView addSubview:self.menuView];
    self.scrollView.contentOffset = CGPointMake(0.0f,screenBounds.size.height - 180.0f);
    self.scrollView.tag = 10;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // Add horizontal scroll view
    
    UIScrollView *horizontalScrollView = [[UIScrollView alloc] initWithFrame:self.menuView.frame];
    horizontalScrollView.contentSize = CGSizeMake(horizontalScrollView.frame.size.width * 4, horizontalScrollView.frame.size.height);
    horizontalScrollView.tag = 20;
    horizontalScrollView.showsHorizontalScrollIndicator = NO;
    horizontalScrollView.showsVerticalScrollIndicator = NO;
    horizontalScrollView.pagingEnabled = YES;
    horizontalScrollView.delegate = self;
    
    [self.scrollView addSubview:horizontalScrollView];
    
    // Add page indicator
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    [self.scrollView addSubview:self.pageControl];
    
    // Add Game View Controller
    self.gameViewController = [[SRGameViewController alloc] initWithNibName:@"SRGameViewController" bundle:nil];
    self.gameViewController.view.frame = CGRectMake(320.0f, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
    [horizontalScrollView addSubview:self.gameViewController.view];
    
    // Add Option View Controller
    self.optionViewController = [[SROptionViewController alloc] initWithNibName:@"SROptionViewController" bundle:nil];
    self.optionViewController.view.frame = self.menuView.frame;
    [horizontalScrollView addSubview:self.optionViewController.view];
    

    
    
}

#pragma mark - UI Scroll View Delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.tag == 10) {
        NSLog(@"velocity y:%f,offset y:%f",velocity.y,targetContentOffset->y);
        if (targetContentOffset->y != 0 && targetContentOffset->y != 300.0f) {
            if (velocity.y < 0) {
                [self swipeDownMenu];
            } else if (velocity.y > 0) {
                [self swipeUpMenu];
            } else if (targetContentOffset->y < 40){
                [self swipeDownMenu];
            } else {
                [self swipeUpMenu];
            }
        }
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 20) {
        float xOffset = scrollView.contentOffset.x;
        if (xOffset < 320.0f) {
            self.pageControl.currentPage = 0;
        } else if (xOffset < 320.0f *2){
            self.pageControl.currentPage = 1;
        } else if (xOffset < 320.0f *3){
            self.pageControl.currentPage = 2;
        } else if (xOffset < 320.0f *4){
            self.pageControl.currentPage = 3;
        }
    }
}


- (void)swipeDownMenu
{
    NSLog(@"swipe down");
    [self.scrollView scrollRectToVisible:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
    
}

- (void)swipeUpMenu
{
    NSLog(@"swipe up");
    [self.scrollView scrollRectToVisible:CGRectMake(0.0f, self.view.frame.size.height - 180.0f,  self.view.frame.size.width, self.view.frame.size.height) animated:YES];
}

#pragma mark - Notification


- (void)hitDetect:(NSNotification *)notification
{
    NSDictionary *message = (NSDictionary *)[notification object];
    float hitHorizontalDegree = [[message objectForKey:HIT_HORIZONTAL_DEGREE] floatValue];
    float hitVerticalDegree = [[message objectForKey:HIT_VERTICAL_DEGREE] floatValue];
    
    NSLog(@"horizontal degree:%f,vertical degree:%f",hitHorizontalDegree,hitVerticalDegree);
    if (hitVerticalDegree < 125) {
        if (hitHorizontalDegree >= 45 && hitHorizontalDegree < 90) {
            AudioServicesPlaySystemSound(self.soundID1);
            //[self.audioManager playFloorDrum];
            self.instrumentView.image = [UIImage imageNamed:@"FloorTom"];
        } else if (hitHorizontalDegree >= - 90 && hitHorizontalDegree < -45){
            AudioServicesPlaySystemSound(self.soundID4);
            //[self.audioManager playHiHatCymbal];
            self.instrumentView.image = [UIImage imageNamed:@"HiHatCymbal"];
        } else if (hitHorizontalDegree >= 0 && hitHorizontalDegree < 45 ){
            AudioServicesPlaySystemSound(self.soundID5);
            //[self.audioManager playBassDrum];
            self.instrumentView.image = [UIImage imageNamed:@"BassDrum"];
        } else if (hitHorizontalDegree >= -45 && hitHorizontalDegree < 0){
            AudioServicesPlaySystemSound(self.soundID2);
            //[self.audioManager playSnareDrum];
            self.instrumentView.image = [UIImage imageNamed:@"SnareDrum"];

        }
        
    } else if(hitVerticalDegree > 125 && hitVerticalDegree < 170){
        if (hitHorizontalDegree >= -90 && hitHorizontalDegree < -45) {
            AudioServicesPlaySystemSound(self.soundID3);
            //[self.audioManager playCymbal];
            self.instrumentView.image = [UIImage imageNamed:@"Cymbal"];

        } else if (hitHorizontalDegree >= -45 && hitHorizontalDegree < 0) {
            AudioServicesPlaySystemSound(self.soundID6);
            //[self.audioManager playLeftTom];
            self.instrumentView.image = [UIImage imageNamed:@"LeftTom"];

        } else if (hitHorizontalDegree >= 0 && hitHorizontalDegree < 45) {
            AudioServicesPlaySystemSound(self.soundID7);
            //[self.audioManager playMiddleTom];
            self.instrumentView.image = [UIImage imageNamed:@"MiddleTom"];

        } else if (hitHorizontalDegree >= 45 && hitHorizontalDegree < 90) {
            AudioServicesPlaySystemSound(self.soundID8);
            //[self.audioManager playRightTom];
            self.instrumentView.image = [UIImage imageNamed:@"RightTom"];
        }
    }
    
    
}


@end
