//
//  GSLanguagePickerController.m
//  GSLanguagePickerController
//
//  Created by gaosen on 2017/1/23.
//  Copyright (c) 2017 gaosen. All rights reserved.
//

#import "GSLanguagePickerController.h"

static NSString * UIKitLocalizedString(NSString *string) {
    NSBundle *UIKitBundle = [NSBundle bundleForClass:[UIApplication class]];
    return UIKitBundle ? [UIKitBundle localizedStringForKey:string value:string table:nil] : string;
}

@interface GSLanguagePickerController () <UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *filteredDataSource;
@property (nonatomic, strong) NSArray *allDataSource;
@property (nonatomic, strong) NSString *currentLanguageId;

@end

@implementation GSLanguagePickerController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView {
    self.navigationItem.title = UIKitLocalizedString(@"Select");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    }
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)initData {
    NSMutableArray *dataSource = [NSMutableArray arrayWithArray:[NSBundle mainBundle].localizations];
    [dataSource insertObject:@"" atIndex:0];
    self.allDataSource = dataSource;
    
    self.currentLanguageId = [NSBundle defaultLanguage];
}

#pragma mark - action

- (IBAction)cancelAction:(UIBarButtonItem *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(UIBarButtonItem *)button {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [NSBundle setDefaultLanguage:weakSelf.currentLanguageId];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSArray *)dataSource {
    if (self.searchController.active && self.searchController.searchBar.text.length > 0) {
        return self.filteredDataSource;
    } else {
        return self.allDataSource;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    NSString *languageId = self.dataSource[indexPath.row];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:languageId];
//    NSLocale *currentLocale = [NSLocale autoupdatingCurrentLocale];
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:[NSBundle defaultLanguage]];
    cell.textLabel.text = [locale displayNameForKey:NSLocaleIdentifier value:languageId];
    cell.detailTextLabel.text = [currentLocale displayNameForKey:NSLocaleIdentifier value:languageId];
    cell.accessoryType = [languageId isEqualToString:self.currentLanguageId] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    if (languageId.length == 0) {
        cell.textLabel.text = @"Default";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentLanguageId = self.dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // TODO
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", self.searchController.searchBar.text];
    self.filteredDataSource = [self.allDataSource filteredArrayUsingPredicate:searchPredicate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)dealloc {
    [self.searchController.view removeFromSuperview];
}

@end
