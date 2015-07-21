//
//  Post.m
//  CCReader
//
//  Created by WANG on 15/7/12.
//  Copyright © 2015年 WANG. All rights reserved.
//

#import "Post.h"

@implementation Post

- (NSString *)rssLink
{
    return [self.link stringByReplacingOccurrencesOfString:@"read" withString:@"rss"];
}

@end
