//
//  WalletIntroduceVC.m
//  XENIA RIDER
//
//  Created by Clean on 4/24/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import "WalletIntroduceVC.h"
#import "LeftViewController.h"
#import <GrepixKit/GrepixKit.h>
@interface WalletIntroduceVC ()

@end

@implementation WalletIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showCardSelectVC:(id)sender {
    [self setViewControllers:@"WalletTypeVC"];
    
}

-(void)setViewControllers:(NSString *)sender{
    
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:sender];
    
    [navigationController pushViewController:viewController animated:YES];
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
}
- (IBAction)backToWalletView:(id)sender {
    [self setViewControllers:@"WalletCoinVC"];
}
- (IBAction)onMenuButtonTap:(id)sender {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnLaterTap:(id)sender {
 //   [self navigateHome];
}

-(void)navigateHome{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    
    
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"]]];
    
    
    MainViewController *mainViewController =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:2];
    //    self.leftViewWidth =;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
    
}
@end
