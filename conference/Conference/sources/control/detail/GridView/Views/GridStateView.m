#import "GridStateView.h"

@implementation GridStateView

@synthesize currentState = _currentState;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithViewType:(GridStateViewType)p_type {
    self = [super init];
    if (self) {
        _viewType = p_type;
    }
    return self;
}

- (void)loadView {
    CGFloat width = self.frame.size.width;
    [self setFrame:CGRectMake(.0, self.frame.origin.y, width, k_STATE_VIEW_HEIGHT)];
    
    self.backgroundColor = [UIColor clearColor];
    
        //  初始化加载指示器（菊花圈）
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((k_STATE_VIEW_INDICATE_WIDTH - 20) / 2, (k_STATE_VIEW_HEIGHT - 20) / 2, 20, 20)];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _indicatorView.hidesWhenStopped = YES;
    [self addSubview:_indicatorView];
    [_indicatorView release];
    
        //  初始化箭头视图
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((k_STATE_VIEW_INDICATE_WIDTH - 32) / 2, (k_STATE_VIEW_HEIGHT - 32) / 2, 32, 32)];
    NSString * imageNamed = _viewType == GridStateViewTypeHeader ? @"grid_arrow_down.png" : @"grid_arrow_up.png";
    _arrowView.image = [UIImage imageNamed:imageNamed];
    [self addSubview:_arrowView];
    [_arrowView release];
    
        //  初始化状态提示文本
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    _stateLabel.font = [UIFont systemFontOfSize:12.0f];
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.textAlignment = UITextAlignmentCenter;
    _stateLabel.text = _viewType == GridStateViewTypeHeader ? @"下拉可以刷新" : @"上拖加载更多";
    _stateLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_stateLabel];
    [_stateLabel release];
    
        //  初始化更新时间提示文本
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, k_STATE_VIEW_HEIGHT - 20)];
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = UITextAlignmentCenter;
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    _timeLabel.text = [NSString stringWithFormat:@"上次刷新时间 %@", [formatter stringFromDate:date]];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_timeLabel];
    [formatter release];
    [_timeLabel release];
}

- (void)changeState:(GridStateViewState)p_state {
    [_indicatorView stopAnimating];
    _arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    _currentState = p_state;
    switch (p_state) {
        case GridStateViewStateNormal:
            _stateLabel.text = _viewType == GridStateViewTypeHeader ? @"下拉可以刷新" : @"上拖加载更多";
                //  旋转箭头
            _arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
        case GridStateViewStatePullDown:
            _stateLabel.text = @"释放刷新数据";
            _arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case GridStateViewStateDragUp:
            _stateLabel.text = @"释放加载数据";
            _arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case GridStateViewStateLoading:
            _stateLabel.text = _viewType == GridStateViewTypeHeader ? @"正在刷新.." : @"正在加载..";
            [_indicatorView startAnimating];
            _arrowView.hidden = YES;
            break;
            
        case GridStateViewStateEnd:
            _stateLabel.text = _viewType == GridStateViewTypeHeader ? _stateLabel.text : @"已加载全部数据";
            _arrowView.hidden = YES;
            break;
            
        default:
            _currentState = GridStateViewStateNormal;
            _stateLabel.text = _viewType == GridStateViewTypeHeader ? @"下拉可以刷新" : @"上拖加载更多";
            _arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
    }
    [UIView commitAnimations];
}

- (void)updateTimeLabel {
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    _timeLabel.text = [NSString stringWithFormat:@"上次刷新时间 %@", [formatter stringFromDate:date]];
    [formatter release];
}

@end
