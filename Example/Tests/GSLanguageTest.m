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

@implementation GSLanguageTest

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

- (void)testUIBarButtonItem {
    UIBarButtonItem *cancelButton;
    NSString *localizedString;
    
    [NSBundle setDefaultLanguage:@"en"];
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    localizedString = cancelButton.title;
    XCTAssert([localizedString isEqualToString:@"Cancel"]);
    
    [NSBundle setDefaultLanguage:@"zh-Hans"];
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    localizedString = cancelButton.title;
    XCTAssert([localizedString isEqualToString:@"取消"]);
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
