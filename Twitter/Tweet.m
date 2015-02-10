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
        
        self.id = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.createdAt = [formatter dateFromString:createdAtString];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.retweetCount = dictionary[@"retweet_count"];
        self.favoriteCount = dictionary[@"favorite_count"];
        self.retweeted = dictionary[@"retweeted"];
        self.favorited = dictionary[@"favorited"];
        
        if ([self.favorited isEqual:@1] && [self.favoriteCount isEqual:@0]) {
            self.favoriteCount = @1;
        }
        
        if (dictionary[@"retweeted_status"] != nil) {
            Tweet *retweet = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
            retweet.retweet = self;
            return retweet;
        }
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
