#import "GridView.h"

@implementation GridView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

@synthesize isPullDownAble = _isPullDownAble;
@synthesize isPerformAfterFreeForPullDown = _isPerformAfterFreeForPullDown;
@synthesize delegatePullDown = _delegatePullDown;
@synthesize isDragUpAble = _isDragUpAble;
@synthesize isPerformAfterFreeForDragUp = _isPerformAfterFreeForDragUp;
@synthesize delegateDragUp = _delegateDragUp;

@synthesize isBouncesAble = _isBouncesAble;
@synthesize isDeleteRowAble = _isDeleteRowAble;

@synthesize isDecForFontSizeAble = _isDecForFontSizeAble;
@synthesize minimumFontSize = _minimumFontSize;

- (void)dealloc {
    [_lockedColumnMArr release];
    [_leftContentQueue release];
    [_rightContentQueue release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isScrollAble = NO;
        _isPullDownAble = NO;
        _isPerformAfterFreeForPullDown = YES;
        _isDragUpAble = NO;
        _isPerformAfterFreeForDragUp = NO;
        _isBouncesAble = YES;
        _isDeleteRowAble = NO;
        _isDecForFontSizeAble = NO;
        _minimumFontSize = 12.0;
        _lockedColumnMArr = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5", nil];
        _leftContentQueue = [[NSMutableArray alloc] init];
        _rightContentQueue = [[NSMutableArray alloc] init];
        [self _initView];
        [self _loadView];
    }
    return self;
}

#pragma mark ***************************
#pragma mark 初始化View
/**
 * 帮助创建好的View找到自己的父亲
 **/
- (void)_loadView {
    [_leftAndRightScrollView addSubview:_leftAndRightContentView];
    [_leftAndRightContentView release];
    [_upAndDownScrollView addSubview:_upAndDownContentView];
    [_upAndDownContentView release];
    [_upAndDownScrollView addSubview:_leftAndRightScrollView];
    [_leftAndRightScrollView release];
    [self addSubview:_upAndDownScrollView];
    [_upAndDownScrollView release];
    [self addSubview:_leftHeaderContentView];
    [_leftHeaderContentView release];
    [self addSubview:_leftFooterContentView];
    [_leftFooterContentView release];
    [self addSubview:_rightHeaderContentView];
    [_rightHeaderContentView release];
    [self addSubview:_rightFooterContentView];
    [_rightFooterContentView release];
    
    if (_isPullDownAble) {
        [_upAndDownScrollView addSubview:_headerStateView];
        [_headerStateView release];
    }
    if (_isDragUpAble) {
        [_upAndDownScrollView addSubview:_footerStateView];
        [_footerStateView release];
    }
}

/**
 * 创建相关的View
 **/
- (void)_initView {
    [self setBackgroundColor:[UIColor whiteColor]];
    _upAndDownScrollView = [[UIScrollView alloc] init];
    _upAndDownScrollView.delegate = self;
    _upAndDownScrollView.bounces = _isBouncesAble;
    _leftAndRightScrollView = [[UIScrollView alloc] init];
    _leftAndRightScrollView.delegate = self;
    
    _upAndDownContentView = [[UIView alloc] init];
    _leftAndRightContentView = [[UIView alloc] init];
    _leftHeaderContentView = [[UIView alloc] init];
    _rightHeaderContentView = [[UIView alloc] init];
    _leftFooterContentView = [[UIView alloc] init];
    _rightFooterContentView = [[UIView alloc] init];
    
    _headerStateView = _isPullDownAble ? [[GridStateView alloc] initWithViewType:GridStateViewTypeHeader] : nil;
    _footerStateView = _isDragUpAble ? [[GridStateView alloc] initWithViewType:GridStateViewTypeFooter] : nil;
}

#pragma mark ***************************
#pragma mark 配置GridView
/**
 * 装配GridView
 **/
- (void)_configureGrid:(CGRect)p_frame {
    CGRect frame = [self _calculateFrameForView:p_frame];
    [self _configureFrameForViews:frame];
    [_headerStateView loadView];
    [_footerStateView loadView];
}

/**
 * 计算各个View的Frame，同时计算复用队列大小，并初始化
 **/
