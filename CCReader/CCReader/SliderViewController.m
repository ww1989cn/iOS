//
//  SliderViewController.m
//  CCReader
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 WANG. All rights reserved.
//

#import "SliderViewController.h"
#import "ViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *vc = (ViewController *)[SB instantiateViewControllerWithIdentifier:@"navVc"];
    
    [self.view addSubview:vc.view];
    
    NSLog(@"LOG");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
