//
//  ZQTabMenuEnsureView.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import "ZQTabMenuEnsureView.h"
#import "ZQSeperateLine.h"
#import "ZQFliterModelHeader.h"
#import <ZQFoundationKit/UIColor+Util.h>
#import <Masonry/Masonry.h>
@interface ZQTabMenuEnsureView()
@property (strong, nonatomic) UIButton *resetBtn;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (nonatomic, strong) ZQSeperateLine *topLine;
@end

@implementation ZQTabMenuEnsureView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         [self creatUI];
    }
    return self;
}

- (ZQSeperateLine *)topLine {
    if (!_topLine) {
        _topLine = [[ZQSeperateLine alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    }
    return _topLine;
}


#define GAP  20
- (void)creatUI{
    CGFloat heigth = 47;
    self.backgroundColor = [UIColor whiteColor];
    //重置按鈕
    UIButton *resetBtn = [self creatButtonTitle:@"重置" color:[UIColor colorWithHexString:@"687CA4"] fontSize:16 target:self action:@selector(btnAction:)];
    resetBtn.backgroundColor = [UIColor whiteColor];
    resetBtn.tag = 1;
    [self addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(heigth);
        make.width.mas_equalTo((ZQScreenWidth / 3.0));
        make.centerY.equalTo(self);
    }];
    self.resetBtn = resetBtn;
    
    //確定按鈕
    UIButton *confirmBtn = [self creatButtonTitle:@"确定" color:[UIColor whiteColor] fontSize:16 target:self action:@selector(btnAction:)];
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"3D7CF5"];
    confirmBtn.tag = 2;
    [self addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.bottom.equalTo(resetBtn);
        make.width.mas_equalTo(2 * (ZQScreenWidth / 3.0));
    }];
    self.confirmBtn = confirmBtn;
    [self addSubview:self.topLine];
}

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    self.confirmBtn.backgroundColor = styleColor;
    [self.resetBtn setTitleColor:styleColor forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:styleColor forState:UIControlStateSelected];
}


#pragma mark - Private Method
- (UIButton *)creatButtonTitle:(NSString *)title
                         color:(UIColor *)color
                      fontSize:(CGFloat)size
                        target:(id)target
                        action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(title)[btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    if(color)[btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)btn{
    if (self.clickAction) {
        self.clickAction(btn.tag);
    }
}

@end
