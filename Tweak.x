/**
 * AdBlocker Test - 测试版本
 * 用于验证 dylib 是否被正确加载
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ========== 测试：启动时弹窗 ==========

%hook UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;

    // 延迟显示弹窗，确保应用启动完成
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"AdBlocker 已加载"
            message:@"广告拦截插件正在运行中！\n如果看到这个弹窗，说明注入成功。"
            preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction
            actionWithTitle:@"知道了"
            style:UIAlertActionStyleDefault
            handler:nil];

        [alert addAction:ok];

        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (rootVC) {
            [rootVC presentViewController:alert animated:YES completion:nil];
        }
    });

    return result;
}

%end

// ========== 调试：记录所有 UIView 子类 ==========

static NSMutableSet *loggedClasses = nil;

%hook UIView

+ (void)initialize {
    %orig;
    if (!loggedClasses) {
        loggedClasses = [NSMutableSet new];
    }
}

- (void)didMoveToWindow {
    %orig;

    @try {
        NSString *className = NSStringFromClass([self class]);

        // 只记录前100个不同的类，避免刷屏
        if (loggedClasses.count < 100 && ![loggedClasses containsObject:className]) {
            [loggedClasses addObject:className];
            NSLog(@"[AdBlocker] 发现视图类: %@", className);
        }

        // 检测广告（扩大检测范围）
        NSArray *adKeywords = @[
            @"Ad",              // 包含 Ad
            @"Banner",          // Banner
            @"GAD",             // Google AdMob
            @"BU",              // 穿山甲
            @"GDT",             // 优量汇
            @"Splash",          // 开屏广告
        ];

        for (NSString *keyword in adKeywords) {
            if ([className containsString:keyword]) {
                NSLog(@"[AdBlocker] ⚠️ 检测到可能的广告: %@", className);

                // 添加红色边框，方便识别
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.layer.borderColor = [UIColor redColor].CGColor;
                    self.layer.borderWidth = 3.0;

                    // 3秒后隐藏
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        self.hidden = YES;
                        self.alpha = 0;
                    });
                });

                break;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"[AdBlocker] 异常: %@", exception);
    }
}

%end

// ========== 构造函数 ==========

%ctor {
    NSLog(@"[AdBlocker] ========================================");
    NSLog(@"[AdBlocker] ✓ 测试版本已加载");
    NSLog(@"[AdBlocker] ✓ 将在应用启动后显示弹窗");
    NSLog(@"[AdBlocker] ✓ 会记录所有视图类名");
    NSLog(@"[AdBlocker] ✓ 广告会显示红色边框，3秒后隐藏");
    NSLog(@"[AdBlocker] ========================================");
}
