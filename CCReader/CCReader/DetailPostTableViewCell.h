//
//  DetailPostTableViewCell.h
//  CCReader
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 WANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
