//
//  AKMainViewController.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 08/02/2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKMainViewController.h"
#import <AnobiKit/AnobiKit.h>
#import <AnobiUIKit/AnobiUIKit.h>
#import <AnobiView/AnobiView.h>

@interface AKMainViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AKMainViewController {
    __weak IBOutlet UILabel *themeNameLabel;
    __weak IBOutlet UIView *gridView;
    AKTheme *currentTheme;
    CAAnimation *flipAnimation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *config = [AKConfigManager manager][@"AKThemes"];
    [AKThemeManager managerWithConfig:config];
    self.tableView.tableFooterView = [UIView new];
    [self updateUIWithCurrentTheme];
    flipAnimation = [CAAnimation flipAngle:4.0 * M_PI vector:AK3DVectorMake(0.3, 0.1, 0.5) dutation:1.2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s(origin)", __PRETTY_FUNCTION__);
}

- (IBAction)nextThemeTap:(id)sender {
    NSUInteger newIndex = [[AKThemeManager manager].allNames indexOfObject:currentTheme.name];
    newIndex++;
    newIndex %= [AKThemeManager manager].allNames.count;
    [AKThemeManager manager].currentTheme = [AKThemeManager manager].allThemes[newIndex];
    [self updateUIWithCurrentTheme];
}

- (IBAction)flipTap:(id)sender {
    [gridView.layer addFlipAnimation:flipAnimation];
}

- (void)updateUIWithCurrentTheme {
    AKTheme *theme = [AKThemeManager manager].currentTheme;
    if (currentTheme != theme) {
        currentTheme = theme;

        [theme applyAppearanceSchema];
        self.navigationController.toolbar.barStyle =
        self.navigationController.navigationBar.barStyle = theme.barStyle;
        self.navigationController.toolbar.barTintColor =
        self.navigationController.navigationBar.barTintColor = theme[@"naviBarTint"];
        self.navigationController.toolbar.translucent = false;
        self.navigationController.toolbar.clipsToBounds = false;
        
        self.navigationController.toolbar.tintColor =
        self.navigationController.navigationBar.tintColor = theme[@"naviTint"];
        self.navigationController.navigationBar.titleTextColor = theme[@"naviTitle"];
        
        self.view.backgroundColor = theme[@"mainBackground"];
        self.view.tintColor = theme[@"mainTint"];
        themeNameLabel.textColor = theme[@"mainText"];
        themeNameLabel.text = [NSString stringWithFormat:@"Current Theme name: %@", theme.name];
        
        self.tableView.tableFooterView.backgroundColor = self.tableView.backgroundColor = theme[@"tableBackground"];
        self.tableView.separatorColor = theme[@"tableSeparator"];
        self.tableView.tintColor = theme[@"mainTint"];
        [self.tableView reloadData];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AKThemeManager manager].allNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = currentTheme[indexPath.row % 2 ? @"tableCellBackground" : @"tableSecondaryCellBackground"];
    cell.textLabel.textColor = currentTheme[indexPath.row % 2 ? @"mainText" : @"mainSubtext" ];
    cell.textLabel.text = [AKThemeManager manager].allNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [AKThemeManager manager].currentTheme = [AKThemeManager manager].allThemes[indexPath.row];
    [self updateUIWithCurrentTheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
