//
//  HomeViewController.m
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "HomeViewController.h"
#import "Constant.h"
#import "ViewController.h"
#import "ConnectionHandler.h"
#import "BuddysINUtil.h"
#import <FacebookSDK/FacebookSDK.h>
#import "HomeCell.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUSER_NAME];
    
    
    [self getNearByRecords];
    // Do any additional setup after loading the view.
}

-(void)getNearByRecords
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:kAPIKeyValue forKey:kAPIKey];
    [dict setValue:kAPISecretValue forKey:kAPISecret];
    [dict setValue:@"sekar@aumkii.com" forKey:@"email"];
    [dict setValue:@"8.1" forKey:@"lat"];
    [dict setValue:@"77.2" forKey:@"lon"];
    [dict setValue:@"50" forKey:@"radius"];
    [dict setValue:@"0" forKey:@"start"];
    [dict setValue:@"10" forKey:@"end"];
    
    
    ConnectionHandler *connHandler = [[ConnectionHandler alloc] init];
    connHandler.delegate = self;
    [connHandler makePOSTRequestPath:kNearByUserURL parameters:dict];
}

#pragma mark - Connection

-(void)connHandlerClient:(ConnectionHandler *)client didSucceedWithResponseString:(NSString *)response forPath:(NSString *)urlPath{
        NSLog(@"connHandlerClient didSucceedWithResponseString : %@",response);
    NSLog(@"loadAppContactsOnTable ******************");
    if ([urlPath isEqualToString:kNearByUserURL]) {
        NSLog(@"SUCCESS: All Data fetched");
        
        NSError *error;
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options: NSJSONReadingMutableContainers
                                                                       error: &error];
        NSDictionary *nearByBuddysDict = [responseDict objectForKey:@"share"];
        NSInteger status = [[nearByBuddysDict objectForKey:@"status"] integerValue];
        NSArray *dataList = [nearByBuddysDict objectForKey:@"data"];
        
        switch (status) {
            case 1:
            {
                for(NSDictionary* datadict in dataList)
                {
//                    NSDictionary *videoDict = [datadict objectForKey:@"Video"];
//                    VideoDetail *videoDetailObj = [[VideoDetail alloc]initWithDict:videoDict];
//                    
//                    if(![DatabaseMethods checkIfHistoryVideoExists:[videoDetailObj.videoID integerValue]])
//                    {
//                        [DatabaseMethods insertHistoryVideoInfoInDB:videoDetailObj];
//                    }
                }
                
//                [self reloadHistoryData];
                break;
            }
            case -2:
                [BuddysINUtil showAlertWithTitle:@"" message:[nearByBuddysDict objectForKey:@"message"]];
                break;
            default:
                [BuddysINUtil showAlertWithTitle:@"Error" message:[error localizedDescription]];
                break;
        }
    }
}


-(void)connHandlerClient:(ConnectionHandler *)client didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@",[error localizedDescription]);
    [BuddysINUtil showAlertWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"Accept" otherBtnTitle:nil delegate:nil tag:0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*CellIdentifier = @"Cell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addVideoButtonAction:(id)sender {
}

- (IBAction)logOutButtonAction:(UIButton *)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    FBSession.activeSession = nil;
    
    [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:kUSER_LOGGED_IN];
    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:loginView animated:YES];
    
}
@end
