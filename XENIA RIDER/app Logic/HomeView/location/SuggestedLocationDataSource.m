//
//  SuggestedLocationDataSource.m
//  XENIA RIDER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "SuggestedLocationDataSource.h"
#import "SuggestedLocationCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import <CoreLocation/CoreLocation.h>
@implementation SuggestedLocationDataSource
{
    NSMutableArray *arraySuggestedLocation;
    BOOL isSearchComplete;
}

-(instancetype)initWithTableView:(UITableView *) tableView textFiled:(UITextField *) textField;
{
    self=[self init];
    self.tablview=tableView;
    [self.tablview setHidden:YES];
    self.textField=textField;
    self.tablview.delegate=self;
    self.tablview.dataSource=self;
    self.textField.delegate=self;
    isSearchComplete=NO;
    return  self;
}

#pragma  mark - UITableView Delgate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arraySuggestedLocation.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SuggestedLocationCell * cell=[tableView dequeueReusableCellWithIdentifier:@"SuggestedLocationCell"];
    NSString * locName=[[arraySuggestedLocation objectAtIndex:indexPath.row]  objectForKey:@"description"];
    [cell.lbLocation setText:locName];
    [cell.lbLocation setFont:FONTS_THEME_REGULAR(14)];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * locName=[[arraySuggestedLocation objectAtIndex:indexPath.row]  objectForKey:@"description"];
    return 20+[UtilityClass getLabelHeight:CGSizeMake(SCREEN_WIDTH-50, 200) forText:locName withFont:FONT_HELVETICANEUE(14)];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString  *stringDestinationAddress=[[arraySuggestedLocation  objectAtIndex:indexPath.row]  objectForKey:@"description"];
    
    

//    [self getLatlngForm:stringDestinationAddress];
    [self.textField setText:stringDestinationAddress];
    [self.textField resignFirstResponder];
    [self.tablview setHidden:YES];
    isSearchComplete=YES;
     if(self.delegate)
     {
         [self.delegate  onSelectLocation:[arraySuggestedLocation objectAtIndex:indexPath.row]];
     }
}



#pragma mark - UITextField Deldate Method
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    [self.tablview setHidden:YES];
    [self.delegate onAddressEndEditing];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     if(self.textField.text.length>0)
     {
    [self performSearch:self.textField.text]    ;
     }
     else{
         [self.tablview setHidden:YES];
     }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    isSearchComplete=NO;
    [self.delegate onAddressStartEditing];
    [self.tablview setHidden:NO];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    [self.tablview setHidden:YES];
    return  YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.tablview setHidden:YES];
}


-(void) performSearch:(NSString *) string
{
    if(string.length==0||isSearchComplete==YES)
    {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"key" : GOOGLE_API_KEY,
                                                                                  @"input" : string,
                                                                                   @"radius" :@"50000"
                                                                                  }];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://maps.googleapis.com/maps/api/place/autocomplete/json"
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if([[responseObject objectForKey:@"status"]  isEqualToString:@"OK"])
             {
                 
                 if(arraySuggestedLocation==nil)
                 {
                     arraySuggestedLocation=[[NSMutableArray alloc]  init];
                     
                 }
                 arraySuggestedLocation=[responseObject objectForKey:@"predictions"];
                 [self.tablview reloadData];
                 if(isSearchComplete==YES)
                 {
                 [self.tablview setHidden:YES];
                 }else{
                     [self.tablview setHidden:NO];
                 }
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *errorResponse) {
             
             NSLog(@"Error: %@", errorResponse);
             NSLog(@"[HTTPClient Error]: %@", [errorResponse localizedDescription]);
         }];
}



//-(void) getLatlngForm:(NSString *) address;
//{
//    
//    CLGeocoder *geocoder = [CLGeocoder new];
//    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        
//        if(placemarks.count>0)
//        {
//            CLPlacemark *placemark=[placemarks firstObject];
//            NSLog(@"Location  : %@",placemark.location);
//        }
//    }];
//}






@end
