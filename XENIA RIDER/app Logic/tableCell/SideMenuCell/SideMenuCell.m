//
//  SideMenuCell.m
//  Store_project
//
//  Created by SFYT on 22/02/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "SideMenuCell.h"
#import "WebCallConstants.h"

@implementation SideMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    [self.lblMenu setFont:FONT_ROB_COND_REG(17)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
