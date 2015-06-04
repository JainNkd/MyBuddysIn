//
//  HomeCell.h
//  BuddysIN
//
//  Created by Naveen on 04/06/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;

@property (weak, nonatomic) IBOutlet UILabel *buddysTitleLbl;

@property (weak, nonatomic) IBOutlet UILabel *buddyAuthName;

@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@end
