//
//  Post.h
//  CCReader
//
//  Created by WANG on 15/7/12.
//  Copyright © 2015年 WANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Post : NSManagedObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *pubdate;


- (NSString *)rssLink;

@end
