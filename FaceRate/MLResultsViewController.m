//
//  MLResultsViewController.m
//  FaceRate
//
//  Created by Mac Liu on 6/2/15.
//  Copyright (c) 2015 FaceRate. All rights reserved.
//

#import "MLResultsViewController.h"
#import "FaceppAPI.h"
#import "ViewController.h"

@interface MLResultsViewController ()

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MLResultsViewController

static double GOLDEN_RATIO = 1.62;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.imageView.image = self.image;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self GetFeatures:self.image];
}

#pragma mark - Helper Methods

- (void) GetFeatures:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 100);
    FaceppResult *detect = [[FaceppAPI detection] detectWithURL:nil
                                                    orImageData:imageData];
    if ([[detect content][@"face"] count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please make sure your entire face is in the picture" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else {
        NSString *faceId = [detect content][@"face"][0][@"face_id"];
        FaceppResult *result = [[FaceppAPI detection] landmarkWithFaceId:faceId andType:nil];
        
        NSString *sex = [detect content][@"face"][0][@"attribute"][@"gender"][@"value"];
        NSString *race = [detect content][@"face"][0][@"attribute"][@"race"][@"value"];
        double noseTip = [[result content][@"result"][0][@"landmark"][@"nose_tip"][@"y"] doubleValue];
        double chin = [[result content][@"result"][0][@"landmark"][@"contour_chin"][@"y"] doubleValue];
        double midLips = [[result content][@"result"][0][@"landmark"][@"mouth_lower_lip_top"][@"y"]doubleValue];
        double pupils = ([[result content][@"result"][0][@"landmark"][@"left_eye_pupil"][@"y"]doubleValue] + [[result content][@"result"][0][@"landmark"][@"right_eye_pupil"][@"y"]doubleValue]) / 2;
        double noseWidth = ([[result content][@"result"][0][@"landmark"][@"nose_right"][@"x"]doubleValue] - [[result content][@"result"][0][@"landmark"][@"nose_left"][@"x"]doubleValue]);
        double bottomLipHeight = ([[result content][@"result"][0][@"landmark"][@"mouth_lower_lip_bottom"][@"y"]doubleValue] - [[result content][@"result"][0][@"landmark"][@"mouth_lower_lip_top"][@"y"]doubleValue]);
        double topLipHeight = ([[result content][@"result"][0][@"landmark"][@"mouth_upper_lip_bottom"][@"y"]doubleValue] - [[result content][@"result"][0][@"landmark"][@"mouth_upper_lip_top"][@"y"]doubleValue]);
        double heightLips = topLipHeight + bottomLipHeight;
        
        double noseTipToChin = chin - noseTip;
        double lipsToChin = chin - midLips;
        double pupilToNose = noseTip - pupils;
        double noseTipToLips = [[result content][@"result"][0][@"landmark"][@"mouth_upper_lip_bottom"][@"y"]doubleValue] - noseTip;
        
        int scale = [self ratioAverageIntoScale:(noseTipToChin / lipsToChin) :(noseTipToChin / pupilToNose) :(noseWidth / noseTipToLips) :(heightLips / noseWidth)];
        self.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@", race, sex];
        self.rateLabel.text = [NSString stringWithFormat:@"%i", scale];
        NSLog(@"%@",[NSString stringWithFormat:@"Gender: %@", sex]);
        NSLog(@"%@",[NSString stringWithFormat:@"Race: %@", race]);
        NSLog(@"%@", [NSString stringWithFormat:@"Your Score: %i", scale]);
    }
}

- (int) ratioAverageIntoScale:(double)calc1 :(double)calc2 :(double)calc3 :(double)calc4 {
    double averagePercentErrors = ([self percentError:calc1] +[self percentError:calc2] + [self percentError:calc3] + [self percentError:calc4]) / 4;
    int rank = round(averagePercentErrors * 10);
    return rank;
}

-(double) percentError:(double)calc {
    double numerator = fabs(calc - GOLDEN_RATIO);
    return 1 - (numerator / GOLDEN_RATIO);
}

- (void)dealloc {
    [_imageView release];
    [_descriptionLabel release];
    [_rateLabel release];
    [_activityIndicator release];
    [super dealloc];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
}

#pragma mark iAd delegate Methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error { [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
    
}
@end
