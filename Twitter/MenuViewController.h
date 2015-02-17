//
//  MenuViewController.h
//  Twitter
//
//  Created by Matt Ho on 2/15/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewDelegate <NSObject>

- (void)switchView:(NSString *)viewName;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuViewDelegate> delegate;

@end
