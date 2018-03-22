//
//  AKMainViewController.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 08/02/2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKMainViewController.h"
@import AnobiUIKit;

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
    [AKThemeManager managerWithConfigName:@"AKThemes"];
    self.tableView.tableFooterView = [UIView new];
    [self updateUIWithCurrentTheme];
    flipAnimation = [CAAnimation flipAngle:2.0 * M_PI vector:AK3DVectorMake(0.3, 0.5, 0)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s(origin)", __PRETTY_FUNCTION__);
}

- (IBAction)nextThemeTap:(id)sender {
    NSUInteger newIndex = [[AKThemeManager manager].allNames indexOfObject:currentTheme.name];
    newIndex++;
    newIndex %= [AKThemeManager manager].allNames.count;
    [[AKThemeManager manager] setCurrentThemeName:[AKThemeManager manager].allNames[newIndex]];
    [self updateUIWithCurrentTheme];
}

- (IBAction)flipTap:(id)sender {
    [gridView.layer addFlipAnimation:flipAnimation];
}

- (void)updateUIWithCurrentTheme {
    AKTheme *theme = [AKThemeManager manager].currentTheme;
    if (currentTheme != theme) {
        currentTheme = theme;

        self.navigationController.toolbar.barStyle =
        self.navigationController.navigationBar.barStyle = currentTheme.barStyle;
        self.navigationController.toolbar.barTintColor =
        self.navigationController.navigationBar.barTintColor = currentTheme[AKThemeColorKey_naviBarTint];
        self.navigationController.toolbar.translucent = false;
        self.navigationController.toolbar.clipsToBounds = false;
        
        self.navigationController.toolbar.tintColor =
        self.navigationController.navigationBar.tintColor = currentTheme[AKThemeColorKey_naviTint];
        self.navigationController.navigationBar.titleTextColor = currentTheme[AKThemeColorKey_naviTitle];
        
        self.view.backgroundColor = currentTheme[AKThemeColorKey_mainBackground];
        self.view.tintColor = currentTheme[AKThemeColorKey_mainTint];
        themeNameLabel.textColor = currentTheme[AKThemeColorKey_mainText];
        themeNameLabel.text = [NSString stringWithFormat:@"Current Theme name: %@", currentTheme.name];
        
        self.tableView.tableFooterView.backgroundColor = self.tableView.backgroundColor = currentTheme[AKThemeColorKey_tableBackground];
        self.tableView.separatorColor = currentTheme[AKThemeColorKey_tableSeparator];
        self.tableView.tintColor = currentTheme[AKThemeColorKey_mainTint];
        [self.tableView reloadData];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AKThemeManager manager].allNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = currentTheme[indexPath.row % 2 ? AKThemeColorKey_tableCellBackground : AKThemeColorKey_tableSecondaryCellBackground];
    cell.textLabel.textColor = currentTheme[indexPath.row % 2 ? AKThemeColorKey_mainText : AKThemeColorKey_mainSubtext ];
    cell.textLabel.text = [AKThemeManager manager].allNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[AKThemeManager manager] setCurrentThemeName:[AKThemeManager manager].allNames[indexPath.row]];
    [self updateUIWithCurrentTheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
