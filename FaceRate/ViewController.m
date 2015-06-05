//
//  ViewController.m
//  FaceRate
//
//  Created by Mac Liu on 6/1/15.
//  Copyright (c) 2015 FaceRate. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ocean.jpg"]];
    self.startButton.layer.borderWidth = 5.0f;
    self.startButton.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    self.startButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    self.titleLabel.textColor = [UIColor colorWithRed:46/255.0 green:159/255.0 blue:226/255.0 alpha:1.0];
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    [self.navigationController performSegueWithIdentifier:@"ToInstructions" sender:nil];
}

- (void)dealloc {
    [_titleLabel release];
    [super dealloc];
}
@end
