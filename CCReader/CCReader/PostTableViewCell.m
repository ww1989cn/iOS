//
//  PostTableViewCell.m
//  CCReader
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 WANG. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
