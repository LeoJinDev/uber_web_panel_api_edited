//
//  TripHistoryViewController.m
//  TaxiDriver
//
//  Created by SFYT on 24/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "TripHistoryViewController.h"
#import "AppDelegate.h"
#import "WebCallConstants.h"
//#import "CallAPI.h"
#import <GrepixKit/GrepixKit.h>
#import "tripHistoryCell.h"
#import "TripDetailsViewController.h"
////#import "nsuserdefaults-helper.h"
#import "ConstantModel.h"



@interface TripHistoryViewController ()
{
    NSMutableArray *tripArray;
    BOOL isStopTripCall;
    ConstantModel  *constantModel;

}

@end

@implementation TripHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setThemeConstants];
    NSArray * arr = defaults_object(@"constantResponse");
    constantModel =[[ConstantModel alloc]initItemWithDict:arr];
    
    tripArray =[[NSMutableArray alloc]init];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"tripHistoryCell" bundle:nil]
             forCellReuseIdentifier:@"tripHistoryCell"];
    [self gettripHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_lblNoRec setFont:FONTS_THEME_REGULAR(18)];
    
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"TripDetailsViewController"]) {
        
        TripDetailsViewController *details =(TripDetailsViewController *)[segue destinationViewController];
        
        details.trip = [tripArray objectAtIndex:[sender floatValue]];
        details.constantModel =constantModel;
    }
}

- (IBAction)ButtonBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gettripHistory{
    
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                @"user_id"          :[dict1 objectForKey:@"user_id"],
                                                                                @"limit"            :@(SIZE),
                                                                                @"offset"           :[NSString stringWithFormat:@"%lu", (unsigned long)tripArray.count],
                                                                                @"is_request"   : @0
                                                                                
                                                                                }];
    
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:@"Loading..."];
    
    [APP_CallAPI gcURL:BASE_URL app:TRIP_GETTRIP
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        
                        if ([[results objectForKey:P_RESPONSE] isKindOfClass:[NSArray class]]) {
                            
                            
                            NSArray *arrtrip = [results objectForKey:P_RESPONSE];
                            
                            
                            isStopTripCall = arrtrip.count < SIZE ? YES : NO;
                            
                            
                            for (int i=0; i<arrtrip.count; i++) {
                                
                                TripModel *Trip = [[TripModel alloc] initItemWithDict:[arrtrip objectAtIndex:i]];
                                
                                if ([Trip.trip_Status isEqualToString:TS_BEGIN] || [Trip.trip_Status isEqualToString:TS_ARRIVE] || [Trip.trip_Status isEqualToString:TS_ACCEPTED]) {
                                    
                                }
                                else{
                                    
                                    [tripArray addObject:Trip];
                                }
                            }
                        }
                        
                        if (tripArray.count ==0 ) {
                            _lblNoRec.hidden =NO;
                        }
                        else{
                            _lblNoRec.hidden =YES;
                        }
                        [_tableView reloadData];
                    }
                    [UtilityClass SetLoaderHidden:YES withTitle:@"Loading..."];
                }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        
        return tripArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"tripHistoryCell";
    
        
        tripHistoryCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[tripHistoryCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        }
    
        cell.constantModel =constantModel;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    
    
    [cell setdataWithTripModel:[tripArray objectAtIndex:indexPath.row]];
    
    if (indexPath.row >tripArray.count-2 && !isStopTripCall) {
        
        [self gettripHistory];
    }
        return cell;
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 119;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"TripDetailsViewController" sender:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
}


@end
