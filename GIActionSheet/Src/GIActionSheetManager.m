//
//  GIActionSheetManager.m
//  GIActionSheet
//
//  Created by 高云杰 on 16/10/1.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import "GIActionSheetManager.h"
#import "GIActionSheet.h"

@interface GIActionSheet (quere)
/**
 * 执行显示
 * @param container 容器
 */
- (void)doShowInView:(UIView *)container;

/// 执行完成动画
- (void)doDismissAnimation:(void (^)())onAnimationFinished;
@end

@interface GIActionSheetManager () {
    /// 视图对战
    NSMutableArray *_actionSheetQueue;
    
    /// 当前显示组件
    GIActionSheet *_shownActionSheet;
    
    /// 背景色控制
    UIImageView *_bgImageView;
    /// 容器
    UIWindow *_container;
    
    /// 用于恢复应用窗口
    UIWindow *_preWindow;
}
@end

@implementation GIActionSheetManager

#pragma mark - 单例
/// 单例
+ (nonnull instancetype)sharedInstance {
    static GIActionSheetManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (nonnull instancetype) init {
    if (self = [super init]) {
        _actionSheetQueue = [NSMutableArray array];
        
        _container = [[UIWindow alloc] init];
        _container.windowLevel = UIWindowLevelStatusBar;
        _container.backgroundColor = [UIColor clearColor];
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _bgImageView.userInteractionEnabled = YES;
        [_container addSubview:_bgImageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapped:)];
        [_bgImageView addGestureRecognizer:gesture];
    }
    return self;
}

/// 点击了背景
- (void)bgViewTapped:(id)sender {
    if (_shownActionSheet) {
        if (_shownActionSheet.dismissWhenTapOutside && _shownActionSheet.cancelable) {
            [_shownActionSheet dismissAnimated:YES];
        }
    } else {
        [self dimissContainer];
    }
}

#pragma mark - 背景窗口控制
- (void)showContainer {
    if (_container == [UIApplication sharedApplication].keyWindow) {
        return;
    }
    _preWindow = [UIApplication sharedApplication].keyWindow;

    _bgImageView.frame = _container.bounds;
    
    _container.alpha = 0;
    [_container setHidden:NO];
    
    [_container makeKeyAndVisible];
    [UIView animateWithDuration:0.2 animations:^{
        _container.alpha = 1;
    } completion:NULL];
}

- (void)dimissContainer {
    // 恢复KeyWindow
    [_preWindow makeKeyWindow];
    _preWindow = nil;
    
    // 隐藏ActionSheet的Window
    [UIView animateWithDuration:0.1 animations:^{
        _container.alpha = 0;
    } completion:^(BOOL finished) {
        [_container setHidden:YES];
    }];
}

#pragma mark - 视图堆栈控制
/**
 * 显示。如果当前已经有组件处于显示状态，显示当前新的组件，把前一个显示的组件压入堆栈。
 * @param actionSheet 需要显示的actionSheet
 */
- (void)pushActionSheet:(nonnull GIActionSheet *)actionSheet {
    if (!actionSheet) return;
    
    // 如果已有正在显示的ActionSheet，则隐藏显示，并压入堆栈
    if (_shownActionSheet) {
        [_shownActionSheet doDismissAnimation:^{
            [_shownActionSheet removeFromSuperview];
            _shownActionSheet = nil;
            [_actionSheetQueue addObject:actionSheet];
            [self popAndShowActionSheet];
        }];
    } else {
        [_actionSheetQueue addObject:actionSheet];
        [self popAndShowActionSheet];
    }
}

/**
 * 去除。
 * @param actionSheet 已去除显示的actionSheet
 */
- (void)popActionSheet:(nonnull GIActionSheet *)actionSheet {
    if (!actionSheet) return;

    [_actionSheetQueue removeObject:actionSheet];
    _shownActionSheet = nil;
    
    // 从堆栈中查找是否有待显示的ActionSheet
    [self popAndShowActionSheet];
}

/**
 * 从堆栈中取出顶部组件并显示，如果为空时，返回nil
 * @return 即将显示的组件
 */
- (nullable GIActionSheet *)popAndShowActionSheet {
    GIActionSheet *sheet = [_actionSheetQueue lastObject];
    _shownActionSheet = sheet;
    if (_shownActionSheet) {
        RUN_ON_MAIN_THREAD(^{
            [self showContainer];
            [sheet doShowInView:_container];
        });
    } else {
        // 没有ActionSheet处于显示状态，则去除背景
        [self dimissContainer];
    }
    return sheet;
}
@end
