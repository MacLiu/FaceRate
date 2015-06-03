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
#import <Social/Social.h>

@interface MLResultsViewController ()

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MLResultsViewController

static double GOLDEN_RATIO = 1.62;
SLComposeViewController *mySLComposerSheet;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.imageView.image = self.image;
    [self.activityIndicator startAnimating];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"There was an error!!!" message:@"Please make sure you followed the instructions" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [self performSegueWithIdentifier:@"ToMain" sender:nil];
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
        
        [self.activityIndicator stopAnimating];
        self.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@", race, sex];
        self.rateLabel.text = [NSString stringWithFormat:@"%i", scale];
      
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
    [self performSegueWithIdentifier:@"ToMain" sender:nil];
}

- (IBAction)shareFBPressed:(UIButton *)sender {
    [self ShareFacebook];
}

- (IBAction)shareTwitterPressed:(UIButton *)sender {
    [self ShareTwitter];
}

- (void)ShareFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet addImage:self.image];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"FaceRate said I was a/an %@, and rated me a %@ on a scale of 1 to 10!", self.descriptionLabel.text, self.rateLabel.text]];
        [mySLComposerSheet setEditing:NO];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Successfully Posted!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                break;
        }
            default:
                break;
        }
    }];
}

- (void) ShareTwitter {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet addImage:self.image];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"FaceRate said I was a/an %@, and rated me a %@ on a scale of 1 to 10!", self.descriptionLabel.text, self.rateLabel.text]];
        [mySLComposerSheet setEditing:NO];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Successfully Posted!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
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
