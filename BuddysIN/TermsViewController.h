//
//  TermsViewController.h
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backButtonClicked:(UIButton *)sender;
@end
