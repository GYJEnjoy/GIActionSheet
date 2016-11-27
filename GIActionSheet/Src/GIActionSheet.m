//
//  GIActionSheet.m
//  GIActionSheet
//
//  Created by 高云杰 on 16/9/29.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import "GIActionSheet.h"
#import "GIActionSheetManager.h"
#import "GIActionCell.h"
#import "GIActionHeader.h"
#import "GIActionFooter.h"

#define kActionCellIdentifier   @"ActionCellIdentifier"
#define kActionHeaderIdentifier @"ActionHeaderIdentifier"

@interface GIActionSheet () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    /// 样式
    GIActionSheetStyle _style;
    
    /// 视图容器
    UICollectionView *_collectionView;
    /// 视图容器布局定义
    UICollectionViewFlowLayout *_collectionViewLayout;
    
    /// Action元素数据容器
    NSMutableArray <GIAction *> *_actions;
    
    /// 顶部标题
    GIActionHeader *_header;
    /// 底部取消按钮
    GIActionFooter *_footer;
}

@end

@implementation GIActionSheet
@synthesize actions = _actions;

#pragma mark - init & dealloc
/**
 * 初始化
 * @param style 样式
 */
- (nonnull instancetype)initWithStyle:(GIActionSheetStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _style = style;
        
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.minimumInteritemSpacing = 0;
        _collectionViewLayout.minimumLineSpacing = 0;

        /// 初始化视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.collectionViewLayout = _collectionViewLayout;
        [self addSubview:_collectionView];

        [_collectionView registerClass:[GIActionCell class] forCellWithReuseIdentifier:kActionCellIdentifier];
        
        _actions = [NSMutableArray array];
        [self setCancelable:YES];
        _dismissWhenTapOutside = YES;
    }
    return self;
}

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    return [self initWithStyle:GIActionSheetStyleList];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithStyle:GIActionSheetStyleList];
}

/**
 * 提供简单方式显示组件
 * @param title 标题
 * @param style 样式
 * @param actions 选项
 * @param cancelable 是否可取消
 * @return 实例
 */
+ (nullable instancetype)showWithtitle:(nullable NSString *)title
                                 style:(GIActionSheetStyle)style
                               actions:(nonnull NSArray <GIAction *> *)actions
                            cancelable:(BOOL)cancelable {
    if (actions.count == 0) {
        return nil;
    }
    
    GIActionSheet *sheet = [[GIActionSheet alloc] initWithStyle:style];
    sheet.title = title;
    sheet.cancelable = cancelable;
    sheet.actions = actions;
    [sheet show];
    return sheet;
}

/**
 * 提供简单方式显示组件(List模式)
 * @param title 标题
 * @param actionTitles 选项标题
 * @param cancelable 是否可取消
 * @param onClick 点击了选项
 * @return 实例
 */
+ (nullable instancetype)showAsListWithtitle:(nullable NSString *)title
                                actionTitles:(nonnull NSArray <NSString *> *)actionTitles
                                  cancelable:(BOOL)cancelable
                                     onClick:(void (^ __nonnull)(NSUInteger index))onClick {
    if (actionTitles.count == 0) {
        return nil;
    }
    
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:actionTitles.count];
    [actionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actions addObject:[GIAction actionWithTitle:obj action:^(BOOL * _Nonnull dismiss) {
            if (onClick) {
                onClick(idx);
            }
        }]];
    }];

    return [self showWithtitle:title style:GIActionSheetStyleList actions:actions cancelable:cancelable];
}

/**
 * 提供简单方式显示组件(Grid模式)
 * @param title 标题
 * @param actionTitles 选项标题
 * @param actionIcons 选项图标，数量必须与actionTitles一致
 * @param cancelable 是否可取消
 * @param onClick 点击了选项
 * @return 实例
 */
+ (nullable instancetype)showAsGridWithtitle:(nullable NSString *)title
                                actionTitles:(nonnull NSArray <NSString *> *)actionTitles
                                 actionIcons:(nonnull NSArray <UIImage *> *)actionIcons
                                  cancelable:(BOOL)cancelable
                                     onClick:(void (^ __nonnull)(NSUInteger index))onClick {
    if (actionTitles.count == 0 || actionTitles.count != actionIcons.count) {
        return nil;
    }
    
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:actionTitles.count];
    [actionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actions addObject:[GIAction actionWithTitle:obj icon:actionIcons[idx] action:^(BOOL * _Nonnull dismiss) {
            if (onClick) {
                onClick(idx);
            }
        }]];
    }];
    
    return [self showWithtitle:title style:GIActionSheetStyleGrid actions:actions cancelable:cancelable];
}

