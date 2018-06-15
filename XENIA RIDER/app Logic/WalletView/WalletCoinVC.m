//
//  WalletCoinVC.m
//  XENIA RIDER
//
//  Created by Clean on 4/20/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import "WalletCoinVC.h"
#import "Carousel.h"
#import "LeftViewController.h"
#import <GrepixKit/GrepixKit.h>
@interface WalletCoinVC ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation WalletCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // _chooseCardView.layer.cornerRadius=5;
  _chooseCardView.layer.masksToBounds=true;
    _chooseCardView.layer.borderColor = [UIColor purpleColor].CGColor;
    _chooseCardView.layer.borderWidth = 0.5f;
   // _loadWalletView.layer.cornerRadius=5;
    _loadWalletView.layer.masksToBounds=true;
    _loadWalletView.layer.borderColor = [UIColor purpleColor].CGColor;
    _loadWalletView.layer.borderWidth = 0.5f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    Carousel *carousel = [[Carousel alloc] initWithFrame:CGRectMake(0, 0, self.card_view.bounds.size.width, self.card_view.bounds.size.height)];
    [carousel setImages:[NSArray arrayWithObjects:@"card_dollar_purple.png",@"card_euro_purple.png",@"card_naira_purple.png",@"card_zar_purple.png",@"checkicon.png",nil]];
    self.card_view.type=iCarouselTypeLinear;
    self.card_view.centerItemWhenSelected=NO;
    //[self.card_view addSubview:carousel];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setViewControllers:(NSString *)sender{
    
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:sender];
    
    [navigationController pushViewController:viewController animated:YES];
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    _items=[[NSMutableArray alloc] initWithObjects:@"card_dollar_purple.png",@"card_euro_purple.png",@"card_naira_purple.png",@"card_zar_purple.png",nil];
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.card_view.bounds.size.width, self.card_view.bounds.size.height)];
        ((UIImageView *)view).image = [UIImage imageNamed:[_items[index] stringValue]];
        view.contentMode =UIViewContentModeScaleAspectFit; //UIViewContentModeScaleToFill;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
       // [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [_items[index] stringValue];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}
-(void)carousel:(iCarousel*)carousel didSelectItemAtIndex:(NSInteger)index
{
    /*
    if(index==[_items count]-1)
    {
        [self setViewControllers:@"WalletIntroduceVC"];
    }
    */
    [self setViewControllers:@"WalletIntroduceVC"];
}
- (IBAction)onMenuButtonTap:(id)sender {
    [self navigateHome];
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
