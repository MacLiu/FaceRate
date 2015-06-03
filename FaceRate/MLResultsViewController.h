//
//  MLResultsViewController.h
//  FaceRate
//
//  Created by Mac Liu on 6/2/15.
//  Copyright (c) 2015 FaceRate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface MLResultsViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic, strong) UIImage *image;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *rateLabel;

@end