- (CGRect)_calculateFrameForView:(CGRect)p_frame {
    _headerHeight = .0;
    if ([_delegate respondsToSelector:@selector(heightForHeader:)] && [_dataSource respondsToSelector:@selector(gridView:textForHeaderAtColumn:)]) {
        _headerHeight = [_delegate heightForHeader:self];
    }
    _footerHeight = .0;
    if ([_delegate respondsToSelector:@selector(heightForFooter:)] && [_dataSource respondsToSelector:@selector(gridView:textForFooterAtColumn:)]) {
        _footerHeight = [_delegate heightForFooter:self];
    }
    _rangeFrom = 0;
    _rangeTo = -1;
    _range = -1;
    _contentHeight = .0;
    BOOL isContinueAble = YES;
    for (int i = 0, count = [_dataSource numberOfContentRowsInGridView:self]; i < count; i++) {
        _contentHeight += [_delegate gridView:self heightForContentAtRow:i];
        if (_contentHeight >= p_frame.size.height - _headerHeight - _footerHeight && isContinueAble) {
            _rangeFrom = -1;
            _rangeTo = i + 1 == count ? i : i + 1;
            _range = _rangeTo;
            isContinueAble = NO;
        } else {
            _rangeFrom = 0;
            _rangeTo = i;
            _range = i + 1;
        }
    }
    if (_contentHeight + _headerHeight + _footerHeight < p_frame.size.height) {
        [self setFrame:CGRectMake(p_frame.origin.x, p_frame.origin.y, p_frame.size.width, _contentHeight + _headerHeight + _footerHeight)];
        p_frame = self.frame;
    }
    _leftContentWidth = _isDeleteRowAble ? WidthForDelete : .0;
    _rightContentWidth = .0;
    float columnWidth;
    for(int i = 0, count = [_dataSource numberOfColumnsInGridView:self]; i < count; i++){
        columnWidth = [self.dataSource gridView:self modelForColumnAtColumn:i].columnWidth;
        NSString *iStr = [NSString stringWithFormat:@"%d", i];
        if ([_lockedColumnMArr containsObject:iStr]) {
            _leftContentWidth += columnWidth;
            continue;
        }
        _rightContentWidth += columnWidth;
    }
    _rightContentWidth = _rightContentWidth + _leftContentWidth  < p_frame.size.width ? p_frame.size.width : _rightContentWidth;
    [_leftContentQueue removeAllObjects];
    [_rightContentQueue removeAllObjects];
    for (int i = _rangeFrom; i <= _rangeTo; i++) {
        GridRowView *leftRowView = [[GridRowView alloc] init];
        leftRowView.delegate = self;
        [_upAndDownContentView addSubview:leftRowView];
        [_leftContentQueue addObject:leftRowView];
        [leftRowView release];
        GridRowView *rightRowView = [[GridRowView alloc] init];
        rightRowView.delegate = self;
        [_leftAndRightContentView addSubview:rightRowView];
        [_rightContentQueue addObject:rightRowView];
        [rightRowView release];
    }
    return self.frame;
}

/**
 * 设置各个View的Frame
 **/
- (void)_configureFrameForViews:(CGRect)p_frame {
    [_leftAndRightContentView setFrame:CGRectMake(.0, .0, p_frame.size.width - _leftContentWidth, _contentHeight)];
    [_upAndDownContentView setFrame:CGRectMake(.0, .0, p_frame.size.width, _contentHeight)];
    [_leftAndRightScrollView setFrame:CGRectMake(_leftContentWidth, .0, p_frame.size.width - _leftContentWidth, _contentHeight)];
	[_upAndDownScrollView setFrame:CGRectMake(.0, _headerHeight, p_frame.size.width, p_frame.size.height - _headerHeight - _footerHeight)];
	[_leftHeaderContentView setFrame:CGRectMake(.0, .0, _leftContentWidth, _headerHeight)];
    [_rightHeaderContentView setFrame:CGRectMake(_leftContentWidth, .0, p_frame.size.width - _leftContentWidth, _headerHeight)];
    [_leftFooterContentView setFrame:CGRectMake(.0, _headerHeight + _upAndDownScrollView.frame.size.height, _leftContentWidth, _footerHeight)];
    [_rightFooterContentView setFrame:CGRectMake(_leftContentWidth, _headerHeight + _upAndDownScrollView.frame.size.height, p_frame.size.width - _leftContentWidth, _footerHeight)];
    
    _leftAndRightScrollView.contentSize = CGSizeMake(_rightContentWidth, p_frame.size.height - _headerHeight - _footerHeight);
    _upAndDownScrollView.contentSize = CGSizeMake(p_frame.size.width, _contentHeight);

    [_headerStateView setFrame:CGRectMake(.0, -k_STATE_VIEW_HEIGHT, p_frame.size.width, .0)];
    [_footerStateView setFrame:CGRectMake(.0, _contentHeight, p_frame.size.width, .0)];
}

