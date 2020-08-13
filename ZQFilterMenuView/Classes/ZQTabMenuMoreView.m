//
//  ZQTabMenuMoreView.m
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//


#import "ZQTabMenuMoreView.h"
#import "ZQTabMenuMoreCollCell.h"
#import "ZQTabMenuMoreColHeaderView.h"
#import "ZQTabMenuEnsureView.h"
#import "ZQTabMenuMoreFilterData.h"
#import <Masonry/Masonry.h>
#import <ZQFoundationKit/UIColor+Util.h>
#import "ZQFliterModelHeader.h"
#import "DoubleSliderView.h"
#import "UIView+Extension.h"

@interface ZQTabMenuMoreView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *moreCollectionView;

/// 是否要恢复上次选择
@property (nonatomic, assign) BOOL isResetStore;

@property (nonatomic, strong) ZQTabMenuEnsureView *ensureView;

@property (nonatomic, strong) UIView *sliderBgView;
@property (nonatomic, strong) UILabel *tipLbl;
@property (nonatomic, strong) UILabel *leftLbl;
@property (nonatomic, strong) UILabel *rightLbl;
@property (nonatomic, strong) UILabel *topLbl;

@property (nonatomic, assign) NSInteger minAge;
@property (nonatomic, assign) NSInteger maxAge;
@property (nonatomic, assign) NSInteger curMinAge;
@property (nonatomic, assign) NSInteger curMaxAge;

@property (nonatomic, strong) DoubleSliderView *doubleSliderView;

@property (nonatomic, strong) ZQTabMenuMoreFilterData *fliterData;

@end

@implementation ZQTabMenuMoreView
#define GAP  20
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         [self creatUI];
    }
    return self;
}

- (ZQTabMenuMoreFilterData *)fliterData{
    if (!_fliterData) {
        _fliterData = [[ZQTabMenuMoreFilterData alloc]init];
    }
    return _fliterData;
}

-(UIView *)sliderBgView{
    if (!_sliderBgView) {
        _sliderBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZQScreenWidth, 115)];
        _sliderBgView.backgroundColor = [UIColor whiteColor];
    }
    return _sliderBgView;
}

-(UILabel *)tipLbl{
    if (!_tipLbl) {
        _tipLbl = [[UILabel alloc] init];
        _tipLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _tipLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _tipLbl.text = @"价格";
    }
    return _tipLbl;;
}

-(UILabel *)leftLbl{
    if (!_leftLbl) {
        _leftLbl = [[UILabel alloc] init];
        _leftLbl.textColor = [UIColor colorWithHexString:@"687CA4"];
        _leftLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _leftLbl.text = @"¥0";
    }
    return _leftLbl;;
}

-(UILabel *)rightLbl{
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] init];
        _rightLbl.textColor = [UIColor colorWithHexString:@"687CA4"];
        _rightLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _rightLbl.text = @"¥1000以上";
    }
    return _rightLbl;;
}

-(UILabel *)topLbl{
    if (!_topLbl) {
        _topLbl = [[UILabel alloc] init];
        _topLbl.textColor = [UIColor colorWithHexString:@"3D7CF5"];
        _topLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _topLbl.text = @"";
    }
    return _topLbl;;
}

- (DoubleSliderView *)doubleSliderView {
    if (!_doubleSliderView) {
        _doubleSliderView = [[DoubleSliderView alloc] initWithFrame:CGRectMake(20, 60, ZQScreenWidth - 40, 35)];
        _doubleSliderView.needAnimation = true;
        __weak typeof(self) weakSelf = self;
        _doubleSliderView.sliderBtnLocationChangeBlock = ^(BOOL isLeft, BOOL finish) {
            [weakSelf sliderValueChangeActionIsLeft:isLeft finish:finish];
        };
    }
    return _doubleSliderView;
}

#pragma mark - action
//根据值获取整数

- (CGFloat)fetchIntFromValue:(CGFloat)value {
    CGFloat newValue = floorf(value);
    CGFloat changeValue = value - newValue;
    if (changeValue >= 0.5) {
        newValue = newValue + 1;
    }
    return newValue;
}

- (void)sliderValueChangeActionIsLeft: (BOOL)isLeft finish: (BOOL)finish {
    if (isLeft) {
        CGFloat age = (self.maxAge - self.minAge) * self.doubleSliderView.curMinValue;
        CGFloat tmpAge = [self fetchIntFromValue:age];
        self.curMinAge = (NSInteger)tmpAge + self.minAge;
        [self changeAgeTipsText];
    }else {
        CGFloat age = (self.maxAge - self.minAge) * self.doubleSliderView.curMaxValue;
        CGFloat tmpAge = [self fetchIntFromValue:age];
        self.curMaxAge = (NSInteger)tmpAge + self.minAge;
        [self changeAgeTipsText];
    }
    if (finish) {
        [self changeSliderValue];
    }
}

//值取整后可能改变了原始的大小，所以需要重新改变滑块的位置
- (void)changeSliderValue {
    CGFloat finishMinValue = (CGFloat)(self.curMinAge - self.minAge)/(CGFloat)(self.maxAge - self.minAge);
    CGFloat finishMaxValue = (CGFloat)(self.curMaxAge - self.minAge)/(CGFloat)(self.maxAge - self.minAge);
    self.doubleSliderView.curMinValue = finishMinValue;
    self.doubleSliderView.curMaxValue = finishMaxValue;
    [self.doubleSliderView changeLocationFromValue];
}

- (void)changeAgeTipsText {
    if (self.curMinAge == self.curMaxAge) {
        if (self.curMinAge == 0) {
            self.topLbl.text = @"";
        }
        else{
            self.topLbl.text = [NSString stringWithFormat:@"￥%li", self.curMinAge];
        }
        
    }else {
        self.topLbl.text = [NSString stringWithFormat:@"￥%li~%li", self.curMinAge, self.curMaxAge];
    }
}


- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    ZQWS(weakSelf);
    CGFloat bottomViewH = 47;
    self.ensureView = [[ZQTabMenuEnsureView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.ensureView];
    [self.ensureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(bottomViewH);
    }];
    self.ensureView.clickAction = ^(NSInteger tag) {
        if (tag == 1) { // 重置
            [weakSelf retSetAction];
        }else{ // 确定
            [weakSelf ensureAction];
        }
    };
    
    self.minAge = 0;
    self.maxAge = 1000;
    self.curMinAge = 0;
    self.curMaxAge = 1000;
    
    [self configSlider];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.minimumLineSpacing = 8;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 16, 8, 16);
    _moreCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _moreCollectionView.showsHorizontalScrollIndicator = NO;
    _moreCollectionView.backgroundColor = [UIColor whiteColor];
    _moreCollectionView.delegate = self;
    _moreCollectionView.dataSource = self;
    _moreCollectionView.scrollEnabled = YES;
    _moreCollectionView.pagingEnabled = NO;
    [_moreCollectionView registerClass:[ZQTabMenuMoreCollCell class] forCellWithReuseIdentifier:@"ZQTabMenuMoreCollCell"];
    [_moreCollectionView registerClass:[ZQTabMenuMoreColHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQTabMenuMoreColHeaderView"];
    [self addSubview:_moreCollectionView];
    [_moreCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ensureView.mas_top);
        make.left.right.equalTo(self);
        make.top.equalTo(self.sliderBgView.mas_bottom);
    }];
}

-(void)configSlider{
    
    [self addSubview:self.sliderBgView];
    [self.sliderBgView addSubview:self.tipLbl];
    [self.sliderBgView addSubview:self.leftLbl];
    [self.sliderBgView addSubview:self.rightLbl];
    [self.sliderBgView addSubview:self.topLbl];
    [self.sliderBgView addSubview:self.doubleSliderView];
    
    [self.tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
    [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.tipLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(18);
    }];
    
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.leftLbl);
    }];
    
    [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLbl.mas_right).offset(6);
        make.centerY.equalTo(self.tipLbl);
    }];
    
    [self.doubleSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.leftLbl.mas_bottom);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - Setter
- (void)setListDataSource:(NSArray<ZQItemModel *> *)ListDataSource{
    _ListDataSource = ListDataSource;
    [self.fliterData setListDataSource:ListDataSource];
    [self setTabControlTitle];
    [self.moreCollectionView reloadData];
}

- (void)resetChoiceReload{
    [self.fliterData resetChoiceReloadDataSource:self.ListDataSource];
    [self.moreCollectionView reloadData];
}

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
}

#pragma mark - Public Method
- (void)tabMenuViewWillAppear{
    [self resetChoiceReload];
}

- (void)tabMenuViewWillDisappear{
    
}

#pragma mark - Action Method
- (void)retSetAction{
    [self.fliterData removeAllSelectData];
    [self.moreCollectionView reloadData];
}

- (void)ensureAction{
    [self.fliterData setLastSelectedDataSource:self.ListDataSource];
    [self setTabControlTitle];
    if (self.selectBlock) {
        self.selectBlock(self,self.fliterData.lastMoreSeletedDic,self.fliterData.moreSeletedDic,self.curMinAge,self.curMaxAge);
    }
}

#pragma mark - Private Method
/// 设置选中状态
- (void)setTabControlTitle{
    [self.tabControl setControlTitleStatus:[self.fliterData isHadSelected] title:self.tabControl.title selTitle:self.tabControl.title];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.ListDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ZQItemModel *model = self.ListDataSource[section];
    NSArray *models = model.dataSource;
    return models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQTabMenuMoreCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZQTabMenuMoreCollCell" forIndexPath:indexPath];
    cell.styleColor = self.styleColor;
    cell.didSelectBgColor = self.didSelectBgColor;
    cell.didUnSelectBgColor = self.didUnSelectBgColor;
    ZQItemModel *itemModel = self.ListDataSource[indexPath.section];
    ZQItemModel *model = itemModel.dataSource[indexPath.row];
    NSMutableArray *arr = self.fliterData.moreSeletedDic[ZQNullClass(itemModel.currentID)];
    cell.titleLabel.text = model.displayText;
    if ([arr containsObject:model]) {
        cell.isChoice = YES;
    }else{
        cell.isChoice = NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQItemModel *itemModel = self.ListDataSource[indexPath.section];
    ZQItemModel *model = itemModel.dataSource[indexPath.row];
    NSMutableArray *arr = self.fliterData.moreSeletedDic[ZQNullClass(itemModel.currentID)];
    if (itemModel.selectMode == 0) {// 单选
        if (model.selectMode != 1) {
            [self.fliterData removeAllExtenFixModel:arr selectModel:model];
        }
        [self.fliterData selectModel:model arr:arr];
    }else { //复选
        [self.fliterData selectModel:model arr:arr];
    }
    [self.fliterData.moreSeletedDic setObject:arr forKey:ZQNullClass(itemModel.currentID)];
    [self.moreCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ZQTabMenuMoreColHeaderView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        ZQTabMenuMoreColHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQTabMenuMoreColHeaderView" forIndexPath:indexPath];
        ZQItemModel *model = self.ListDataSource[indexPath.section];
        headerView.titleLabel.text = model.displayText;
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    size = CGSizeMake((ZQScreenWidth - 72) / 4.0, 34);
    return size;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ZQScreenWidth, 40);
}

@end
