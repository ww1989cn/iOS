//
//  ViewController.h
//  CCReader
//
//  Created by WANG on 15/7/12.
//  Copyright © 2015年 WANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *ItemView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *currentUrl;

- (IBAction)refresh:(id)sender;
- (IBAction)showMore:(id)sender;

- (IBAction)changePart:(id)sender;


@end

