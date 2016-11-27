//
//  GIAction.h
//  GIActionSheet
//
//  Created by 高云杰 on 16/9/29.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GIAction;

/**
 * 点击元素时出发
 * @param dismiss 是否去除视图，默认为YES
 */
typedef void (^GIOnActionClick)(BOOL * _Nonnull dismiss);

@interface GIAction : NSObject
/**
 * 创建实例
 * @param title 标题
 * @param onClick 点击回调
 * @return 实例
 */
+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title action:(nonnull GIOnActionClick)onClick;

/**
 * 创建实例
 * @param title 标题
 * @param icon 图标
 * @param onClick 点击回调
 * @return 实例
 */
+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title icon:(nullable UIImage *)icon action:(nonnull GIOnActionClick)onClick;

/// 动作元素
@property (nonatomic, copy, nonnull) GIOnActionClick onClick;
/// 标题
@property (nonatomic, copy, nonnull) NSString *title;
/// 图标（当GIActionSheet.style == ActionSheetStyleGrid时，icon 不应为nil）
@property (nonatomic, strong, nullable) UIImage *icon;

#pragma mark - status定义
/// 是否可点击
@property (nonatomic, assign) BOOL enabled;

#pragma mark - style定义
@property (nonatomic, strong, nullable) UIColor *normalTitleColor;
@property (nonatomic, strong, nullable) UIColor *disableTitleColor;
@property (nonatomic, strong, nullable) UIFont *titleFont;
@end
