#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface QuyHoangMenu : UIWindow <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *menuButton;
@end

@implementation QuyHoangMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 100.0;
        self.backgroundColor = [UIColor clearColor];
        [self setHidden:NO];

        // Tạo nút mở Menu
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuButton.frame = CGRectMake(50, 150, 60, 60);
        self.menuButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.menuButton.layer.cornerRadius = 30;
        self.menuButton.layer.borderWidth = 1.5;
        self.menuButton.layer.borderColor = [UIColor cyanColor].CGColor;
        [self.menuButton setTitle:@"FXY" forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(handleToggle) forControlEvents:UIControlEventTouchUpInside];
        
        // Tạo WebView
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 450)];
        self.webView.center = self.center;
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = NO;
        self.webView.layer.cornerRadius = 15;
        self.webView.clipsToBounds = YES;
        [self.webView setHidden:YES];

        // HTML Content sử dụng Raw String để tránh lỗi Code 8
        NSString *htmlContent = @R"EOT(
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { background: rgba(0,0,0,0.8); color: #00f2ff; font-family: Arial; text-align: center; }
                .btn { background: #111; border: 1px solid cyan; color: white; padding: 10px; margin: 5px; width: 80%; border-radius: 8px; }
            </style>
        </head>
        <body>
            <h3>QuyHoang Fxy v4.8</h3>
            <button class="btn" onclick="alert('Đã kích hoạt!')">BUFF SKILL</button>
            <button class="btn">ANTIBAN</button>
        </body>
        </html>
        )EOT";

        [self.webView loadHTMLString:htmlContent baseURL:nil];
        [self addSubview:self.webView];
        [self addSubview:self.menuButton];
    }
    return self;
}

- (void)handleToggle {
    self.webView.hidden = !self.webView.hidden;
}

@end

static QuyHoangMenu *mainMenu;

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainMenu = [[QuyHoangMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
}
%end
