//
//  MenuViewController.m
//  Twitter
//
//  Created by Matt Ho on 2/15/15.
//  Copyright (c) 2015 Yahoo Inc. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileCell.h"
#import "MenuItemCell.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *itemList;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42.0f/255.0f green:139.0f/255.0f blue:232.0f/255.0f alpha:1.0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"MenuItemCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    self.itemList = @[
      @{@"icon": @"user", @"name": @"Profile", @"view": @"profile"},
      @{@"icon": @"home", @"name": @"Timelines", @"view": @"timelines"},
      @{@"icon": @"bell", @"name": @"Notifications", @"view": @"notifications"},
      @{@"icon": @"reply", @"name": @"Logout", @"view": @"logout"}
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        profileCell.user = [User currentUser];
        [profileCell setLayoutMargins:UIEdgeInsetsZero];
        profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return profileCell;
    } else {
        NSDictionary *item = self.itemList[indexPath.row - 1];
        
        MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
        cell.iconImageView.image = [UIImage imageNamed:[item valueForKey:@"icon"]];
        cell.nameLabel.text = [item valueForKey:@"name"];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row > 0) {
        NSDictionary *item = self.itemList[indexPath.row - 1];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.delegate switchView:[item valueForKey:@"view"]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
