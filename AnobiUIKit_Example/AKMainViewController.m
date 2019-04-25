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
    flipAnimation = [CAAnimation flipAngle:8.0 * M_PI vector:AK3DVectorMake(0.3, 0.1, 0.5) dutation:1.2];
    
    self.navigationController.toolbar.translucent = false;
    self.navigationController.toolbar.clipsToBounds = false;
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

        themeNameLabel.textColor = theme[@"mainText"];
        themeNameLabel.text = [NSString stringWithFormat:@"Current Theme name: %@", theme.name];
        
        self.tableView.tableFooterView.backgroundColor = self.tableView.backgroundColor = theme[@"tableBackground"];
        [self.tableView reloadData];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AKThemeManager manager].allNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = currentTheme[@"tableSecondaryCellBackground"];
    }
    cell.textLabel.textColor = currentTheme[indexPath.row % 2 ? @"mainText" : @"mainSubtext" ];
    cell.textLabel.text = [AKThemeManager manager].allNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [AKThemeManager manager].currentTheme = [AKThemeManager manager].allThemes[indexPath.row];
    [self updateUIWithCurrentTheme];
}


@end
