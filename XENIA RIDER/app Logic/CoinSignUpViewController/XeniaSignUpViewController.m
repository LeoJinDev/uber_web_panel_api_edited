//
//  XeniaSignUpViewController.m
//  XENIA RIDER
//
//  Created by Clean on 2/20/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import "XeniaSignUpViewController.h"

@interface XeniaSignUpViewController ()

@end

@implementation XeniaSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ButtonBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)ButtonSignUpXeniaCoin:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ico.xeniacoin.org/Account/Register"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
