//
//  HomeViewController.h
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionHandler.h"

@interface HomeViewController : UIViewController<ConnectionHandlerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *addVideoBtn;


- (IBAction)addVideoButtonAction:(id)sender;

- (IBAction)logOutButtonAction:(UIButton *)sender;

@end
