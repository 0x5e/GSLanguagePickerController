//
//  GSViewController.m
//  GSLanguagePickerController
//
//  Created by gaosen on 01/23/2017.
//  Copyright (c) 2017 gaosen. All rights reserved.
//

#import "GSViewController.h"
#import "GSLanguagePickerController.h"

@interface GSViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation GSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button = [[UIButton alloc] initWithFrame:self.view.bounds];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setTitle:NSLocalizedString(@"Select Language", @"") forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(selectLanguageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)languageChanged:(NSNotification *)notification {
    NSString *languageId = notification.object;
    NSLog(@"Language has changed: %@", languageId);
    [self.button setTitle:NSLocalizedString(@"Select Language", @"") forState:UIControlStateNormal];
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:[NSBundle defaultLanguage]];
    NSString *languageName = [locale displayNameForKey:NSLocaleIdentifier value:languageId];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Language has changed" message:[NSString stringWithFormat:@"%@: %@", languageId, languageName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)selectLanguageAction:(UIButton *)button {
    GSLanguagePickerController *vc = [GSLanguagePickerController new];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
