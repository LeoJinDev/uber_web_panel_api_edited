//
//  DragUIButton.h
//  XENIA RIDER
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DragUIButton;
@protocol DragUIButtonDelegate <NSObject>

-(void) button:(DragUIButton *) button index:(int) index;

@end

@interface DragUIButton : UIButton


@property(strong ,nonatomic) NSArray *arraImageName;
@property(strong ,nonatomic) id<DragUIButtonDelegate> delegate;

@end
