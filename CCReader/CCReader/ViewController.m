//
//  ViewController.m
//  CCReader
//
//  Created by WANG on 15/7/12.
//  Copyright © 2015年 WANG. All rights reserved.
//

// iOS论坛RSS:http://www.cocoachina.com/bbs/rss.php?fid-21.html

#import "ViewController.h"
#import "AFNetworking.h"
#import "Post.h"

#import "PostTableViewCell.h"

#import "DetailPostViewController.h"
#import "RefreshControl.h"

#import "ItemParser.h"

#import "CocoaChina.h"

#import <CoreData/CoreData.h>




@interface ViewController () <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, RefreshControlDelegate, ItemParserDelegate>
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) ItemParser *parser;

@property (nonatomic, strong) RefreshControl *refreshControl;
@end

@implementation ViewController


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
         
         [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
         
         
         //
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"Error:%@", error);
         
         [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
         
     }];
}

- (void)requestData {
    [self requestDataWithUrl:self.currentUrl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.currentUrl = bbs[PART_IOS_DEV];
    
    self.items = [[NSMutableArray alloc] init];
    
    self.parser = [[ItemParser alloc] init];
    self.parser.delegate = self;

    
    self.refreshControl = [[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    
    self.refreshControl.topEnabled=YES;
   // self.refreshControl.bottomEnabled=YES;
    
 //  [self.refreshControl startRefreshingDirection:RefreshDirectionTop];
    
   
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Post.data"]];
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    // 用完之后，记得要[context release];
    

    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:context];
    
    NSArray *objs = [context executeFetchRequest:request error:&error];
    
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }

        NSLog(@"objs:%d", objs.count);
//    
    for (Post *post in objs) {
       // NSLog(@"%@", post.title);
        [context deleteObject:post];
    }
    [context save:&error];
    
    NSLog(@"%@",error);
    
   //   NSLog(@"objs:%d", objs.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - parser delegate

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
    static NSString *cellID = @"cell4post";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:self options:nil] lastObject];
    }
    
    Post *post = [self.items objectAtIndex:[indexPath row]];
    
    
    NSString *str = [post.title stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];// &nbsp;是html里面的空格
    cell.titleLabel.text = str;
    
    cell.authorLabel.text = post.author;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    
    //真机上必须指定locale, 否则date返回null
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [formatter setLocale:locale];
    
    NSDate* date = [formatter dateFromString:post.pubdate];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    cell.timeLabel.text = [formatter stringFromDate:date];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.items objectAtIndex:[indexPath row]];
    
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailPostViewController *vc = (DetailPostViewController *)[sb instantiateViewControllerWithIdentifier:@"Detail"];
    
    vc.post = post;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - refresh control

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;
        [strongSelf requestData];
    });
}

- (IBAction)refresh:(id)sender {
     [self.refreshControl startRefreshingDirection:RefreshDirectionTop];
}

- (IBAction)showMore:(id)sender {
    
    CGFloat translateX = 200;
    CGFloat transcale = 0.8;
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.ItemView.transform = conT;
                     }
                     completion:^(BOOL finished) {
                         self.tableView.userInteractionEnabled = NO;
                     }];
}

- (IBAction)changePart:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *str = bbs[btn.tag];
    
    if ([self.currentUrl isEqualToString:str]) {
        return;
    }
    
    self.currentUrl = str;
    
    CGFloat translateX = 0;
    CGFloat transcale = 1;
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.ItemView.transform = conT;
                     }
                     completion:^(BOOL finished) {
                         self.tableView.userInteractionEnabled = YES;
                    [self.refreshControl startRefreshingDirection:RefreshDirectionTop];
                     }];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat translateX = 0;
    CGFloat transcale = 1;
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.ItemView.transform = conT;
                     }
                     completion:^(BOOL finished) {
                         self.tableView.userInteractionEnabled = YES;
                     }];
}

@end