#pragma mark - 视图显示与更新
/**
 * 显示
 * @param onCompleted 显示完成后执行
 */
- (void)show:(GIOnShown _Nullable)onCompleted {
    self.onShown = onCompleted;
    [self show];
}

/**
 * 显示
 */
- (void)show {
    // 入队列
    [[GIActionSheetManager sharedInstance] pushActionSheet:self];
}

/**
 * 去除显示，同时会释放相关资源。去除后，不能再次调用show进行显示。
 * @param animated 是否显示动画效果
 * @param onCompleted animated为YES时，动画结束后调用；animated为NO时，直接调用
 */
- (void)dismissAnimated:(BOOL)animated onCompleted:(void(^ _Nullable)())onCompleted {
    self.onDismissed = onCompleted;
    [self dismissAnimated:animated];
}


/**
 * 去除显示，同时会释放相关资源。去除后，不能再次调用show进行显示。
 * @param animated 是否显示动画效果
 */
- (void)dismissAnimated:(BOOL)animated {
    if (animated) {
        [self doDismissAnimation:^{
            [self removeFromSuperview];
            [[GIActionSheetManager sharedInstance] popActionSheet:self];
        }];
    } else {
        [self removeFromSuperview];
        [[GIActionSheetManager sharedInstance] popActionSheet:self];
    }
}

/**
 * 通知更新UI
 */
- (void)setNeedsUpdateActionSheet {
    if (self.superview) {
        // 已经添加到父视图上，更新视图
        CGFloat containerWidth = CGRectGetWidth(self.superview.frame);
        CGFloat containerHeight = CGRectGetHeight(self.superview.frame);
        
        // 标题栏Frame计算
        CGSize size = [_header sizeThatFits:CGSizeMake(containerWidth, 60)];
        _header.frame = CGRectMake(0, 0, containerWidth, size.height);
        
        // 内容Frame计算
        if (_style == GIActionSheetStyleList) {
            _collectionView.frame = CGRectMake(0, CGRectGetMaxY(_header.frame), containerWidth, _actions.count * LIST_CELL_HEIGHT);
        } else if (_style == GIActionSheetStyleGrid) {
            
            // 内容区域宽度
            CGFloat girdContainerWidth = containerWidth - _collectionViewLayout.sectionInset.left - _collectionViewLayout.sectionInset.right;
            
            // 计算列数和行数
            NSUInteger columnCount = girdContainerWidth / GRID_CELL_WIDTH;
            NSUInteger rowCount = (_actions.count + columnCount - 1) / columnCount;
            
            // 内容区域高度
            CGFloat girdHeight = rowCount * GRID_CELL_HEIGHT + _collectionViewLayout.sectionInset.top + _collectionViewLayout.sectionInset.bottom;

            _collectionView.frame = CGRectMake(0, CGRectGetMaxY(_header.frame), containerWidth, girdHeight);
        }
        [_collectionView reloadData];
        
        // 取消按钮
        _footer.frame = CGRectMake(0, CGRectGetMaxY(_collectionView.frame), containerWidth, 50);
        
        CGFloat viewHeight = CGRectGetMaxY(_footer ? _footer.frame : _collectionView.frame);
        if (CGRectIsEmpty(self.frame)) {
            // 初始化视图位置，正确显示动画
            self.frame = CGRectMake(0, containerHeight, containerWidth, viewHeight);
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, containerHeight - viewHeight, containerWidth, viewHeight);
        }];
    }
}

#pragma mark - 动画
/**
 * 执行显示
 * @param container 容器
 */
- (void)doShowInView:(UIView *)container {
    if (!container) {
        return;
    }
    if (_style == GIActionSheetStyleGrid) {
        // 九宫格显示
        _collectionViewLayout.sectionInset = GRID_CONTENT_PADDING;
        _collectionViewLayout.itemSize = CGSizeMake(GRID_CELL_WIDTH, GRID_CELL_HEIGHT);
    } else {
        // 列表显示
        _collectionViewLayout.sectionInset = UIEdgeInsetsZero;
        _collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(container.frame), LIST_CELL_HEIGHT);
    }

    [container addSubview:self];
    [self setNeedsUpdateActionSheet];
}

