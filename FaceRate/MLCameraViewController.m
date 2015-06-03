//
//  MLCameraViewController.m
//  FaceRate
//
//  Created by Mac Liu on 6/1/15.
//  Copyright (c) 2015 FaceRate. All rights reserved.
//

#import "MLCameraViewController.h"
#import "MLResultsViewController.h"

@interface MLCameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MLCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.camera = [[UIImagePickerController alloc] init];
    self.camera.delegate = self;
    self.camera.allowsEditing = YES;
    self.camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.camera animated:NO completion:nil];
}

#pragma mark - UIImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    MLResultsViewController *vc = [[MLResultsViewController alloc] init];
    vc.image
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}



@end
