//
//  LeftViewController.h
//  TempProject
//
//  Created by SFYT on 09/02/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LGSideMenuController.h"
#import "MainViewController.h"


@interface LeftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LGSideMenuDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrSideMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;

@property (strong, nonatomic) IBOutlet UISwitch *switchAvailability;
@property (strong, nonatomic) IBOutlet UIButton *btnAvailability;

@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *viewSeparator;


@end
