/**
 * AdBlocker Simple - 超简单稳定版本
 * 移除所有可能导致崩溃的功能
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ========== 只做一件事：隐藏广告 ==========

%hook UIView

- (void)didMoveToWindow {
    %orig;

    @try {
        // 只在主线程检查
        if (![NSThread isMainThread]) {
            return;
        }

        NSString *className = NSStringFromClass([self class]);

        // 扩大检测范围（因为您看到红色边框了，说明检测是有效的）
        NSArray *adKeywords = @[
            @"Ad",              // 通用广告
            @"Banner",          // Banner
            @"Splash",          // 开屏
            @"GAD",             // Google AdMob
            @"BU",              // 穿山甲
            @"GDT",             // 优量汇
            @"Promotion",       // 推广
            @"Reward",          // 激励
        ];

        BOOL isAd = NO;
        for (NSString *keyword in adKeywords) {
            if ([className containsString:keyword]) {
                isAd = YES;
                break;
            }
        }

        if (isAd) {
            NSLog(@"[AdBlocker] 检测到广告: %@", className);

            // 立即隐藏，不延迟
            self.hidden = YES;
            self.alpha = 0.0;

            // 尝试从父视图移除
            if (self.superview) {
                [self removeFromSuperview];
            }

            // 尝试设置高度为0
            if ([self.constraints count] > 0) {
                for (NSLayoutConstraint *constraint in self.constraints) {
                    if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                        constraint.constant = 0;
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        // 静默捕获，不输出日志避免影响性能
    }
}

%end

// ========== 构造函数 ==========

%ctor {
    NSLog(@"[AdBlocker] 简单版本已加载");
}
