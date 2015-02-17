//
//  User.m
//  Twitter
//
//  Created by Matt Ho on 2/8/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

static User *_currentUser;
static NSDictionary *_userPool;

NSString * const kCruuentUserKey = @"kCurrentUserKey";
NSString * const kUserPoolKey = @"kUserPoolKey";

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.id = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
        self.followers = [dictionary[@"followers_count"] stringValue];
        self.following = [dictionary[@"friends_count"] stringValue];
        self.backgroundImageUrl = dictionary[@"profile_banner_url"];
        
        if (self.backgroundImageUrl == nil) {
            self.backgroundImageUrl = dictionary[@"profile_background_image_url"];
        }
    }
    
    return self;
}

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCruuentUserKey];

        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (NSDictionary *)userPool {
    if (_userPool == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPoolKey];
        
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _userPool = [NSMutableDictionary dictionary];
            
            for (NSString* key in dictionary) {
                NSDictionary *userDictionary = [dictionary valueForKey:key];
                [_userPool setValue:[[User alloc] initWithDictionary:userDictionary] forKey:key];
            }
        }
    }
    
    return _userPool;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCruuentUserKey];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSData *userPoolData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPoolKey];
        if (userPoolData != nil) {
            dictionary = [[NSJSONSerialization JSONObjectWithData:userPoolData options:0 error:NULL] mutableCopy];
        }
        [dictionary setValue:currentUser.dictionary forKey:currentUser.screenname];
        userPoolData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:userPoolData forKey:kUserPoolKey];
        _userPool = dictionary;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCruuentUserKey];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}


@end
