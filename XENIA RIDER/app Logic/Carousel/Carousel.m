//
//  Carousel.m
//  XENIA RIDER
//
//  Created by Clean on 4/20/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import "Carousel.h"


@implementation Carousel 

@synthesize pageControl; 
@synthesize images; 

#pragma mark - Override images setter 

- (void)setImages:(NSArray *)newImages 
{ 
    if (newImages != images) 
    { 
        images = newImages;
        [self setup]; 
    } 
} 

#pragma mark - Carousel setup 

- (void)setup 
{ 
   UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame]; 
 [scrollView setDelegate:self]; 
  [scrollView setShowsHorizontalScrollIndicator:NO]; 
   [scrollView setPagingEnabled:YES]; 
  [scrollView setBounces:NO]; 
   
    CGSize scrollViewSize = scrollView.frame.size; 
    
      for (NSInteger i = 0; i < [self.images count]; i++) 
           { 
                   CGRect slideRect = CGRectMake(scrollViewSize.width * i, 0, scrollViewSize.width, scrollViewSize.height); 
         
                  UIView *slide = [[UIView alloc] initWithFrame:slideRect]; 
                 [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]]; 
         
                  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame]; 
                  [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]]; 
                  [slide addSubview:imageView]; 
               
                 [scrollView addSubview:slide]; 
               
                } 
  
       UIPageControl *tempPageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollViewSize.height - 20, scrollViewSize.width, 20)]; 
        [self setPageControl:tempPageControll]; 
    
        [self.pageControl setNumberOfPages:[self.images count]]; 
        [scrollView setContentSize:CGSizeMake(scrollViewSize.width * [self.images count], scrollViewSize.height)]; 
    
       [self addSubview:scrollView]; 
    
      [self addSubview:self.pageControl]; 
   } 

 #pragma mark - UIScrollViewDelegate 

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{ 
        CGFloat pageWidth = scrollView.frame.size.width; 
         int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1; 
       [self.pageControl setCurrentPage:page]; 
     } 



 @end 

