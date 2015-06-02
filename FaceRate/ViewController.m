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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:52/255.0 green:192/255.0 blue:205/255.0 alpha:1.0];
    self.startButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:58/255.0 blue:148/255.0 alpha:1.0];
    self.startButton.titleLabel.textColor = [UIColor colorWithRed:52/255.0 green:192/255.0 blue:205/255.0 alpha:1.0];

}

- (IBAction)startButtonPressed:(UIButton *)sender {
    [self.navigationController performSegueWithIdentifier:@"ToInstructions" sender:nil];
}

@end
