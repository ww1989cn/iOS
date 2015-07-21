//
//  ItemParser.m
//  CCReader
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 WANG. All rights reserved.
//

#import "ItemParser.h"
#import "Post.h"


@interface ItemParser()

@property (nonatomic) BOOL isParsing;
@property (nonatomic, strong) NSMutableDictionary *currentDict;
@property (nonatomic, strong) NSString *currentValue;
@property (nonatomic, strong) NSMutableArray *items;


@end

@implementation ItemParser

- (instancetype)init
{
    if (self=[super init]) {
        self.currentDict = [[NSMutableDictionary alloc] init];
        self.items = [[NSMutableArray alloc] init];
        
        self.isParsing = NO;
    }
    
    return self;
}


-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"parse begin-->");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        self.isParsing = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.isParsing) {
        return;
    }
    self.currentValue = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if (!self.isParsing) {
        return;
    }
    
    
    if (![elementName isEqualToString:@"item"]) {
        [self.currentDict setValue:self.currentValue forKey:elementName];
    }
    else
    {
        self.isParsing = NO;
        
        Post *post = [[Post alloc] init];
        post.title = [self.currentDict objectForKey:@"title"];
        post.abstract = [self.currentDict objectForKey:@"description"];
        post.link = [self.currentDict objectForKey:@"link"];
        post.author = [self.currentDict objectForKey:@"author"];
        post.category = [self.currentDict objectForKey:@"category"];
        post.pubdate = [self.currentDict objectForKey:@"pubdate"];
        
        [self.items addObject:post];
        
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([self.delegate respondsToSelector:@selector(parse:didFinished:)]) {
        [self.delegate parse:self didFinished:self.items];
        [self.items removeAllObjects];
    }
}


@end
