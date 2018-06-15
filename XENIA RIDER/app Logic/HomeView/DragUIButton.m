//
//  DragUIButton.m
//  XENIA RIDER
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "DragUIButton.h"

@implementation DragUIButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor  whiteColor]];
    [self setClipsToBounds: YES];
    [self .layer setCornerRadius:30];
    //    [self setImage:[UIImage imageNamed:@"Hatchback_r"] forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    self.arraImageName=@[@"Hatchback_r",@"sedan_r",@"suv_r"];
    


    [self Method];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)Method
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
    //    [panRecognizer release];
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y );
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [recognizer velocityInView:self];
        velocity.x=1;
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y );
        NSLog(@"Point %f",finalPoint.x);
        
        //        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.bounds.size.width);
        //        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.bounds.size.height);
        CGRect  rect=[UIScreen mainScreen].bounds;
        int w=(rect.size.width-20)/3;
        
        int index=0;
        if(recognizer.view.center.x<w)
        {
         index=0;
        }
        else if(recognizer.view.center.x>2.25*w)
        {
            index=2;
        
        }else{
            index=1;
        
        }
        [self setContentMode:UIViewContentModeScaleToFill];
         [self setImage:[UIImage imageNamed:[_arraImageName  objectAtIndex:index]] forState:UIControlStateNormal];
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self];
        velocity.x=1;
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y );
        NSLog(@"Point %f",finalPoint.x);
        
        //        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.bounds.size.width);
        //        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.bounds.size.height);
        CGRect  rect=[UIScreen mainScreen].bounds;
        int w=(rect.size.width-20)/3;
        int ix=10;
        int index=0;
        if(finalPoint.x<w)
        {
            ix=10; index=0;
        }
        else if(finalPoint.x>2*w)
        {
            index=2;
            ix=rect.size.width-70;
        }else{
            index=1;
            ix=rect.size.width/2-30;
        }
        //        int ix=(finalPoint.x-30)/w;
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.frame = CGRectMake(ix, 30, 60, 60);
        } completion:^(BOOL finished) {
            if(finished)
            {
                [self setContentMode:UIViewContentModeScaleToFill];
                [self setImage:[UIImage imageNamed:[_arraImageName  objectAtIndex:index]] forState:UIControlStateNormal];
                [self.delegate button:self index:index];
            }
        }];
    }
    
}

@end
