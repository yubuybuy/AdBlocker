/**
 * AdBlocker - iOS 广告拦截插件
 * 用于学习 iOS 越狱开发
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

// ========== 通用广告视图拦截 ==========

%hook UIView

- (void)didMoveToWindow {
    %orig;

    // 检测可能是广告的视图
    NSString *className = NSStringFromClass([self class]);

    // 常见广告 SDK 类名特征
    NSArray *adKeywords = @[@"Ad", @"Banner", @"Interstitial",
                           @"Native", @"Reward", @"Splash",
                           @"GAD", @"DFP", @"Admob"];

    for (NSString *keyword in adKeywords) {
        if ([className containsString:keyword]) {
            NSLog(@"[AdBlocker] 拦截广告视图: %@", className);
            self.hidden = YES;
            self.alpha = 0;
            [self removeFromSuperview];
            break;
        }
    }
}

%end

// ========== Google AdMob 拦截 ==========

%hook GADBannerView

- (void)loadRequest:(id)request {
    NSLog(@"[AdBlocker] 拦截 AdMob Banner 广告请求");
    // 不调用 %orig，阻止广告加载
}

%end

%hook GADInterstitialAd

+ (void)loadWithAdUnitID:(NSString *)adUnitID
                 request:(id)request
       completionHandler:(void (^)(id ad, NSError *error))completionHandler {
    NSLog(@"[AdBlocker] 拦截 AdMob 插屏广告请求");
    // 返回错误，阻止广告显示
    if (completionHandler) {
        NSError *error = [NSError errorWithDomain:@"AdBlocker"
                                            code:1
                                        userInfo:@{NSLocalizedDescriptionKey: @"Ad blocked"}];
        completionHandler(nil, error);
    }
}

%end

%hook GADRewardedAd

+ (void)loadWithAdUnitID:(NSString *)adUnitID
                 request:(id)request
       completionHandler:(void (^)(id ad, NSError *error))completionHandler {
    NSLog(@"[AdBlocker] 拦截 AdMob 激励视频广告");
    if (completionHandler) {
        NSError *error = [NSError errorWithDomain:@"AdBlocker"
                                            code:1
                                        userInfo:@{NSLocalizedDescriptionKey: @"Ad blocked"}];
        completionHandler(nil, error);
    }
}

%end

// ========== 穿山甲（字节跳动）广告拦截 ==========

%hook BUNativeExpressBannerView

- (void)loadAdData {
    NSLog(@"[AdBlocker] 拦截穿山甲 Banner 广告");
    // 不调用原方法
}

%end

%hook BUNativeExpressInterstitialAd

- (void)loadAdData {
    NSLog(@"[AdBlocker] 拦截穿山甲插屏广告");
}

%end

%hook BUNativeExpressRewardedVideoAd

- (void)loadAdData {
    NSLog(@"[AdBlocker] 拦截穿山甲激励视频广告");
}

%end

// ========== 优量汇（腾讯）广告拦截 ==========

%hook GDTUnifiedBannerView

- (void)loadAdAndShow {
    NSLog(@"[AdBlocker] 拦截优量汇 Banner 广告");
}

%end

%hook GDTUnifiedInterstitialAd

- (void)loadAd {
    NSLog(@"[AdBlocker] 拦截优量汇插屏广告");
}

%end

// ========== WKWebView 广告拦截 ==========

%hook WKWebView

- (void)loadRequest:(NSURLRequest *)request {
    NSString *url = request.URL.absoluteString;

    // 常见广告域名黑名单
    NSArray *adDomains = @[
        @"googleads",
        @"doubleclick.net",
        @"googlesyndication.com",
        @"googleadservices.com",
        @"ad.doubleclick.net",
        @"pagead2.googlesyndication.com",
        @"tpc.googlesyndication.com",
        @"adservice.google.com",
        @"bytedance.com/api/ad",
        @"pangolin-sdk-toutiao.com",
        @"pglstatp-toutiao.com"
    ];

    for (NSString *domain in adDomains) {
        if ([url containsString:domain]) {
            NSLog(@"[AdBlocker] 拦截广告请求: %@", url);
            return; // 不加载
        }
    }

    %orig;
}

// 注入 CSS 隐藏网页广告
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    %orig;

    // 页面加载后注入广告屏蔽脚本
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *adBlockCSS = @"var style = document.createElement('style');"
                               @"style.innerHTML = '"
                               @"  .ad, .ads, [class*=\"ad-\"], [id*=\"ad-\"], "
                               @"  [class*=\"google-ad\"], [class*=\"banner\"], "
                               @"  iframe[src*=\"ads\"], iframe[src*=\"doubleclick\"] "
                               @"  { display: none !important; visibility: hidden !important; }';"
                               @"document.head.appendChild(style);";

        [self evaluateJavaScript:adBlockCSS completionHandler:nil];
    });
}

%end

// ========== NSURLSession 网络请求拦截 ==========

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                             completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSString *url = request.URL.absoluteString;

    // 拦截广告网络请求
    NSArray *adPatterns = @[@"/ad/", @"/ads/", @"/banner/", @"/track/", @"/analytics/"];

    for (NSString *pattern in adPatterns) {
        if ([url containsString:pattern]) {
            NSLog(@"[AdBlocker] 拦截网络广告请求: %@", url);

            // 返回空数据
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [NSError errorWithDomain:@"AdBlocker"
                                                        code:1
                                                    userInfo:nil];
                    completionHandler(nil, nil, error);
                });
            }

            return nil;
        }
    }

    return %orig;
}

%end

// ========== 构造函数 - 初始化 ==========

%ctor {
    NSLog(@"[AdBlocker] ✓ 广告拦截插件已加载");
    NSLog(@"[AdBlocker] ✓ 正在监控广告 SDK...");
}
