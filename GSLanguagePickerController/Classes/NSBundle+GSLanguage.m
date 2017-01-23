//
//  NSBundle+GSLanguage.m
//  GSLanguagePickerController
//
//  Created by gaosen on 01/23/2017.
//  Copyright (c) 2017 gaosen. All rights reserved.
//

#import "NSBundle+GSLanguage.h"
#import <objc/runtime.h>

NSString *const kDefaultLanguage = @"AppleLanguages";

@implementation NSBundle (GSLanguage)

+ (void)load {
#if DEBUG
    Method ori_Method = class_getInstanceMethod(NSBundle.class, @selector(localizedStringForKey:value:table:));
    Method my_Method = class_getInstanceMethod(NSBundle.class, @selector(runtimeLocalizedStringForKey:value:table:));
    method_exchangeImplementations(ori_Method, my_Method);
#endif
}

- (NSString *)runtimeLocalizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSString *lang = [NSBundle defaultLanguage];
    if (lang.length == 0) {
        lang = [self.preferredLocalizations firstObject];
    }
    
    // TODO: have trouble in .../UIKit.framework/English.lproj
    NSString *langBundlePath = [self pathForResource:lang ofType:@"lproj"];
    
    if (langBundlePath) {
        NSBundle *bundle = [NSBundle bundleWithPath:langBundlePath];
        return [bundle runtimeLocalizedStringForKey:key value:value table:tableName];
    } else {
        return [self runtimeLocalizedStringForKey:key value:value table:tableName];
    }
}

+ (void)setDefaultLanguage:(NSString *)languageId {
    [[NSUserDefaults standardUserDefaults] setObject:@[languageId ?: @""] forKey:kDefaultLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSCurrentLocaleDidChangeNotification object:languageId];
}

+ (NSString *)defaultLanguage {
    NSString *languageId = [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultLanguage] objectAtIndex:0];
    return languageId;
}

@end
