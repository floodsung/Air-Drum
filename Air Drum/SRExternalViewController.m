//
//  SRExternalViewController.m
//  Air Drum
//
//  Created by Rotek on 5/24/13.
//  Copyright (c) 2013 Rotek. All rights reserved.
//

#import "SRExternalViewController.h"
#import "SRHitDetector.h"
#define xOffset  40.0f
#define yOffset  40.0f

@interface SRExternalViewController (){
    instrumentType _preInstrument;
    instrumentType _currentInstrument;
}

@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UIImageView *hiHatCymbalView;
@property (nonatomic,strong) UIImageView *snareDrumView;
@property (nonatomic,strong) UIImageView *bassDrumView;
@property (nonatomic,strong) UIImageView *floorTomView;
@property (nonatomic,strong) UIImageView *cymbalView;
@property (nonatomic,strong) UIImageView *leftTomView;
@property (nonatomic,strong) UIImageView *middleTomView;
@property (nonatomic,strong) UIImageView *rightTomView;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation SRExternalViewController


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        self.view.frame = frame;
        NSLog(@"width:%f,height:%f",self.view.frame.size.width,self.view.frame.size.height);
        _preInstrument = kNoneInstrument;
        _currentInstrument = kNoneInstrument;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Set Background
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.frame = self.view.frame;
    
    [self.view addSubview:self.backgroundView];
    
    // Add image
    float imageWidth = (self.view.frame.size.width - xOffset * 2) / 4.0f;
    float imageHeight = (self.view.frame.size.height - yOffset * 2) / 2.0f;
    
    self.cymbalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cymbal@2x"]];
    self.cymbalView.contentMode = UIViewContentModeScaleAspectFit;
    self.cymbalView.frame = CGRectMake(xOffset, yOffset, imageWidth, imageHeight);
    self.cymbalView.alpha = 0.5f;

    [self.view addSubview:self.cymbalView];
    
    self.leftTomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftTom@2x"]];
    self.leftTomView.contentMode = UIViewContentModeScaleAspectFit;

    self.leftTomView.frame = CGRectMake(xOffset + imageWidth, yOffset, imageWidth, imageHeight);
    self.leftTomView.alpha = 0.5f;
    [self.view addSubview:self.leftTomView];
    
    self.middleTomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MiddleTom@2x"]];
    self.middleTomView.contentMode = UIViewContentModeScaleAspectFit;
    self.middleTomView.alpha = 0.5f;

    self.middleTomView.frame = CGRectMake(xOffset + imageWidth * 2, yOffset, imageWidth, imageHeight);
    [self.view addSubview:self.middleTomView];
    
    self.rightTomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightTom@2x"]];
    self.rightTomView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightTomView.alpha = 0.5f;
    self.rightTomView.frame = CGRectMake(xOffset + imageWidth * 3, yOffset, imageWidth, imageHeight);
    [self.view addSubview:self.rightTomView];
    
    self.hiHatCymbalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HiHatCymbal@2x"]];
    self.hiHatCymbalView.contentMode = UIViewContentModeScaleAspectFit;
    self.hiHatCymbalView.alpha = 0.5f;
    self.hiHatCymbalView.frame = CGRectMake(xOffset, yOffset + imageHeight, imageWidth, imageHeight);
    [self.view addSubview:self.hiHatCymbalView];
    
    self.snareDrumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SnareDrum@2x"]];
    self.snareDrumView.contentMode = UIViewContentModeScaleAspectFit;
    self.snareDrumView.alpha = 0.5f;
    self.snareDrumView.frame = CGRectMake(xOffset + imageWidth, yOffset + imageHeight, imageWidth, imageHeight);
    [self.view addSubview:self.snareDrumView];
    
    self.bassDrumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BassDrum@2x"]];
    self.bassDrumView.contentMode = UIViewContentModeScaleAspectFit;
    self.bassDrumView.alpha = 0.5f;
    self.bassDrumView.frame = CGRectMake(xOffset + imageWidth * 2, yOffset + imageHeight, imageWidth, imageHeight);
    [self.view addSubview:self.bassDrumView];
    
    self.floorTomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FloorTom@2x"]];
    self.floorTomView.contentMode = UIViewContentModeScaleAspectFit;
    self.floorTomView.frame = CGRectMake(xOffset + imageWidth * 3, yOffset + imageHeight, imageWidth, imageHeight);
    self.floorTomView.alpha = 0.5f;
    [self.view addSubview:self.floorTomView];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showInstrument) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInstrument
{
    NSLog(@"show instrument");
    float horizontalDegree = [[SRHitDetector sharedInstance] horizontalDegree];
    float verticalDegree = [[SRHitDetector sharedInstance] verticalDegree];
    
    
    _preInstrument = _currentInstrument;
    
    if (verticalDegree < 125) {
        if (horizontalDegree >= 45 && horizontalDegree < 90) {
            _currentInstrument = kFloorTom;
        } else if (horizontalDegree >= - 90 && horizontalDegree < -45){
            _currentInstrument = kHiHatCymbal;
        } else if (horizontalDegree >= 0 && horizontalDegree < 45 ){
            _currentInstrument = kBassDrum;
        } else if (horizontalDegree >= -45 && horizontalDegree < 0){
            _currentInstrument = kSnareDrum;
            
        } else _currentInstrument = kNoneInstrument;
        
    } else if(verticalDegree > 125 && verticalDegree < 170){
        if (horizontalDegree >= -90 && horizontalDegree < -45) {
            _currentInstrument = kCymbal;
            
        } else if (horizontalDegree >= -45 && horizontalDegree < 0) {
            _currentInstrument = kLeftTom;
            
        } else if (horizontalDegree >= 0 && horizontalDegree < 45) {
            _currentInstrument = kMiddleTom;
            
        } else if (horizontalDegree >= 45 && horizontalDegree < 90) {
            _currentInstrument = kRightTom;
        } else _currentInstrument = kNoneInstrument;
    }
    
    if (_preInstrument != _currentInstrument) {
        switch (_preInstrument) {
            case kCymbal:
                self.cymbalView.alpha = 0.5f;
                break;
            
            case kLeftTom:
                self.leftTomView.alpha = 0.5f;
                break;
        
            case kMiddleTom:
                self.middleTomView.alpha = 0.5f;
                break;
                
            case kRightTom:
                self.rightTomView.alpha = 0.5f;
                break;
                
            case kHiHatCymbal:
                self.hiHatCymbalView.alpha = 0.5f;
                break;
                
            case kSnareDrum:
                self.snareDrumView.alpha = 0.5f;
                break;
                
            case kBassDrum:
                self.bassDrumView.alpha = 0.5f;
                break;
                
            case kFloorTom:
                self.floorTomView.alpha = 0.5f;
                break;
                
            default:
                break;
        }
        
        switch (_currentInstrument) {
            case kCymbal:
                self.cymbalView.alpha = 1.0f;
                break;
                
            case kLeftTom:
                self.leftTomView.alpha = 1.0f;
                break;
                
            case kMiddleTom:
                self.middleTomView.alpha = 1.0f;
                break;
                
            case kRightTom:
                self.rightTomView.alpha = 1.0f;
                break;
                
            case kHiHatCymbal:
                self.hiHatCymbalView.alpha = 1.0f;
                break;
                
            case kSnareDrum:
                self.snareDrumView.alpha = 1.0f;
                break;
                
            case kBassDrum:
                self.bassDrumView.alpha = 1.0f;
                break;
                
            case kFloorTom:
                self.floorTomView.alpha = 1.0f;
                break;
            default:
                break;
        }
    }

}

@end
