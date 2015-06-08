//
//  HomeViewController.m
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "HomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MediaPlayer/MediaPlayer.h>

#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "ViewController.h"
#import "ConnectionHandler.h"
#import "BuddysINUtil.h"

#import "HomeCell.h"
#import "Share.h"

#import "AppDelegate.h"


@interface HomeViewController ()
{
    UCZProgressView *progressView;
}
@property (nonatomic, strong) NSMutableDictionary *videoDownloadsInProgress;
@end

@implementation HomeViewController
@synthesize buddysList;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isReloadBuddys = TRUE;
    
    buddysList = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUSER_NAME] ];
    
    //Get Location
    SharedAppDelegate.locationManager.delegate = self;
    [SharedAppDelegate.locationManager startUpdatingLocation];
    
    //    [self getNearByRecords];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Turn off the location manager to save power.
    [SharedAppDelegate.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManager delegate methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    NSString *locLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *locLong  = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults]setValue:locLat forKey:kUSER_LATITUTE];
    [[NSUserDefaults standardUserDefaults]setValue:locLong forKey:kUSER_LONGITUTE];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"locLat....%@,loclong....%@",locLat,locLong);
    
    if(isReloadBuddys)
    {
        [self getNearByRecords];
        isReloadBuddys = FALSE;
    }
    
    // Turn off the location manager to save power.
    [SharedAppDelegate.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
    [[[UIAlertView alloc]initWithTitle:@"Opps." message:@"Can not find location." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Accept", nil] show];
}

-(void)getNearByRecords
{
    [self startProgressLoader];
    NSString* latitute = [[NSUserDefaults standardUserDefaults]valueForKey:kUSER_LATITUTE];
    NSString* longitute = [[NSUserDefaults standardUserDefaults]valueForKey:kUSER_LONGITUTE];
    NSString *email = [[NSUserDefaults standardUserDefaults]valueForKey:kUSER_EMAIL];
    
    email = @"naveendungarwal2009@gmail.com";
    latitute = @"12.938653";
    longitute = @"77.571814";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:kAPIKeyValue forKey:kAPIKey];
    [dict setValue:kAPISecretValue forKey:kAPISecret];
    [dict setValue:email forKey:@"email"];
    [dict setValue:latitute forKey:@"lat"];
    [dict setValue:longitute forKey:@"lon"];
    [dict setValue:@"5000" forKey:@"radius"];
    [dict setValue:@"0" forKey:@"start"];
    [dict setValue:@"50" forKey:@"end"];
    
    NSLog(@"dict near by...%@",dict);
    ConnectionHandler *connHandler = [[ConnectionHandler alloc] init];
    if(![connHandler hasConnectivity]){
        [self stopProgressLoader];
    }
    connHandler.delegate = self;
    [connHandler makePOSTRequestPath:kNearByUserURL parameters:dict];
}

#pragma mark - Connection

-(void)connHandlerClient:(ConnectionHandler *)client didSucceedWithResponseString:(NSString *)response forPath:(NSString *)urlPath{
    [self stopProgressLoader];
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
    [self stopProgressLoader];
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
    
    //Progress Indicator
    for(UIView *view in cell.subviews)
    {
        if([view isKindOfClass:[UCZProgressView class]])
        {
            UCZProgressView *cellProgressView = (UCZProgressView*)view;
            if(cellProgressView.tag == indexPath.row)
                cellProgressView.hidden = NO;
            else
                cellProgressView.hidden = YES;
        }
    }
    
    cell.buddyAuthName.text = [NSString stringWithFormat:@"@%@",shareObj.memberDetail.name];
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

//cell selection handler
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Share *share = [buddysList objectAtIndex:indexPath.row];
    NSLog(@"dataType...%@",share.dataType);
    if([share.dataType integerValue] == 1)
    {
        
    }
    else if ([share.dataType integerValue] == 2){
        
        AFHTTPRequestOperation *operation = (self.videoDownloadsInProgress)[indexPath];
        
        if([BuddysINUtil fileExist:share.videoName] && !operation)
        {
            [self playMovie:[BuddysINUtil localFileUrl:share.videoName]];
        }
        else
        {
            //        [self setBlurView:cell.blurView flag:YES];
            if([BuddysINUtil reachable])
            {
                NSString *localURL = [BuddysINUtil localFileUrl:share.videoName];
                if(!operation){
                    
                    UCZProgressView *cellProgressView;
                    cellProgressView = [[UCZProgressView alloc]initWithFrame:CGRectMake(0,0,320,210)];
                    cellProgressView.tag = indexPath.row;
                    cellProgressView.indeterminate = YES;
                    cellProgressView.showsText = YES;
                    cellProgressView.tintColor = [UIColor whiteColor];
                    
                    [cell addSubview:cellProgressView];
                    
                    
                    NSString *urlString = share.videoURL;
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request ];
                    
                    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:localURL append:YES];
                    
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"Successfully downloaded file to %@", localURL);
                        [cellProgressView removeFromSuperview];
                        //                [self setBlurView:cell.blurView flag:NO];
                        [self.videoDownloadsInProgress removeObjectForKey:indexPath];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        //                cell.downloadIcon.hidden = NO;
                        //                cell.playIcon.hidden = YES;
                    }];
                    
                    [operation setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
                        
                        // Draw the actual chart.
                        //            dispatch_async(dispatch_get_main_queue()
                        //                           , ^(void) {
                        cellProgressView.progress = (float)totalBytesRead / totalBytesExpectedToRead;
                        //                               [cell layoutSubviews];
                        //                           });
                        
                    }];
                    
                    (self.videoDownloadsInProgress)[indexPath] = operation;
                    [operation start];
                }
            }
            else{
                NSLog(@"No internet connectivity");
            }
        }
    }
}


-(void)playMovie: (NSString *) path{
    
    NSURL *url = [NSURL fileURLWithPath:path];
    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    theMovie.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    [self presentMoviePlayerViewControllerAnimated:theMovie];
    theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [theMovie.moviePlayer play];
}

- (void)movieFinishedCallBack:(NSNotification *) aNotification {
    MPMoviePlayerController *mPlayer = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:mPlayer];
    [mPlayer stop];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addVideoButtonAction:(id)sender {
    [buddysList removeAllObjects];
    [self.buddysTableView reloadData];
    isReloadBuddys = TRUE;
    [SharedAppDelegate.locationManager startUpdatingLocation];
}

- (IBAction)logOutButtonAction:(UIButton *)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    FBSession.activeSession = nil;
    
    [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:kUSER_LOGGED_IN];
    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:loginView animated:YES];
    
}


-(void)startProgressLoader
{
    if(!progressView){
        progressView = [[UCZProgressView alloc]initWithFrame:self.view.frame];
        progressView.indeterminate = YES;
        progressView.showsText = NO;
        progressView.backgroundColor = [UIColor clearColor];
        progressView.opaque = 0.5;
        progressView.alpha = 0.5;
        [self.view addSubview:progressView];
    }
}

-(void)stopProgressLoader
{
    [progressView removeFromSuperview];
    progressView = nil;
    
}
@end
