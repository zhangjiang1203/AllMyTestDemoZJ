//
//  SegmentControl.m
//  GT
//
//  Created by tage on 14-2-26.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

#import "XTSegmentControl.h"

#define XTSegmentControlItemTag (777)

#define XTSegmentControlItemFont (13)

#define XTSegmentControlHspace (12)

#define XTSegmentControlLineHeight (3)

#define XTSegmentControlAnimationTime (0.3)

@interface XTSegmentControlItem : UIView

@property (nonatomic , strong) UILabel *titleLabel;

@end

@implementation XTSegmentControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XTSegmentControlHspace, 0, CGRectGetWidth(self.bounds) - 2 * XTSegmentControlHspace, CGRectGetHeight(self.bounds))];
            label.font = KDefaultFont(12);//[UIFont systemFontOfSize:XTSegmentControlItemFont];
            label.textColor = KRGBA(120, 120, 120, 1);
            label.text = title;
            label.backgroundColor = [UIColor clearColor];
            label;
        });
        [self addSubview:_titleLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

#define KLineColor [UIColor colorWithRed:0.776471 green:0.196078 blue:0.207843 alpha:1.0]

@interface XTSegmentControl ()<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView *contentView;

@property (nonatomic , strong) UIView *leftShadowView;

@property (nonatomic , strong) UIView *rightShadowView;

@property (nonatomic , strong) UIView *lineView;

@property (nonatomic , strong) NSMutableArray *itemFrames;

@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , strong) XTSegmentControlItem *segmentItem;//分页

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic , assign) id <XTSegmentControlDelegate> delegate;

@property (nonatomic , copy) XTSegmentControlBlock block;

@end

@implementation XTSegmentControl

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem
{
    if (self = [super initWithFrame:frame]) {
        _contentView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.delegate = self;
            scrollView.showsHorizontalScrollIndicator = NO;
            [self addSubview:scrollView];
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
            [scrollView addGestureRecognizer:tapGes];
            [tapGes requireGestureRecognizerToFail:scrollView.panGestureRecognizer];
            scrollView;
        });
        
        _leftShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, CGRectGetHeight(self.bounds))];
        _leftShadowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:_leftShadowView];
        
        _rightShadowView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_contentView.frame), 0, 0.5, CGRectGetHeight(self.bounds))];
        _rightShadowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:_rightShadowView];
        
        [self initItemsWithTitleArray:titleItem];
        
        
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    _lineView.backgroundColor = _lineColor? _lineColor:KLineColor;
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem delegate:(id<XTSegmentControlDelegate>)delegate
{
    if (self = [self initWithFrame:frame Items:titleItem]) {
        self.delegate = delegate;
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem selectedBlock:(XTSegmentControlBlock)selectedHandle
{
    if (self = [self initWithFrame:frame Items:titleItem]) {
        self.block = selectedHandle;
    }
    return self;
}

- (void)doTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    
    __weak typeof(self) weakSelf = self;
    
    [_itemFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect rect = [obj CGRectValue];
        
        if (CGRectContainsPoint(rect, point)) {
            
            [weakSelf selectIndex:idx];
            
            [weakSelf transformAction:idx];
            
            *stop = YES;
        }
    }];
}

- (void)transformAction:(NSInteger)index
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XTSegmentControlDelegate)] && [self.delegate respondsToSelector:@selector(segmentControl:selectedIndex:)]) {
        
        [self.delegate segmentControl:self selectedIndex:index];
        
    }else if (self.block) {
        
        self.block(index);
    }
}

- (void)initItemsWithTitleArray:(NSArray *)titleArray
{
    _itemFrames = @[].mutableCopy;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:XTSegmentControlItemFont]};
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];
        CGFloat titleW = [title sizeWithAttributes:attributes].width+10;
        float x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
        float y = 0;
        float width = 2 * XTSegmentControlHspace + titleW;
        float height = CGRectGetHeight(self.bounds);
        CGRect rect = CGRectMake(x, y, width, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
    }
    
    for (int i = 0; i < titleArray.count; i++) {
        CGRect rect = [_itemFrames[i] CGRectValue];
        NSString *title = titleArray[i];
        _segmentItem = [[XTSegmentControlItem alloc] initWithFrame:rect title:title];
        [_contentView addSubview:_segmentItem];
        _segmentItem.tag=XTSegmentControlItemTag+i;
        if (i==0) {
            _segmentItem.titleLabel.textColor = self.selectColor;
        }
        
    }
    
    [_contentView setContentSize:CGSizeMake(CGRectGetMaxX([[_itemFrames lastObject] CGRectValue]), CGRectGetHeight(self.bounds))];
    self.currentIndex = -1;
    [self selectIndex:0];
    
    [self resetShadowView:_contentView];
}

