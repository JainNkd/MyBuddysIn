//
//  HomeViewController.m
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "ViewController.h"
#import "ConnectionHandler.h"
#import "BuddysINUtil.h"
#import <FacebookSDK/FacebookSDK.h>
#import "HomeCell.h"
#import "Share.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize buddysList;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    buddysList = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUSER_NAME] ];
    
    
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
                [self.buddysList removeAllObjects];
                for(NSDictionary* dataDict in dataList)
                {
                    
                    Share *shareObj = [[Share alloc]initWithDict:dataDict];
                    [self.buddysList addObject:shareObj];
                    
                    //                    if(![DatabaseMethods checkIfHistoryVideoExists:[videoDetailObj.videoID integerValue]])
                    //                    {
                    //                        [DatabaseMethods insertHistoryVideoInfoInDB:videoDetailObj];
                    //                    }
                }
                
                [self reloadHistoryData];
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

-(void)reloadHistoryData
{
    //    [buddysList removeAllObjects];
    //    videoDetailsArr = [DatabaseMethods getAllHistoryVideos];
    [self.buddysTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [buddysList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*CellIdentifier = @"Cell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Share *shareObj = [buddysList objectAtIndex:indexPath.row];
    
    cell.buddyAuthName.text = shareObj.memberDetail.name;
    cell.buddysTitleLbl.text = shareObj.content;
    if(shareObj.distance.length>3)
        cell.distanceLbl.text = [shareObj.distance substringToIndex:4];
    else
        cell.distanceLbl.text = [NSString stringWithFormat:@"%0.1f",[shareObj.distance floatValue]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    __block NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath,*fileURL;
    
    if([shareObj.dataType integerValue] == 1){
        fileURL = shareObj.imageURL;
        filePath = [documentsDirectory stringByAppendingPathComponent:shareObj.imageName];}
    else if([shareObj.dataType integerValue] == 2){
        fileURL = shareObj.videoThumbnailURL;
        filePath = [documentsDirectory stringByAppendingPathComponent:shareObj.videoThumbnailName];
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:imageData];
        if(image)
            [cell.thumbnailImage setImage:image];
        else
            [cell.thumbnailImage setImage:[UIImage imageNamed:kDefaultImage]];
    }
    else if(fileURL.length>0)
    {
        ConnectionHandler *conection = [[ConnectionHandler alloc]init];
        if (![conection hasConnectivity]) {
            [cell.thumbnailImage setImage:[UIImage imageNamed:kDefaultImage]];
        }
        else
        {
            
            [cell.thumbnailImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileURL]] placeholderImage:[UIImage imageNamed:kDefaultImage]
                                                success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
                                                    NSLog(@"Loaded successfully.....%@",[request.URL absoluteString]);// %ld", (long)[response statusCode]);
                                                    
                                                    NSArray *ary = [[request.URL absoluteString] componentsSeparatedByString:@"/"];
                                                    NSString *filename = [ary lastObject];
                                                    
                                                    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
                                                    //Add the file name
                                                    NSData *pngData = UIImagePNGRepresentation(image);
                                                    [pngData writeToFile:filePath atomically:YES];
                                                    [self.buddysTableView reloadData];
                                                }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                    NSLog(@"failed loading");//'%@", error);
                                                    [self.buddysTableView reloadData];
                                                }
             ];
        }
    }else
    {
        [cell.thumbnailImage setImage:[UIImage imageNamed:kDefaultImage]];
    }
    
    
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
