//
//  Carousel.h
//  XENIA RIDER
//
//  Created by Clean on 4/20/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Carousel : UIView<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    NSArray *pages;
}
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *images;
-(void) setup;
@end