/// 执行完成动画
- (void)doDismissAnimation:(void (^)())onAnimationFinished {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame), CGRectGetWidth(self.superview.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        if (onAnimationFinished) {
            onAnimationFinished();
        }
    }];
}

#pragma mark - UICollectionView delegate&datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _actions.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GIActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kActionCellIdentifier forIndexPath:indexPath];
    cell.action = [_actions objectAtIndex:indexPath.row];
    cell.style = _style;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    GIAction *action = [_actions objectAtIndex:indexPath.row];
    if (action.onClick) {
        BOOL shouldDismiss = YES;
        action.onClick(&shouldDismiss);
        if (shouldDismiss) {
            [self dismissAnimated:YES];
        }
    } else {
        [self dismissAnimated:YES];
    }
}
#pragma mark - Action管理与更新
- (void)setTitle:(NSString *)title {
    _title = title;
    if (_title.length > 0) {
        if (!_header) {
            _header = [[GIActionHeader alloc] init];
            [self addSubview:_header];
        }
        _header.titleLabel.text = _title;
    } else {
        [_header removeFromSuperview];
        _header = nil;
    }
    [self setNeedsUpdateActionSheet];
}

- (void)setCancelable:(BOOL)cancelable {
    _cancelable = cancelable;
    if (_cancelable) {
        if (!_footer) {
            _footer = [[GIActionFooter alloc] init];
            if (_cancelTitle.length > 0) {
                [_footer.cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
            } else {
                _cancelTitle = _footer.cancelButton.currentTitle;
            }
            [_footer.cancelButton addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_footer];
        }
    } else {
        [_footer removeFromSuperview];
        _footer = nil;
    }
    [self setNeedsUpdateActionSheet];
}

- (void)setCancelTitle:(NSString *)cancelTitle {
    if (cancelTitle.length > 0) {
        _cancelTitle = cancelTitle;
        [_footer.cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
    }
}

/// 取消按钮点击
- (void)cancelBtnClicked:(id)sender {
    [self dismissAnimated:YES];
}

/**
 * 更新显示
 */
- (void)setActions:(NSArray<GIAction *> *)actions {
    _actions = actions ? [actions mutableCopy] : [NSMutableArray array];
    [self setNeedsUpdateActionSheet];
}

/**
 * 新增元素，支持在视图显示后调用，以更新UI。
 * @param action 元素
 * @return action为nil时，返回NO。
 */
- (BOOL)addAction:(GIAction * _Nonnull)action {
    if (!action) return NO;
    
    [_actions addObject:action];
    [self setNeedsUpdateActionSheet];
    return YES;
}

/**
 * 新增元素，支持在视图显示后调用，以更新UI。
 * @param action 元素
 * @param index 索引位置
 * @return action为nil，或index越界时，返回NO。
 */
- (BOOL)addAction:(GIAction * _Nonnull)action atIndex:(NSUInteger)index {
    if (!action || index > _actions.count) return NO;
    
    [_actions insertObject:action atIndex:index];
    [self setNeedsUpdateActionSheet];
    return YES;
}

/**
 * 替换元素，支持在视图显示后调用，以更新UI。
 * @param action 元素
 * @param index 索引位置
 * @return action为nil，或index越界时，返回NO。
 */
- (BOOL)setAction:(GIAction * _Nonnull)action atIndex:(NSUInteger)index {
    if (!action || index > _actions.count) return NO;
    
    (index == _actions.count) ? [_actions replaceObjectAtIndex:index withObject:action] : [_actions addObject:action];
    
    [self setNeedsUpdateActionSheet];
    return YES;
}

/**
 * 删除元素，支持在视图显示后调用，以更新UI。
 * @param index 索引位置
 * @return index越界时，返回NO。
 */
- (GIAction * _Nonnull)removeActionAtIndex:(NSUInteger)index {
    if (index >= _actions.count) return nil;
    GIAction *removedAction = [_actions objectAtIndex:index];
    [_actions removeObjectAtIndex:index];
    [self setNeedsUpdateActionSheet];
    return removedAction;
}

/**
 * 删除元素，支持在视图显示后调用，以更新UI。
 * @param action Action元素
 * @return 移除成功时，返回Action元素的索引，否则返回NSNotFound，。
 */
- (NSUInteger)removeAction:(GIAction * _Nonnull)action {
    if (!action) return NSNotFound;
    NSUInteger removedIndex = [_actions indexOfObject:action];
    [_actions removeObject:action];
    [self setNeedsUpdateActionSheet];
    return removedIndex;
}
@end
