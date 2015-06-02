//
//  FRInstructionViewController.m
//  FaceRate
//
//  Created by Mac Liu on 6/1/15.
//  Copyright (c) 2015 FaceRate. All rights reserved.
//

#import "FRInstructionViewController.h"

@interface FRInstructionViewController ()

@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation FRInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // create camera with standard settings
    self.camera = [[LLSimpleCamera alloc] init];
    
    // camera with video recording capability
    self.camera =  [[LLSimpleCamera alloc] initWithVideoEnabled:YES];
    
    // camera with precise quality, position and video parameters.
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:CameraPositionBack
                                             videoEnabled:NO];}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // attach to the view
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
}

@end