- (void)addRedLine
{
    if (!_lineView) {
        CGRect rect = [_itemFrames[0] CGRectValue];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight)];
        //设置lineView背景颜色
        _lineView.backgroundColor = KLineColor;
        [_contentView addSubview:_lineView];
    }
    
}
-(UIColor *)normalColor{
    if (_normalColor==nil) {
        _normalColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];//KRGBA(120, 120, 120, 1);
    }
    return _normalColor;
}
-(UIColor *)selectColor{
    if (_selectColor==nil) {
        _selectColor = [UIColor colorWithRed:245/255.0 green:115/255.0 blue:76/255.0 alpha:1];//KRGBA(245, 115, 76, 1);
    }
    return _selectColor;
}
-(void)setSelectIndex:(NSInteger)index lastIndex:(NSInteger)lastIndex{
    if (index==lastIndex) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XTSegmentControlItem *lastIndexItem = (XTSegmentControlItem *)[self viewWithTag:(lastIndex+XTSegmentControlItemTag)];
        XTSegmentControlItem *indexItem = (XTSegmentControlItem *)[self viewWithTag:(index+XTSegmentControlItemTag)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
                lastIndexItem.titleLabel.textColor = self.normalColor;
                indexItem.titleLabel.textColor = self.selectColor;
                lastIndexItem.transform = CGAffineTransformMakeScale(1.0, 1.0);
                indexItem.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }completion:^(BOOL finished) {
                
            }];
        });
    });
}
- (void)selectIndex:(NSInteger)index
{
    [self addRedLine];
    if (index != _currentIndex) {
        
        [self setSelectIndex:index lastIndex:_currentIndex];
        
        CGRect rect = [_itemFrames[index] CGRectValue];
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
            _lineView.frame = lineRect;
        }];
        
        _currentIndex = index;
        
    }
    [self setScrollOffset:index];
}

- (void)moveIndexWithProgress:(float)progress
{
    float delta = progress - _currentIndex;
    
    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;
    
    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + XTSegmentControlHspace, CGRectGetHeight(origionRect) - XTSegmentControlLineHeight, CGRectGetWidth(origionRect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
    
    CGRect rect;
    
    if (delta > 0) {
        
        if (_currentIndex == _itemFrames.count - 1) {
            return;
        }
        
        rect = [_itemFrames[_currentIndex + 1] CGRectValue];
        
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        
        CGRect moveRect = CGRectZero;
        
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) + delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        
        _lineView.frame = moveRect;
        [self setSelectIndex:floor(progress)  lastIndex:_currentIndex];
        
        _lineView.center = CGPointMake(CGRectGetMidX(origionLineRect) + delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)), CGRectGetMidY(origionLineRect));
        
        if (delta > 1) {
            
            [self setSelectIndex:floor(progress)  lastIndex:_currentIndex];
            
            _currentIndex ++;
        }
        
    }else if (delta < 0){
        
        if (_currentIndex == 0) {
            return;
        }
        
        rect = [_itemFrames[_currentIndex - 1] CGRectValue];
        
        [self setSelectIndex:floor(progress)+1 lastIndex:_currentIndex];
        
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        
        CGRect moveRect = CGRectZero;
        
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) - delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        
        _lineView.frame = moveRect;
        
        
        _lineView.center = CGPointMake(CGRectGetMidX(origionLineRect) - delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)), CGRectGetMidY(origionLineRect));
        
        if (delta < -1) {
            
            _currentIndex --;
        }
    }
}

- (void)endMoveIndex:(NSInteger)index
{
    [self selectIndex:index];
}

- (void)setScrollOffset:(NSInteger)index
{
    CGRect rect = [_itemFrames[index] CGRectValue];
    
    float midX = CGRectGetMidX(rect);
    
    float offset = 0;
    
    float contentWidth = _contentView.contentSize.width;
    
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;
    }else{
        offset = midX - halfWidth;
    }
    
    [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
        
        [_contentView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resetShadowView:scrollView];
}

- (void)resetShadowView:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0) {
        
        _leftShadowView.hidden = NO;
        
        if (scrollView.contentOffset.x == scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds)) {
            _rightShadowView.hidden = YES;
        }else{
            _rightShadowView.hidden = NO;
        }
        
    }else if (scrollView.contentOffset.x == 0) {
        _leftShadowView.hidden = YES;
        if (_contentView.contentSize.width < CGRectGetWidth(_contentView.frame)) {
            _rightShadowView.hidden = YES;
        }else{
            _rightShadowView.hidden = NO;
        }
    }
}


int ExceMinIndex(float f)
{
    int i = (int)f;
    if (f != i) {
        return i+1;
    }
    return i;
}

@end

