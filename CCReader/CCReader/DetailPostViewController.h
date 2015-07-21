//
//  DetailPostViewController.h
//  CCReader
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 WANG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Post.h"

@interface DetailPostViewController : UIViewController

@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
- (IBAction)back:(id)sender;

@end
