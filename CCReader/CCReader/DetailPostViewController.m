//
//  DetailPostViewController.m
//  CCReader
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 WANG. All rights reserved.
//

#import "DetailPostViewController.h"
#import "AFHTTPRequestOperationManager.h"

#import "DetailPostTableViewCell.h"
#import "ItemParser.h"

@interface DetailPostViewController () <ItemParserDelegate, UITableViewDelegate>

@property (nonatomic, strong) ItemParser *parser;
@property (nonatomic, strong) NSMutableArray *items;

@end


@implementation DetailPostViewController

- (void) requestDataWithUrl : (NSString *) url
{
    AFHTTPRequestOperationManager   *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.items removeAllObjects];
         
         NSXMLParser *parser = (NSXMLParser *)responseObject;
         parser.delegate = self.parser;
         [parser setShouldProcessNamespaces:NO];
         [parser setShouldReportNamespacePrefixes:NO];
         [parser setShouldResolveExternalEntities:NO];
         [parser parse];
         
         //if (self.refreshControl.refreshingDirection==RefreshingDirectionTop)
//         {
//             [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
//         }
         
         //
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"Error:%@", error);
         
         // if (self.refreshControl.refreshingDirection==RefreshingDirectionTop)
//         {
//             [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
//         }
     }];
}

- (void)requestData {
    [self requestDataWithUrl:[self.post rssLink]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.items = [[NSMutableArray alloc] init];
    
    self.parser = [[ItemParser alloc] init];
    self.parser.delegate = self;

    //NSLog(@"%@", self.post.title);
    self.titleView.adjustsFontSizeToFitWidth = YES;
    self.titleView.text = self.post.title;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self requestData];
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


- (void)parse:(ItemParser *)parser didFinished:(NSArray *)items
{
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:items];
    [self.tableView reloadData];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell4detailpost";
    
    DetailPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPostTableViewCell" owner:self options:nil] lastObject];
    }
    
    Post *post = [self.items objectAtIndex:self.items.count-1-[indexPath row]];
    
    NSString *follow;
    
    if ([post.author isEqualToString:self.post.author])
    {
        follow = @"[楼主] ";
    }
    else
    {
        follow = [NSString stringWithFormat:@"%d楼 ", [indexPath row]+1];
    }
    
    cell.authorLabel.text = [follow stringByAppendingString:post.author];
    //cell.detaiLabel.text = post.abstract;
    
    NSString *str = [post.abstract stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];// &nbsp;是html里面的空格
    cell.textView.text = str;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [formatter setLocale:locale];
    
    [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    
    NSDate* date = [formatter dateFromString:post.pubdate];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    cell.timeLabel.text = [formatter stringFromDate:date];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.items objectAtIndex:self.items.count-1-[indexPath row]];
    NSLog(@"%@", post.link);
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