#pragma mark ***************************
#pragma mark 装载数据
/**
 * 装载数据
 **/
- (void)_configureData {
    if (_headerHeight > .0) {
        [self _configureHeaderData];
    }
    [self _configureContentData];
    if (_footerHeight > .0) {
        [self _configureFooterData];
    }
}

/**
 * 装载Header的数据
 **/
- (void)_configureHeaderData {
    float cellHeight = [_delegate heightForHeader:self];
    GridPosition position;
    GridColumnModel *columnModel = nil;
    GridCellModel *cellModel = nil;
    float leftRowViewOffsetX = _isDeleteRowAble ? WidthForDelete : .0;
    float rightRowViewOffsetX = .0;
    GridRowView *leftRowView = [[GridRowView alloc] init];
    if (_isDeleteRowAble) {
        [leftRowView drawDeleteBtnWithHeight:cellHeight andWithSection:GridSectionHeader];
    }
    leftRowView.delegate = self;
    GridRowView *rightRowView = [[GridRowView alloc] init];
    rightRowView.delegate = self;
    for(int column = 0, count = [_dataSource numberOfColumnsInGridView:self]; column < count; column++) {
        position = GridPositionMakeFromRowAndColumn(GridSectionHeader, 0, column);
        columnModel = [_dataSource gridView:self modelForColumnAtColumn:column];
        cellModel = [[GridCellModel alloc] init];
        cellModel.position = position;
        cellModel.textAlignment = columnModel.columnAlignment;
        cellModel.isDecForFontSizeAble = columnModel.isDecForFontSizeAble;
        cellModel.minimumFontSize = columnModel.minimumFontSize;
        cellModel.padding = columnModel.padding;
        cellModel.text = [_dataSource gridView:self textForHeaderAtColumn:column];
        cellModel.textFontSize = columnModel.titleFontSize;
        cellModel.textColor = columnModel.titleColor;
        cellModel.bgColor = columnModel.titleBgColor;
        cellModel.frameColor = columnModel.titleFrameColor;
        cellModel.isDecForFontSizeAble = _isDecForFontSizeAble;
        cellModel.minimumFontSize = _minimumFontSize;
        NSString *iStr = [NSString stringWithFormat:@"%d", column];
        if ([_lockedColumnMArr containsObject:iStr]) {
            CGRect cellFrame = CGRectMake(leftRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
            cellModel.cellFrame = cellFrame;
            [leftRowView.cellModelsMArr addObject:cellModel];
            leftRowViewOffsetX += columnModel.columnWidth;
        } else {
            CGRect cellFrame = CGRectMake(rightRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
            cellModel.cellFrame = cellFrame;
            [rightRowView.cellModelsMArr addObject:cellModel];
            rightRowViewOffsetX += columnModel.columnWidth;
        }
        [cellModel release];
    }
    [leftRowView setFrame:CGRectMake(.0, .0, leftRowViewOffsetX, cellHeight)];
    [rightRowView setFrame:CGRectMake(.0, .0, rightRowViewOffsetX, cellHeight)];
    [_leftHeaderContentView addSubview:leftRowView];
    [_rightHeaderContentView addSubview:rightRowView];
    [leftRowView release];
    [rightRowView release];
}

/**
 * 装载Content的数据
 **/
- (void)_configureContentData {
    float rowViewOffsetY = .0;
    for (int row = _rangeFrom; row <= _rangeTo; row++) {
        if (row < 0) {
            continue;
        }
        float cellHeight = [_delegate gridView:self heightForContentAtRow:row];
        GridPosition position;
        GridColumnModel *columnModel = nil;
        GridCellModel *cellModel = nil;
        float leftRowViewOffsetX = _isDeleteRowAble ? WidthForDelete : .0;
        float rightRowViewOffsetX = .0;
        GridRowView *leftRowView = [_leftContentQueue objectAtIndex:(row + 1) % _leftContentQueue.count];
        GridRowView *rightRowView = [_rightContentQueue objectAtIndex:(row + 1) % _rightContentQueue.count];
        for(int column = 0, count = [_dataSource numberOfColumnsInGridView:self]; column < count; column++)
        {
            position = GridPositionMakeFromRowAndColumn(GridSectionContent, row, column);
            columnModel = [_dataSource gridView:self modelForColumnAtColumn:column];
            cellModel = [[GridCellModel alloc] init];
            cellModel.position = position;
            cellModel.textAlignment = columnModel.columnAlignment;
            cellModel.isDecForFontSizeAble = columnModel.isDecForFontSizeAble;
            cellModel.minimumFontSize = columnModel.minimumFontSize;
            cellModel.padding = columnModel.padding;
            cellModel.text = [_dataSource gridView:self textForContentAtPosition:position];
            cellModel.textFontSize = columnModel.contentFontSize;
            cellModel.textColor = columnModel.contentColor;
            cellModel.bgColor = columnModel.contentBgColor;
            cellModel.frameColor = columnModel.contentFrameColor;
            cellModel.isDecForFontSizeAble = _isDecForFontSizeAble;
            cellModel.minimumFontSize = _minimumFontSize;
            NSString *iStr = [NSString stringWithFormat:@"%d", column];
//            if (column==5)
//            {
//                leftRowView.flag = YES;
//                rightRowView.flag = YES;
//            }
//            else
//            {
//                leftRowView.flag = NO;
//                rightRowView.flag = NO;
//            }
            if ([_lockedColumnMArr containsObject:iStr])
            {
                CGRect cellFrame = CGRectMake(leftRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
                cellModel.cellFrame = cellFrame;
                [leftRowView.cellModelsMArr addObject:cellModel];
                leftRowViewOffsetX += columnModel.columnWidth;
            }
            else
            {
                CGRect cellFrame = CGRectMake(rightRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
                cellModel.cellFrame = cellFrame;
                [rightRowView.cellModelsMArr addObject:cellModel];
                rightRowViewOffsetX += columnModel.columnWidth;
            }
            [cellModel release];
        }
        [leftRowView setFrame:CGRectMake(.0, rowViewOffsetY, leftRowViewOffsetX, cellHeight)];
        if (_isDeleteRowAble) {
//            [leftRowView drawDeleteBtnWithHeight:cellHeight andWithSection:GridSectionContent];
        }
        [rightRowView setFrame:CGRectMake(.0, rowViewOffsetY, rightRowViewOffsetX, cellHeight)];
        [leftRowView setNeedsDisplay];
        [rightRowView setNeedsDisplay];
        rowViewOffsetY += cellHeight;
    }
}

/**
 * 装载Footer的数据
 **/
- (void)_configureFooterData {
    float cellHeight = [_delegate heightForFooter:self];
    GridPosition position;
    GridColumnModel *columnModel = nil;
    GridCellModel *cellModel = nil;
    float leftRowViewOffsetX = _isDeleteRowAble ? WidthForDelete : .0;
    float rightRowViewOffsetX = .0;
    GridRowView *leftRowView = [[GridRowView alloc] init];
    if (_isDeleteRowAble) {
        [leftRowView drawDeleteBtnWithHeight:cellHeight andWithSection:GridSectionFooter];
    }
    leftRowView.delegate = self;
    GridRowView *rightRowView = [[GridRowView alloc] init];
    rightRowView.delegate = self;
    for(int column = 0, count = [_dataSource numberOfColumnsInGridView:self]; column < count; column++) {
        position = GridPositionMakeFromRowAndColumn(GridSectionFooter, 0, column);
        columnModel = [_dataSource gridView:self modelForColumnAtColumn:column];
        cellModel = [[GridCellModel alloc] init];
        cellModel.position = position;
        cellModel.textAlignment = columnModel.columnAlignment;
        cellModel.isDecForFontSizeAble = columnModel.isDecForFontSizeAble;
        cellModel.minimumFontSize = columnModel.minimumFontSize;
        cellModel.padding = columnModel.padding;
        cellModel.text = [_dataSource gridView:self textForFooterAtColumn:column];
        cellModel.textFontSize = columnModel.footerFontSize;
        cellModel.textColor = columnModel.footerColor;
        cellModel.bgColor = columnModel.footerBgColor;
        cellModel.frameColor = columnModel.footerFrameColor;
        cellModel.isDecForFontSizeAble = _isDecForFontSizeAble;
        cellModel.minimumFontSize = _minimumFontSize;
        NSString *iStr = [NSString stringWithFormat:@"%d", column];
        if ([_lockedColumnMArr containsObject:iStr]) {
            CGRect cellFrame = CGRectMake(leftRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
            cellModel.cellFrame = cellFrame;
            [leftRowView.cellModelsMArr addObject:cellModel];
            leftRowViewOffsetX += columnModel.columnWidth;
        } else {
            CGRect cellFrame = CGRectMake(rightRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
            cellModel.cellFrame = cellFrame;
            [rightRowView.cellModelsMArr addObject:cellModel];
            rightRowViewOffsetX += columnModel.columnWidth;
        }
        [cellModel release];
    }
    [leftRowView setFrame:CGRectMake(.0, .0, leftRowViewOffsetX, cellHeight)];
    [rightRowView setFrame:CGRectMake(.0, .0, rightRowViewOffsetX, cellHeight)];
    [_leftFooterContentView addSubview:leftRowView];
    [_rightFooterContentView addSubview:rightRowView];
    [leftRowView release];
    [rightRowView release];
}

#pragma mark ***************************
#pragma mark GridRowView代理方法实现
/**
 * 点击事件代理，来自GridRowView
 **/
- (void)gridRowView:(GridRowView *)p_view didSelectAtPosition:(GridPosition)p_p {
    if ([_delegate respondsToSelector:@selector(gridView:didSelectAtPosition:)]) {
        [_delegate gridView:self didSelectAtPosition:p_p];
    }
}

/**
 * 长按点击事件代理，来自GridRowView
 **/
- (void)gridRowView:(GridRowView *)p_view didSelectWithLongPressAtPosition:(GridPosition)p_p {
    if (p_p.section == GridSectionHeader) {
        _selectedColumnIndex = p_p.rc.column;
        NSString *msg = @"确定要锁定该列？";
        if ([_lockedColumnMArr containsObject:[NSString stringWithFormat:@"%d", _selectedColumnIndex]]) {
            msg = @"确定要将该列解锁？";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert setDelegate:self];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([_lockedColumnMArr containsObject:[NSString stringWithFormat:@"%d", _selectedColumnIndex]]) {
            [_lockedColumnMArr removeObject:[NSString stringWithFormat:@"%d", _selectedColumnIndex]];
        } else {
            [_lockedColumnMArr addObject:[NSString stringWithFormat:@"%d", _selectedColumnIndex]];
        }
        [self loadView:self.frame];
    }
}

/**
 * 删除行对应代理方法
 **/
- (void)gridRowView:(GridRowView *)p_view deleteWithRow:(NSInteger)p_row {
    if ([_delegate respondsToSelector:@selector(gridView:deleteWithRow:)]) {
        [_delegate gridView:self deleteWithRow:p_row];
        [self loadView:self.frame];
    }
}

#pragma mark ***************************
#pragma mark UIScrollView代理方法实现
/**
 * scrollView开始滑动触发，来自UIScrollView
 **/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isScrollAble = YES;
    if (scrollView == _leftAndRightScrollView) {
        scrollView.frame = CGRectMake(_leftContentWidth,
                                      .0,
                                      scrollView.frame.size.width,
                                      self.frame.size.height);
        _leftAndRightContentView.frame = CGRectMake(.0,
                                                    _rightHeaderContentView.frame.size.height - _upAndDownScrollView.contentOffset.y,
                                                    _rightContentWidth,
                                                    _contentHeight);// ----
        _rightHeaderContentView.frame = CGRectMake(.0,
                                                   _rightHeaderContentView.frame.origin.y,
                                                   _rightContentWidth,
                                                   _rightHeaderContentView.frame.size.height);
        _rightHeaderContentView.bounds = CGRectMake(.0,
                                                    .0,
                                                    _rightContentWidth,
                                                    _rightHeaderContentView.frame.size.height);
        [scrollView addSubview:_rightHeaderContentView];
        _rightFooterContentView.frame = CGRectMake(.0,
                                                   scrollView.frame.size.height - _rightFooterContentView.frame.size.height,
                                                   _rightContentWidth,
                                                   _rightFooterContentView.frame.size.height);
        _rightFooterContentView.bounds = CGRectMake(.0,
                                                    .0,
                                                    _rightContentWidth,
                                                    _rightFooterContentView.frame.size.height);;
        [scrollView addSubview:_rightFooterContentView];
        [self addSubview:scrollView];
    }
}

/**
 * scrollView滑动中触发，来自UIScrollView
 **/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _leftAndRightScrollView) {
        scrollView.frame = CGRectMake(_leftContentWidth,
                                      .0,
                                      scrollView.frame.size.width,
                                      self.frame.size.height);
        _leftAndRightContentView.frame = CGRectMake(.0,
                                                    _rightHeaderContentView.frame.size.height - _upAndDownScrollView.contentOffset.y,
                                                    _rightContentWidth,
                                                    _contentHeight);// ----
        [scrollView addSubview:_rightHeaderContentView];
        [scrollView addSubview:_rightFooterContentView];
        [self addSubview:scrollView];
        if (!_isScrollAble) {
            [self scrollViewDidEndDecelerating:scrollView];
        }
    } else {
        CGFloat contentPageHeight = .0;
        if (scrollView.contentOffset.y > _contentOffsetPreY) {
            for (int i = 0, count = _rangeFrom + 1; i < count; i++) {
                contentPageHeight += [_delegate gridView:self heightForContentAtRow:i];
            }
            while (scrollView.contentOffset.y > contentPageHeight) {
                if (_rangeTo + 1 < [_dataSource numberOfContentRowsInGridView:self]) {
                    _rangeFrom++;
                    _rangeTo++;
                    [self _configureNextContentData:_rangeTo withIndex:_rangeFrom];
                }
                contentPageHeight += [_delegate gridView:self heightForContentAtRow:_rangeFrom];
            }
        } else if (scrollView.contentOffset.y < _contentOffsetPreY) {
            for (int i = 0, count = _rangeTo - _range - 1; i <= count; i++) {
                contentPageHeight += [_delegate gridView:self heightForContentAtRow:i];
            }
            while (scrollView.contentOffset.y < contentPageHeight) {
                if (_rangeFrom >= 0) {
                    [self _configureNextContentData:_rangeFrom withIndex:_rangeFrom + 1];
                    _rangeFrom--;
                    _rangeTo--;
                }
                contentPageHeight -= [_delegate gridView:self heightForContentAtRow:_rangeFrom];
            }
        }
        _contentOffsetPreY = scrollView.contentOffset.y;
        if (_headerStateView.currentState == GridStateViewStateLoading ||
            _footerStateView.currentState == GridStateViewStateLoading) {
            return;
        }
        if (_contentOffsetPreY < -k_STATE_VIEW_HEIGHT - 5.0) {
            [_headerStateView changeState:GridStateViewStatePullDown];
        } else {
            [_headerStateView changeState:GridStateViewStateNormal];
        }
        if (_footerStateView.currentState == GridStateViewStateEnd) {
            return;
        }
        if (_isPullDownAble && !_isPerformAfterFreeForPullDown && _contentOffsetPreY < -k_STATE_VIEW_HEIGHT - 5.0) {
            [_headerStateView changeState:GridStateViewStateLoading];
            scrollView.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
            [_delegatePullDown gridStateViewPullDown:_headerStateView];
            return;
        }
        CGFloat differenceY = scrollView.contentSize.height > scrollView.frame.size.height ? (scrollView.contentSize.height - scrollView.frame.size.height) : .0;
        if (_contentOffsetPreY > differenceY + k_STATE_VIEW_HEIGHT + 5.0) {
            [_footerStateView changeState:GridStateViewStateDragUp];
        } else {
            [_footerStateView changeState:GridStateViewStateNormal];
        }
        if (_isDragUpAble && !_isPerformAfterFreeForDragUp && _contentOffsetPreY > differenceY + k_STATE_VIEW_HEIGHT + 5.0) {
            [_footerStateView changeState:GridStateViewStateLoading];
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, k_STATE_VIEW_HEIGHT, 0);
            [_delegateDragUp gridStateViewDragUp:_footerStateView];
        }
    }
}

/**
 * 复用队列中的空闲GridRowView循环利用
 **/
- (void)_configureNextContentData:(NSInteger)p_row withIndex:(NSInteger)p_index {
    float rowViewOffsetY = .0;
    for (int row = 0; row < p_row; row++) {
        rowViewOffsetY += [_delegate gridView:self heightForContentAtRow:row];
    }
    float cellHeight = [_delegate gridView:self heightForContentAtRow:p_row];
    GridPosition position;
    GridColumnModel *columnModel = nil;
    GridCellModel *cellModel = nil;
    float leftRowViewOffsetX = _isDeleteRowAble ? WidthForDelete : .0;
    float rightRowViewOffsetX = .0;
    GridRowView *leftRowView = [_leftContentQueue objectAtIndex:p_index % _leftContentQueue.count];
    if (_isDeleteRowAble) {
        [leftRowView drawDeleteBtnWithHeight:cellHeight andWithSection:GridSectionContent];
    }
    [leftRowView.cellModelsMArr removeAllObjects];
    GridRowView *rightRowView = [_rightContentQueue objectAtIndex:p_index % _rightContentQueue.count];
    [rightRowView.cellModelsMArr removeAllObjects];
    for(int column = 0, count = [_dataSource numberOfColumnsInGridView:self]; column < count; column++) {
        position = GridPositionMakeFromRowAndColumn(GridSectionContent, p_row, column);
        columnModel = [_dataSource gridView:self modelForColumnAtColumn:column];
        cellModel = [[GridCellModel alloc] init];
        cellModel.position = position;
        cellModel.textAlignment = columnModel.columnAlignment;
        cellModel.isDecForFontSizeAble = columnModel.isDecForFontSizeAble;
        cellModel.minimumFontSize = columnModel.minimumFontSize;
        cellModel.padding = columnModel.padding;
        cellModel.text = [_dataSource gridView:self textForContentAtPosition:position];
        cellModel.textFontSize = columnModel.contentFontSize;
        cellModel.textColor = columnModel.contentColor;
        cellModel.bgColor = columnModel.contentBgColor;
        cellModel.frameColor = columnModel.contentFrameColor;
        cellModel.isDecForFontSizeAble = _isDecForFontSizeAble;
        cellModel.minimumFontSize = _minimumFontSize;
        NSString *iStr = [NSString stringWithFormat:@"%d", column];
        if ([_lockedColumnMArr containsObject:iStr]) {
            CGRect cellFrame = CGRectMake(leftRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
            cellModel.cellFrame = cellFrame;
            [leftRowView.cellModelsMArr addObject:cellModel];
            leftRowViewOffsetX += columnModel.columnWidth;
        } else {
            CGRect cellFrame = CGRectMake(rightRowViewOffsetX, .0, columnModel.columnWidth, cellHeight);
            cellModel.cellFrame = cellFrame;
            [rightRowView.cellModelsMArr addObject:cellModel];
            rightRowViewOffsetX += columnModel.columnWidth;
        }
        [cellModel release];
    }
    [leftRowView setFrame:CGRectMake(.0, rowViewOffsetY, leftRowViewOffsetX, cellHeight)];
    [rightRowView setFrame:CGRectMake(.0, rowViewOffsetY, rightRowViewOffsetX, cellHeight)];
    [leftRowView setNeedsDisplay];
    [rightRowView setNeedsDisplay];
}

/**
 * scrollView停止滑动（手指离开屏幕）触发，来自UIScrollView
 **/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isScrollAble = NO;
    if (scrollView == _leftAndRightScrollView && !decelerate) {
		[self scrollViewDidEndDecelerating:scrollView];
    } else {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (_headerStateView.currentState == GridStateViewStateLoading ||
            _footerStateView.currentState == GridStateViewStateLoading) {
            return;
        }
        if (_isPullDownAble && _isPerformAfterFreeForPullDown && offsetY < -k_STATE_VIEW_HEIGHT - 5.0) {
            [_headerStateView changeState:GridStateViewStateLoading];
            scrollView.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
            [_delegatePullDown gridStateViewPullDown:_headerStateView];
            return;
        } else {
            [_headerStateView changeState:GridStateViewStateNormal];
        }
        CGFloat differenceY = scrollView.contentSize.height > scrollView.frame.size.height ? (scrollView.contentSize.height - scrollView.frame.size.height) : .0;
        if (_isDragUpAble && _isPerformAfterFreeForDragUp && _contentOffsetPreY > differenceY + k_STATE_VIEW_HEIGHT + 5.0) {
            [_footerStateView changeState:GridStateViewStateLoading];
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, k_STATE_VIEW_HEIGHT, 0);
            [_delegateDragUp gridStateViewDragUp:_footerStateView];
        } else {
            [_footerStateView changeState:GridStateViewStateNormal];
        }
    }
}

/**
 * scrollView减速滑动至停止时触发，来自UIScrollView
 **/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrollAble = NO;
	if (scrollView == _leftAndRightScrollView) {
        scrollView.frame = CGRectMake(_leftContentWidth,
                                      .0,
                                      scrollView.frame.size.width,
                                      _contentHeight);
        _leftAndRightContentView.frame = CGRectMake(.0,
                                                    .0,
                                                    _rightContentWidth,
                                                    _contentHeight);
        
        _rightHeaderContentView.frame = CGRectMake(_leftContentWidth,
                                                   _rightHeaderContentView.frame.origin.y,
                                                   _rightContentWidth,
                                                   _rightHeaderContentView.frame.size.height);
        _rightHeaderContentView.bounds = CGRectMake(scrollView.contentOffset.x,
                                                    .0,
                                                    _rightContentWidth,
                                                    _rightHeaderContentView.frame.size.height);
        _rightHeaderContentView.clipsToBounds = YES;
        [self addSubview:_rightHeaderContentView];
        _rightFooterContentView.frame = CGRectMake(_leftContentWidth,
                                                   _rightHeaderContentView.frame.size.height + _upAndDownScrollView.frame.size.height,
                                                   _rightContentWidth,
                                                   _rightFooterContentView.frame.size.height);
        _rightFooterContentView.bounds = CGRectMake(scrollView.contentOffset.x,
                                                    .0,
                                                    _rightContentWidth,
                                                    _rightFooterContentView.frame.size.height);
        _rightFooterContentView.clipsToBounds = YES;
        [self addSubview:_rightFooterContentView];
        [_upAndDownScrollView addSubview:scrollView];
    }
}

