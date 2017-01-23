//
//  GSLanguagePickerController.m
//  GSLanguagePickerController
//
//  Created by gaosen on 2017/1/23.
//  Copyright (c) 2017 gaosen. All rights reserved.
//

#import "GSLanguagePickerController.h"

@interface GSLanguagePickerController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *filteredDataSource;
@property (nonatomic, strong) NSArray *allDataSource;
@property (nonatomic, strong) NSDictionary *currentDisplayNameDict;
@property (nonatomic, strong) NSDictionary *targetDisplayNameDict;
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
    NSString *InternationalSettingsBundlePath = @"/System/Library/PreferenceBundles/InternationalSettings.bundle";
#if TARGET_IPHONE_SIMULATOR
    InternationalSettingsBundlePath = [NSString stringWithFormat:@"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/%@", InternationalSettingsBundlePath];
#endif
    NSBundle *InternationalSettingsBundle = [NSBundle bundleWithPath:InternationalSettingsBundlePath];
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"LANGUAGE", @"InternationalSettings", InternationalSettingsBundle, nil);
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)initData {
    self.allDataSource = [NSBundle mainBundle].localizations;
    self.currentLanguageId = [NSBundle defaultLanguage];
    
    NSMutableDictionary *currentDisplayNameDict = [NSMutableDictionary dictionary];
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:self.currentLanguageId];
    for (NSString *languageId in self.allDataSource) {
        NSString *displayName = [currentLocale displayNameForKey:NSLocaleIdentifier value:languageId];
        [currentDisplayNameDict setObject:displayName forKey:languageId];
    }
    self.currentDisplayNameDict = [currentDisplayNameDict copy];
    
    NSMutableDictionary *targetDisplayNameDict = [NSMutableDictionary dictionary];
    for (NSString *languageId in self.allDataSource) {
        NSLocale *targetLocale = [NSLocale localeWithLocaleIdentifier:languageId];
        NSString *displayName = [targetLocale displayNameForKey:NSLocaleIdentifier value:languageId];
        [targetDisplayNameDict setObject:displayName forKey:languageId];
    }
    self.targetDisplayNameDict = [targetDisplayNameDict copy];
}

#pragma mark - action

- (IBAction)cancelAction:(UIBarButtonItem *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(UIBarButtonItem *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        [NSBundle setDefaultLanguage:self.currentLanguageId];
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
    cell.textLabel.text = [self.targetDisplayNameDict objectForKey:languageId];
    cell.detailTextLabel.text = [self.currentDisplayNameDict objectForKey:languageId];
    cell.accessoryType = [self.currentLanguageId hasPrefix:languageId] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentLanguageId = self.dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = self.searchController.searchBar.text;
    if (searchText.length == 0) {
        [self.tableView reloadData];
        return;
    }
    
    NSMutableSet *result = [NSMutableSet set];
    [self.currentDisplayNameDict enumerateKeysAndObjectsUsingBlock:^(NSString *languageId, NSString *displayName, BOOL *stop) {
        if ([displayName.lowercaseString containsString:searchText.lowercaseString]) {
            [result addObject:languageId];
        }
    }];
    [self.targetDisplayNameDict enumerateKeysAndObjectsUsingBlock:^(NSString *languageId, NSString *displayName, BOOL *stop) {
        if ([displayName.lowercaseString containsString:searchText.lowercaseString]) {
            [result addObject:languageId];
        }
    }];

    NSMutableArray *filteredDataSource = [NSMutableArray array];
    [self.allDataSource enumerateObjectsUsingBlock:^(NSString *languageId, NSUInteger idx, BOOL *stop) {
        if ([result containsObject:languageId]) {
            [filteredDataSource addObject:languageId];
        }
    }];
    self.filteredDataSource = [filteredDataSource copy];
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        searchBar.showsCancelButton = NO;
    }
}

#pragma mark -

- (void)dealloc {
    [self.searchController.view removeFromSuperview];
}

@end
