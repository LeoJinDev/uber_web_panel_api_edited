//
//  WalletTypeVC.m
//  XENIA RIDER
//
//  Created by Clean on 4/24/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import "WalletTypeVC.h"
#import "LeftViewController.h"
#import "WebCallConstants.h"

@interface WalletTypeVC ()

@end

@implementation WalletTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _btnCnNaira.layer.cornerRadius=5;
    _btnCnNaira.layer.masksToBounds=true;
    _btnCnNaira.layer.borderColor = [UIColor blueColor].CGColor;
    _btnCnNaira.layer.borderWidth = 0.5f;
    
    
    _btnCnUSD.layer.cornerRadius=5;
    _btnCnUSD.layer.masksToBounds=true;
    _btnCnUSD.layer.borderColor = [UIColor cyanColor].CGColor;
    _btnCnUSD.layer.borderWidth = 0.5f;
    
    _btnCnEuro.layer.cornerRadius=5;
    _btnCnEuro.layer.masksToBounds=true;
    _btnCnEuro.layer.borderColor = [UIColor blueColor].CGColor;
    _btnCnEuro.layer.borderWidth = 0.5f;
    
    _btnCnZar.layer.cornerRadius=5;
    _btnCnZar.layer.masksToBounds=true;
    _btnCnZar.layer.borderColor = [UIColor blueColor].CGColor;
    _btnCnZar.layer.borderWidth = 0.5f;
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    _lblholderName.text = [[dict1 objectForKey:P_FNAME] stringByAppendingString:@" "];
    _lblholderName.text=[_lblholderName.text stringByAppendingString:[dict1 objectForKey:P_LNAME]];
    [self setCardType:WC_NAIRA];
    //NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults] objectForKey:P_USER_DICT];
    //_lblholderName.text = [[dict1 objectForKey:P_FNAME] stringByAppendingString:@" "];
    //_lblholderName.text=[_lblholderName.text stringByAppendingString:[dict1 objectForKey:P_LNAME]];
    //_lblholderName.text =[dict1 objectForKey:P_EMAIL];
    //_txtMobile.text =[dict1 objectForKey:P_MOBILE];
    //_txtFirstName.text =[dict1 objectForKey:P_FNAME];
    //_txtLastName.text =[dict1 objectForKey:P_LNAME];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showCardConfirmVC:(id)sender {
    [self setViewControllers:@"WalletConfirmVC"];
    
}

-(void)setViewControllers:(NSString *)sender{
    
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:sender];
    
    [navigationController pushViewController:viewController animated:YES];
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
}
- (IBAction)btnNairaCnClicked:(id)sender {
    [self setCardType:WC_NAIRA];
}
- (IBAction)btnEurCnClicked:(id)sender {
    [self setCardType:WC_EURO];
}
- (IBAction)btnUsdCnClicked:(id)sender {
    [self setCardType:WC_DOLLAR];
}
- (IBAction)btnZarCnClicked:(id)sender {
    [self setCardType:WC_ZAR];
}
-(void) setCardType : (NSString*) Card_Type
{
    
    _btnCnNaira.layer.borderColor = [UIColor blueColor].CGColor;
    _btnCnEuro.layer.borderColor = [UIColor blueColor].CGColor;
    _btnCnUSD.layer.borderColor = [UIColor blueColor].CGColor;
    _btnCnZar.layer.borderColor = [UIColor blueColor].CGColor;
    [_btnCnNaira setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnCnEuro setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnCnUSD setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnCnZar setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    if([Card_Type isEqualToString:WC_NAIRA])
    {
        [_imgCard setImage:[UIImage imageNamed:@"card_naira_purple.png"]];
        _btnCnNaira.layer.borderColor = [UIColor cyanColor].CGColor;
        [_btnCnNaira setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    }
    else if ([Card_Type isEqualToString:WC_EURO])
    {
        
        [_imgCard setImage:[UIImage imageNamed:@"card_euro_purple.png"]];
        _btnCnEuro.layer.borderColor = [UIColor cyanColor].CGColor;
        [_btnCnEuro setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    }
    else if([Card_Type isEqualToString:WC_DOLLAR])
    {
        
        [_imgCard setImage:[UIImage imageNamed:@"card_dollar_purple.png"]];
        _btnCnUSD.layer.borderColor = [UIColor cyanColor].CGColor;
        [_btnCnUSD setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    }
    else
    {
        
        [_imgCard setImage:[UIImage imageNamed:@"card_zar_purple.png"]];
        _btnCnZar.layer.borderColor = [UIColor cyanColor].CGColor;
        [_btnCnZar setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:Card_Type forKey:WC_TYPE];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onMenuButtonTap:(id)sender {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

@end