#pragma mark ***************************
#pragma mark 向外暴露的方法
/**
 * 启动整个GridView，向外暴露
 **/
- (void)loadView:(CGRect)p_frame {
    [self _removeSubviewsFromSuperview:_leftHeaderContentView];
    [self _removeSubviewsFromSuperview:_rightHeaderContentView];
    [self _removeSubviewsFromSuperview:_leftAndRightContentView];
    [self _removeSubviewsFromSuperview:_upAndDownContentView];
    [self _removeSubviewsFromSuperview:_leftFooterContentView];
    [self _removeSubviewsFromSuperview:_rightFooterContentView];
    self.frame = p_frame;
    [self _configureGrid:p_frame];
    [self _configureData];
}

/**
 * 重新配置GridView的数据，向外暴露
 **/
- (void)reloadData {
    [self _removeSubviewsFromSuperview:_leftHeaderContentView];
    [self _removeSubviewsFromSuperview:_rightHeaderContentView];
    [self _removeSubviewsFromSuperview:_leftAndRightContentView];
    [self _removeSubviewsFromSuperview:_upAndDownContentView];
    [self _removeSubviewsFromSuperview:_leftFooterContentView];
    [self _removeSubviewsFromSuperview:_rightFooterContentView];
    [self _configureGrid:self.frame];
    [self _configureData];
}

