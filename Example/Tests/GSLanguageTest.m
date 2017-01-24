//
//  GSLanguageTest.m
//  GSLanguagePickerController
//
//  Created by 高森 on 2017/1/24.
//  Copyright © 2017年 gaosen. All rights reserved.
//

#import "GSLanguageTest.h"
#import "GSLanguagePickerController.h"
#import <WebKit/WebKit.h>

@interface UIBarButtonItem ()

- (NSString *)_resolveSystemTitle;

@end


@implementation GSLanguageTest

// NSLocalizedString use localizedString from [NSBundle mainBundle]
- (void)testNSLocalizedString {
    NSString *localizedString;
    
    [NSBundle setDefaultLanguage:@"en"];
    localizedString = NSLocalizedString(@"Hello", nil);
    XCTAssert([localizedString isEqualToString:@"Hello"]);
    
    [NSBundle setDefaultLanguage:@"fr"];
    localizedString = NSLocalizedString(@"Hello", nil);
    XCTAssert([localizedString isEqualToString:@"Bonjour"]);
    
    [NSBundle setDefaultLanguage:@"zh-Hans"];
    localizedString = NSLocalizedString(@"Hello", nil);
    XCTAssert([localizedString isEqualToString:@"你好"]);
}

// UIBarButtonSystemItem use localized string & image from UIKit.framework
- (void)testUIBarButtonItem {
    UIBarButtonItem *cancelButton;
    NSString *localizedString;
    
    [NSBundle setDefaultLanguage:@"en"];
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    localizedString = [cancelButton _resolveSystemTitle];
    XCTAssert([localizedString isEqualToString:@"Done"]);
    
    [NSBundle setDefaultLanguage:@"fr"];
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    localizedString = [cancelButton _resolveSystemTitle];
    XCTAssert([localizedString isEqualToString:@"OK"]);
}

- (void)testNSURLRequest {
    NSURLRequest *request;
    NSString *acceptLanguage;
    
    [NSBundle setDefaultLanguage:@"en"];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    acceptLanguage = [request.allHTTPHeaderFields objectForKey:@"Accept-Language"];
    XCTAssert([acceptLanguage containsString:@"en"]);
    
    [NSBundle setDefaultLanguage:@"zh-Hans"];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    acceptLanguage = [request.allHTTPHeaderFields objectForKey:@"Accept-Language"];
    XCTAssert([acceptLanguage containsString:@"zh-Hans"]);
}

- (void)testUIWebView {
    UIWebView *webview;
    NSString *language;
    
    [NSBundle setDefaultLanguage:@"en"];
    webview = [[UIWebView alloc] init];
    language = [webview stringByEvaluatingJavaScriptFromString:@"navigator.language"];
    XCTAssert([language containsString:@"en"]);
    
    [NSBundle setDefaultLanguage:@"zh-Hans"];
    webview = [[UIWebView alloc] init];
    language = [webview stringByEvaluatingJavaScriptFromString:@"navigator.language"];
    XCTAssert([language containsString:@"zh-Hans"]);
}

- (void)testWKWebView {
    WKWebView *webview;
    
    [NSBundle setDefaultLanguage:@"en"];
    webview = [[WKWebView alloc] init];
    [webview evaluateJavaScript:@"navigator.language" completionHandler:^(NSString *language, NSError *error) {
        // TODO
        XCTAssertNil(error);
        XCTAssert([language containsString:@"en"]);
    }];
    
    [NSBundle setDefaultLanguage:@"zh-Hans"];
    webview = [[WKWebView alloc] init];
    [webview evaluateJavaScript:@"navigator.language" completionHandler:^(NSString *language, NSError *error) {
        XCTAssertNil(error);
        XCTAssert([language containsString:@"zh-Hans"]);
    }];

}

@end
