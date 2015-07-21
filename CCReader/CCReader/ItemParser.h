//
//  ItemParser.h
//  CCReader
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 WANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemParserDelegate;

@interface ItemParser : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) id<ItemParserDelegate> delegate;

@end


@protocol ItemParserDelegate <NSObject>

- (void) parse : (ItemParser *) parser didFinished : (NSArray *) items;

@end

