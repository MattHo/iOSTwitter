//
//  Tweet.m
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.text = dictionary[@"text"];
        self.createdAt = [formatter dateFromString:createdAtString];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
