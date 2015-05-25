//
//  ViewController.h
//  BuddysIN
//
//  Created by Naveen on 24/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController<FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UILabel *termsLBL;
@property (weak, nonatomic) IBOutlet UIImageView *fbImageBG;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;

@property (weak, nonatomic) IBOutlet UILabel *fbLBL;

- (IBAction)termsButtonClicked:(UIButton *)sender;
@end

