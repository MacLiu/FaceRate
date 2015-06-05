//
//  MLInstructionViewController.m
//  FaceRate
//
//  Created by Mac Liu on 6/1/15.
//  Copyright (c) 2015 FaceRate. All rights reserved.
//

#import "MLInstructionViewController.h"
#import "MLCameraViewController.h"
#import "MLResultsViewController.h"

@interface MLInstructionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage *image;
@property (retain, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation MLInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.camera = [[UIImagePickerController alloc] init];
    self.camera.delegate = self;
    self.camera.allowsEditing = YES;
    self.camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:159/255.0 blue:226/255.0 alpha:1.0];
    [self.continueButton setTitleColor:[UIColor colorWithRed:46/255.0 green:159/255.0 blue:226/255.0 alpha:1.0] forState:UIControlStateNormal];
}

#pragma mark - UIImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"toResults" sender:self];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    [self presentViewController:self.camera animated:NO completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MLResultsViewController class]]) {
        MLResultsViewController *vc = segue.destinationViewController;
        vc.image = self.image;
    }
}

- (void)dealloc {
    [_continueButton release];
    [super dealloc];
}
@end
