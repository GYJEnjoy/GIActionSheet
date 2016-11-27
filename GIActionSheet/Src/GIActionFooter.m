//
//  GIActionFooter.m
//  GIActionSheet
//
//  Created by 高云杰 on 16/10/4.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import "GIActionFooter.h"
@interface GIActionFooter() {
    
}
@end

@implementation GIActionFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cancelButton.frame = self.bounds;
}

@end
