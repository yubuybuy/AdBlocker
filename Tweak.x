/**
 * AdBlocker Safe - TrollFools 安全版本
 * 最小化设计，避免闪退
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ========== 通用广告视图拦截（安全版本）==========

%hook UIView

- (void)didMoveToWindow {
    %orig;

    @try {
        // 检测可能是广告的视图
        NSString *className = NSStringFromClass([self class]);

        // 常见广告 SDK 类名特征（保守检测）
        NSArray *adKeywords = @[
            @"GADBanner",           // Google AdMob Banner
            @"GADNative",           // Google AdMob Native
            @"BUBanner",            // 穿山甲 Banner
            @"BUNativeExpress",     // 穿山甲原生
            @"GDTUnified",          // 优量汇
            @"AdView",              // 通用广告视图
            @"BannerView",          // Banner 广告
            @"AdContainer"          // 广告容器
        ];

        for (NSString *keyword in adKeywords) {
            if ([className containsString:keyword]) {
                NSLog(@"[AdBlocker] 检测到广告视图: %@", className);

                // 安全地隐藏
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.hidden = YES;
                    self.alpha = 0;
                    [self removeFromSuperview];
                });

                break;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"[AdBlocker] 捕获异常: %@", exception);
    }
}

%end

// ========== 构造函数 ==========

%ctor {
    NSLog(@"[AdBlocker] ✓ 安全版本已加载");
}