/**
 * 移除p_superview上的所有subview
 **/
- (void)_removeSubviewsFromSuperview:(UIView *)p_superview {
    for (UIView *view in [p_superview subviews]) {
        [view removeFromSuperview];
    }
}

/**
 * 亲写isBouncesAble的setter方法，向外暴露
 **/
- (void)setIsBouncesAble:(BOOL)isBouncesAble {
    _upAndDownScrollView.bounces = isBouncesAble;
}

/**
 * 亲写isDragUpAble的setter方法，向外暴露
 **/
- (void)setIsDragUpAble:(BOOL)isDragUpAble {
    _isDragUpAble = isDragUpAble;
    self.isBouncesAble = isDragUpAble ? YES : _isBouncesAble;
    if (_footerStateView && !isDragUpAble) {
        [_footerStateView removeFromSuperview];
    } else if (!_footerStateView && isDragUpAble) {
        _footerStateView = [[GridStateView alloc] initWithViewType:GridStateViewTypeFooter];
        [_upAndDownScrollView addSubview:_footerStateView];
        [_footerStateView release];
    }
}

/**
 * 亲写isPullDownAble的setter方法，向外暴露
 **/
- (void)setIsPullDownAble:(BOOL)isPullDownAble {
    _isPullDownAble = isPullDownAble;
    self.isBouncesAble = isPullDownAble ? YES : _isBouncesAble;
    if (_headerStateView && !isPullDownAble) {
        [_headerStateView removeFromSuperview];
    } else if (!_headerStateView && isPullDownAble) {
        _headerStateView = [[GridStateView alloc] initWithViewType:GridStateViewTypeHeader];
        [_upAndDownScrollView addSubview:_headerStateView];
        [_headerStateView release];
    }
}

@end
