//
//  SuggestedLocationDataSource.h
//  XENIA RIDER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class  SuggestedLocationDataSource;
@protocol SuggestedLocationDataSourceDelegate <NSObject>

-(void) onSelectLocation:(NSDictionary * )dictLocation;
-(void) onAddressStartEditing;
-(void) onAddressEndEditing;


@end

@interface SuggestedLocationDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property(strong ,nonatomic)UITableView * tablview;
@property(strong ,nonatomic) UITextField *textField;
@property(strong ,nonatomic)id<SuggestedLocationDataSourceDelegate> delegate;
-(instancetype)initWithTableView:(UITableView *) tableView textFiled:(UITextField *) textField;


@end
