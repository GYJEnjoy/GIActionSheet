//
//  GIActionSheet.h
//  GIActionSheet
//
//  Created by 高云杰 on 16/9/29.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIDefine.h"
#import "GIAction.h"

/// 显示回调Block
typedef void (^GIOnShown)();
/// 去除回调Block
typedef void (^GIOnDismissed)();

@interface GIActionSheet : UIView

#pragma mark - property
/// 标题
@property (nonatomic, copy, nullable) NSString *title;
/// 是否可取消，默认为YES
@property (nonatomic, assign) BOOL cancelable;
/// 取消按钮标题(cancelable为YES时有效）
@property (nonatomic, copy, nullable) NSString* cancelTitle;
/// 点击外部区域时，是否去除试图，默认为YES（cancelable为NO时，此属性无效）
@property (nonatomic, assign) BOOL dismissWhenTapOutside;

@property (nonatomic, copy, nullable) GIOnShown onShown;
@property (nonatomic, copy, nullable) GIOnDismissed onDismissed;

/// 显示样式
@property (nonatomic, assign, readonly) GIActionSheetStyle style;

/// 每行显示的动作元素数量,为0时自适应。(style为ActionSheetStyleGrid时有效)
@property (nonatomic, assign) NSUInteger numberOfColumns;
/// 行高, 为0时自适应。(style为ActionSheetStyleGrid时有效)
@property (nonatomic, assign) CGFloat rowHeight;
/// 对齐方式.(style为ActionSheetStyleList时有效)
@property (nonatomic, assign) NSTextAlignment titleAlignment;

/// 设置元素
@property (nonatomic, strong, nonnull) NSArray <GIAction *> *actions;

#pragma mark - 视图显示与更新
/**
 * 初始化
 * @param style 样式
 */
- (nonnull instancetype)initWithStyle:(GIActionSheetStyle)style NS_DESIGNATED_INITIALIZER;

/**
 * 显示
 * @param onCompleted 显示完成后执行
 */
- (void)show:(GIOnShown _Nullable)onCompleted;

/**
 * 显示
 */
- (void)show;

/**
 * 去除显示，同时会释放相关资源。去除后，不能再次调用show进行显示。
 * @param animated 是否显示动画效果
 * @param onCompleted animated为YES时，动画结束后调用；animated为NO时，直接调用
 */
- (void)dismissAnimated:(BOOL)animated onCompleted:(GIOnDismissed _Nullable)onCompleted;

/**
 * 去除显示，同时会释放相关资源。去除后，不能再次调用show进行显示。
 * @param animated 是否显示动画效果
 */
- (void)dismissAnimated:(BOOL)animated;

#pragma mark - Action管理与更新
/**
 * 新增元素，支持在视图显示后调用，以更新UI。
 * @param action 元素
 * @return action为nil时，返回NO。
 */
- (BOOL)addAction:(GIAction * _Nonnull)action;

/**
 * 新增元素，支持在视图显示后调用，以更新UI。
 * @param action 元素
 * @param index 索引位置
 * @return action为nil，或index越界时，返回NO。
 */
- (BOOL)addAction:(GIAction * _Nonnull)action atIndex:(NSUInteger)index;

/**
 * 替换元素，支持在视图显示后调用，以更新UI。
 * @param action 元素
 * @param index 索引位置
 * @return action为nil，或index越界时，返回NO。
 */
- (BOOL)setAction:(GIAction * _Nonnull)action atIndex:(NSUInteger)index;

/**
 * 删除元素，支持在视图显示后调用，以更新UI。
 * @param index 索引位置
 * @return 被移除的Action
 */
- (GIAction * _Nonnull)removeActionAtIndex:(NSUInteger)index;

/**
 * 删除元素，支持在视图显示后调用，以更新UI。
 * @param action Action元素
 * @return 移除成功时，返回Action元素的索引，否则返回NSNotFound，。
 */
- (NSUInteger)removeAction:(GIAction * _Nonnull)action;
@end
