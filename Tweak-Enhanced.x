/**
 * AdBlocker Enhanced - 增强版本
 * 专门针对开屏广告 + APP内广告
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ========== 1. 拦截 UIWindow（开屏广告常用独立窗口）==========

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;

    @try {
        if (![NSThread isMainThread]) {
            return;
        }

        NSString *className = NSStringFromClass([self class]);

        // 检测开屏广告窗口
        NSArray *splashKeywords = @[
            @"Splash",
            @"Launch",
            @"Ad",
            @"Start",
            @"Welcome",
        ];

        BOOL isSplashWindow = NO;
        for (NSString *keyword in splashKeywords) {
            if ([className containsString:keyword]) {
                isSplashWindow = YES;
                break;
            }
        }

        if (isSplashWindow) {
            NSLog(@"[AdBlocker] 检测到开屏广告窗口: %@", className);
            self.hidden = YES;
            self.alpha = 0.0;
        }
    } @catch (NSException *exception) {
        // 静默捕获
    }
}

%end

// ========== 2. 拦截 UIViewController（开屏广告常用模态展示）==========

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    @try {
        if (![NSThread isMainThread]) {
            return;
        }

        NSString *className = NSStringFromClass([self class]);

        // 检测开屏广告视图控制器
        NSArray *adVCKeywords = @[
            @"Splash",
            @"Launch",
            @"Ad",
            @"Start",
            @"Welcome",
            @"GAD",
            @"BU",
            @"GDT",
        ];

        BOOL isAdVC = NO;
        for (NSString *keyword in adVCKeywords) {
            if ([className containsString:keyword]) {
                isAdVC = YES;
                break;
            }
        }

        if (isAdVC) {
            NSLog(@"[AdBlocker] 检测到广告视图控制器: %@", className);

            // 立即隐藏视图
            self.view.hidden = YES;
            self.view.alpha = 0.0;

            // 尝试立即 dismiss
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
    } @catch (NSException *exception) {
        // 静默捕获
    }
}

%end

// ========== 3. 拦截 UIView（APP内广告 + 开屏广告视图）==========

%hook UIView

- (void)didMoveToWindow {
    %orig;

    @try {
        if (![NSThread isMainThread]) {
            return;
        }

        NSString *className = NSStringFromClass([self class]);

        // 扩大检测范围
        NSArray *adKeywords = @[
            @"Ad",              // 通用广告
            @"Banner",          // Banner
            @"Splash",          // 开屏
            @"Launch",          // 启动
            @"GAD",             // Google AdMob
            @"BU",              // 穿山甲
            @"GDT",             // 优量汇
            @"Promotion",       // 推广
            @"Reward",          // 激励
            @"Welcome",         // 欢迎页
        ];

        BOOL isAd = NO;
        for (NSString *keyword in adKeywords) {
            if ([className containsString:keyword]) {
                isAd = YES;
                break;
            }
        }

        // 额外检测：全屏视图可能是开屏广告
        if (!isAd && self.window) {
            CGRect screenBounds = [UIScreen mainScreen].bounds;
            CGRect viewFrame = self.frame;

            // 如果视图接近全屏尺寸
            if (CGRectEqualToRect(viewFrame, screenBounds) ||
                (viewFrame.size.width >= screenBounds.size.width * 0.9 &&
                 viewFrame.size.height >= screenBounds.size.height * 0.9)) {

                // 且类名可疑
                if ([className containsString:@"Image"] ||
                    [className containsString:@"Web"]) {
                    isAd = YES;
                    NSLog(@"[AdBlocker] 检测到可疑全屏视图: %@", className);
                }
            }
        }

        if (isAd) {
            NSLog(@"[AdBlocker] 检测到广告视图: %@", className);

            // 立即隐藏
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
        // 静默捕获
    }
}

%end

// ========== 4. 拦截 UIImageView（开屏广告常用大图）==========

%hook UIImageView

- (void)setImage:(UIImage *)image {
    @try {
        if (![NSThread isMainThread]) {
            %orig;
            return;
        }

        NSString *className = NSStringFromClass([self class]);

        // 检测类名
        NSArray *adKeywords = @[@"Ad", @"Splash", @"Launch", @"Banner"];
        BOOL isAdClass = NO;
        for (NSString *keyword in adKeywords) {
            if ([className containsString:keyword]) {
                isAdClass = YES;
                break;
            }
        }

        // 检测大图（可能是开屏广告）
        if (image && !isAdClass) {
            CGSize imageSize = image.size;
            CGSize screenSize = [UIScreen mainScreen].bounds.size;

            // 如果图片接近屏幕尺寸，可能是开屏广告
            if (imageSize.width >= screenSize.width * 0.8 &&
                imageSize.height >= screenSize.height * 0.8) {
                isAdClass = YES;
                NSLog(@"[AdBlocker] 检测到可疑大图: %@ (%.0fx%.0f)", className, imageSize.width, imageSize.height);
            }
        }

        if (isAdClass) {
            NSLog(@"[AdBlocker] 拦截广告图片: %@", className);
            // 不设置图片
            return;
        }
    } @catch (NSException *exception) {
        // 静默捕获
    }

    %orig;
}

%end

// ========== 构造函数 ==========

%ctor {
    NSLog(@"[AdBlocker] 增强版本已加载 - 支持开屏广告拦截");
}
