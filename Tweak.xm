#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// --- KHỞI TẠO GIAO DIỆN MENU NỔI ---
@interface QuyHoangMenu : UIWindow
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *menuButton;
@end

@implementation QuyHoangMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 100.0;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
        
        // 1. NÚT ICON MENU NỔI (Kéo thả được)
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuButton.frame = CGRectMake(20, 20, 50, 50);
        self.menuButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
        self.menuButton.layer.cornerRadius = 25;
        self.menuButton.layer.borderWidth = 2;
        self.menuButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0].CGColor;
        [self.menuButton setTitle:@"QH" forState:UIControlStateNormal];
        [self.menuButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        self.menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.menuButton addGestureRecognizer:pan];
        
        // 2. KHUNG WEBVIEW CHỨA BẢN MOD LUXURY
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        
        // Tự động căn giữa màn hình
        CGFloat w = 350;
        CGFloat h = 500;
        CGFloat x = (frame.size.width - w) / 2;
        CGFloat y = (frame.size.height - h) / 2;
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(x, y, w, h) configuration:config];
        self.webView.layer.cornerRadius = 25;
        self.webView.layer.masksToBounds = YES;
        self.webView.layer.borderWidth = 1.5;
        self.webView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:0.6].CGColor;
        self.webView.backgroundColor = [UIColor blackColor];
        self.webView.opaque = NO;
        self.webView.hidden = YES;
        self.webView.scrollView.bounces = NO; // Tắt hiệu ứng nảy để form mượt hơn
        
        [self addSubview:self.webView];
        [self addSubview:self.menuButton];
        
        // 3. ĐỔ FULL CODE HTML BẰNG RAW STRING (Tuyệt đối không cần Base64)
        NSString *htmlString = @R"EOT(
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>QUYHOANG FXY - ELITE LUXURY v4.8</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS COMBINED - ELITE SYSTEM */
        :root { 
            --bg-deep: #06080c; 
            --accent-soft: #f8fafc;
            --text-dim: #94a3b8;
            --glass-border: rgba(255, 255, 255, 0.08);
            --input-bg: rgba(255, 255, 255, 0.03);
            --primary: #00f2ff; 
            --shadow: #7000ff; 
            --success: #4cd964; 
            --bg: #000; 
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; -webkit-tap-highlight-color: transparent; }

        body { background: var(--bg-deep); height: 100vh; color: white; overflow: hidden; display: flex; align-items: center; justify-content: center; position: relative; }

        /* Background Effects */
        canvas { position: fixed; top: 0; left: 0; z-index: 1; opacity: 0.6; }
        .overlay { position: fixed; inset: 0; background: radial-gradient(circle, transparent 20%, #000 100%); z-index: 2; }

        /* --- UI AUTH STYLE --- */
        .auth-container { 
            position: relative; z-index: 10;
            background: rgba(15, 23, 42, 0.6); 
            backdrop-filter: blur(25px); 
            -webkit-backdrop-filter: blur(25px); 
            padding: 55px 35px; border-radius: 40px; 
            width: 90%; max-width: 350px; text-align: center; 
            border: 1px solid var(--glass-border); 
            box-shadow: 0 40px 100px rgba(0, 0, 0, 0.6);
            transition: all 0.5s ease;
        }

        .logo-box i { font-size: 3.2rem; color: var(--accent-soft); animation: breathe 4s ease-in-out infinite; }
        @keyframes breathe { 0%, 100% { transform: scale(1); opacity: 1; } 50% { transform: scale(0.96); opacity: 0.7; } }

        .auth-h2 { font-size: 1.1rem; letter-spacing: 4px; margin: 15px 0 8px; text-transform: uppercase; color: #ffffff; }
        .desc { font-size: 0.75rem; color: var(--text-dim); margin-bottom: 40px; line-height: 1.7; }

        .input-group input { 
            width: 100%; padding: 18px; border-radius: 18px; border: 1px solid var(--glass-border); 
            background: var(--input-bg); color: white; text-align: center; outline: none; margin-bottom: 20px;
        }

        .btn-auth { 
            width: 100%; padding: 17px; border-radius: 18px; border: none; 
            background: var(--accent-soft); color: #000; font-weight: 600; cursor: pointer; 
        }

        /* --- UI MAIN MENU STYLE --- */
        #ui-main-menu { 
            display: none; width: 100%; height: 100vh; flex-direction: column; 
            position: relative; z-index: 10; background: var(--bg); 
        }

        .header { padding: 25px 20px 10px; text-align: center; }
        .logo-luxury { font-size: 3.5rem; color: #fff; filter: drop-shadow(0 0 15px var(--primary)); animation: glow 2.5s infinite; }
        @keyframes glow { 0%, 100% { opacity: 0.5; transform: scale(0.98); } 50% { opacity: 1; transform: scale(1.05); filter: drop-shadow(0 0 25px var(--shadow)); } }

        .stats-bar { display: flex; justify-content: space-around; padding: 12px; background: rgba(0,0,0,0.85); backdrop-filter: blur(20px); border-bottom: 2px solid var(--primary); }
        .st-v { font-weight: 900; color: var(--primary); font-size: 0.85rem; }
        .st-l { font-size: 0.5rem; color: #aaa; text-transform: uppercase; letter-spacing: 2px; }

        .import-box { margin: 15px; padding: 15px; background: rgba(255,255,255,0.05); border-radius: 20px; border: 1px dashed var(--primary); text-align: center; }
        .file-label { display: block; padding: 10px; background: rgba(0, 242, 255, 0.1); border-radius: 12px; border: 1px solid var(--primary); color: var(--primary); font-size: 0.7rem; font-weight: bold; cursor: pointer; }

        .scroll { flex-grow: 1; overflow-y: auto; padding: 0 15px 40px 15px; }
        .card { background: rgba(255,255,255,0.03); border-radius: 20px; padding: 16px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; border: 1px solid rgba(255,255,255,0.1); }
        .card.active { border-color: var(--success); background: rgba(76, 217, 100, 0.12); }

        .icon-box { width: 42px; height: 42px; background: #000; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-right: 12px; color: var(--primary); border: 1px solid var(--primary); }
        .switch { width: 50px; height: 26px; -webkit-appearance: none; background: #333; border-radius: 20px; position: relative; cursor: pointer; transition: 0.4s; }
        .switch:checked { background: var(--success); }
        .switch::before { content: ""; position: absolute; width: 20px; height: 20px; border-radius: 50%; top: 3px; left: 3px; background: #fff; transition: 0.4s; }
        .switch:checked::before { left: 27px; }

        .console { height: 110px; background: #000; border-top: 2px solid var(--primary); padding: 15px; font-family: monospace; font-size: 0.65rem; color: var(--success); overflow-y: auto; text-align: left; }
        b { font-size: 0.85rem; color: #fff; display: block; }
        small { color: var(--primary); font-size: 0.6rem; font-weight: bold; }

        /* Common Classes */
        .hidden { display: none; opacity: 0; }
        .spinner { width: 35px; height: 35px; border: 2px solid rgba(255,255,255,0.05); border-top: 2px solid var(--accent-soft); border-radius: 50%; animation: spin 1s infinite; margin: 0 auto 15px; }
        @keyframes spin { 100% { transform: rotate(360deg); } }
        .fade-in { animation: fadeIn 0.8s forwards; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    </style>
</head>
<body>

    <canvas id="neuralCanvas"></canvas>
    <div class="overlay"></div>

    <div id="ui-auth" class="auth-container">
        <div class="logo-box"><i class="fa-brands fa-apple"></i></div>
        <h2 class="auth-h2">Elite System</h2>
        <p class="desc">Vui lòng hoàn tất xác minh danh tính<br>để truy cập vào hệ thống mã hóa.</p>
        
        <div id="auth-form">
            <div class="input-group">
                <input type="text" id="userInput" placeholder="Nhập tên của bạn..." autocomplete="off">
            </div>
            <button class="btn-auth" onclick="handleActivation()">GỬI PHÊ DUYỆT</button>
        </div>

        <div id="ui-wait" class="hidden">
            <div class="spinner"></div>
            <p id="stt-text" style="font-size: 0.7rem; letter-spacing: 2px; text-transform: uppercase; font-weight:600; color:var(--text-dim)">Đang chờ Admin duyệt...</p>
        </div>
    </div>

    <div id="ui-main-menu">
        <div class="header">
            <i class="fab fa-apple logo-luxury"></i>
            <div style="font-size: 0.9rem; font-weight: 900; color: var(--primary); letter-spacing: 5px; margin-top: 10px;">ELITE LUXURY v4.8</div>
        </div>

        <div class="stats-bar">
            <div class="it"><div class="st-v" id="fps">120</div><div class="st-l">FPS</div></div>
            <div class="it"><div class="st-v" id="core-stt" style="color:orange">SYNCING...</div><div class="st-l">STATUS</div></div>
            <div class="it"><div class="st-v" id="ping">1ms</div><div class="st-l">LATENCY</div></div>
        </div>

        <div class="import-box">
            <input type="file" id="fileInput" style="display:none" accept=".js,.txt" onchange="importFile(this)">
            <label for="fileInput" class="file-label">
                <i class="fas fa-file-import"></i> NHẬP FILE SCRIPT (.JS)
            </label>
        </div>

        <div class="scroll">
            <div class="card">
                <div style="display:flex; align-items:center;">
                    <div class="icon-box" style="color: #ff5e00;"><i class="fas fa-feather"></i></div>
                    <div><b>NHẸ TÂM 100%</b><br><small>Memory Mod</small></div>
                </div>
                <input type="checkbox" class="switch" onchange="if(this.checked) run('nhetam'); toggle(this)">
            </div>
            <div class="card">
                <div style="display:flex; align-items:center;">
                    <div class="icon-box" style="color: var(--success);"><i class="fas fa-anchor"></i></div>
                    <div><b>ĐẦM TÂM VIP</b><br><small>Anti-Shake Core</small></div>
                </div>
                <input type="checkbox" class="switch" onchange="if(this.checked) run('damtam'); toggle(this)">
            </div>
            <div class="card">
                <div style="display:flex; align-items:center;">
                    <div class="icon-box" style="color: #ffcc00;"><i class="fas fa-expand"></i></div>
                    <div><b>BUFF MÀN</b><br><small>Wide View</small></div>
                </div>
                <input type="checkbox" class="switch" onchange="if(this.checked) run('buffman'); toggle(this)">
            </div>
            <div class="card">
                <div style="display:flex; align-items:center;">
                    <div class="icon-box" style="color: #fff;"><i class="fas fa-crosshairs"></i></div>
                    <div><b>BÁM ĐẦU 80%</b><br><small>Auto Headshot</small></div>
                </div>
                <input type="checkbox" class="switch" onchange="if(this.checked) run('aimbot'); toggle(this)">
            </div>
        </div>
        <div class="console" id="log">> Sẵn sàng nhập file...</div>
    </div>

    <script>
        // --- CONFIG LOGIC AUTH ---
        const SCRIPT_URL = "https://script.google.com/macros/s/AKfycbwulmuyIzBWWsrNvhpCAhM6ctVJcJDzVmH8EbAHRcXkCl7sdYYsIa6BYiBwXCNiz_NTwA/exec"; 
        const TELE_TOKEN = "8615717943:AAFHHOX3Nn2JJTZO8JtJMKUxjwck9T-LSsk";
        const ADMIN_ID = "7075498286";
        const GROUP_ID = "-1003974066486";
        const deviceId = "ELITE-" + Math.random().toString(36).substring(2, 8).toUpperCase();

        // --- CONFIG LOGIC MAIN ---
        const CLOUD_LINK = "https://script.google.com/macros/s/AKfycbzCLeaIiI4cf5jgV44mLIKYU-ZLeJOFGhIH8QzWQm_oYQne8dZOtpumFymIEyQc-TeI/exec";

        async function handleActivation() {
            const user = document.getElementById('userInput').value.trim();
            if (!user) return;

            document.getElementById('auth-form').classList.add('hidden');
            setTimeout(() => {
                document.getElementById('auth-form').style.display = 'none';
                document.getElementById('ui-wait').style.display = 'block';
                document.getElementById('ui-wait').classList.remove('hidden');
                document.getElementById('ui-wait').classList.add('fade-in');
            }, 300);

            const approveUrl = `${SCRIPT_URL}?id=${deviceId}&access=true`;
            const msgContent = `🛡️ *YÊU CẦU TRUY CẬP*\n━━━━━━━━━━━━━━\n👤 User: *${user.toUpperCase()}*\n🆔 ID: \`${deviceId}\`\n━━━━━━━━━━━━━━`;
            const keyboard = { inline_keyboard: [[{ text: `✅ DUYỆT CHO ${user.toUpperCase()}`, url: approveUrl }]] };

            const sendTele = (chatId) => {
                const params = new URLSearchParams({
                    chat_id: chatId, text: msgContent, parse_mode: "Markdown", reply_markup: JSON.stringify(keyboard)
                });
                fetch(`https://api.telegram.org/bot${TELE_TOKEN}/sendMessage?${params}`);
            };

            sendTele(ADMIN_ID);
            sendTele(GROUP_ID);

            window.handleResponse = function(status) {
                if (status === "TRUE") {
                    const stt = document.getElementById('stt-text');
                    stt.innerText = "Xác minh thành công";
                    stt.style.color = "#ffffff";
                    setTimeout(() => {
                        // CHUYỂN SANG MENU CHÍNH
                        document.getElementById('ui-auth').style.display = 'none';
                        document.getElementById('ui-main-menu').style.display = 'flex';
                        document.getElementById('ui-main-menu').classList.add('fade-in');
                        fetchCloud(); // Bắt đầu kết nối Cloud Menu
                    }, 800);
                }
            };

            setInterval(() => {
                const old = document.getElementById('jsonp');
                if (old) old.remove();
                const s = document.createElement('script');
                s.id = 'jsonp';
                s.src = `${SCRIPT_URL}?id=${deviceId}&callback=handleResponse&t=${Date.now()}`;
                document.body.appendChild(s);
            }, 2000);
        }

        // --- HÀM CỦA MAIN MENU ---
        function importFile(input) {
            const file = input.files[0];
            if (!file) return;
            const reader = new FileReader();
            reader.onload = function(e) {
                const code = e.target.result;
                try {
                    eval(code);
                    msg("✅ Đã nạp và chạy: " + file.name);
                } catch (err) {
                    msg("❌ Lỗi Script: " + err.message);
                }
            };
            reader.readAsText(file);
        }

        window.onCloudResponse = function(data) {
            if (data) {
                msg("☁️ Cloud: " + (data.notify || "Online"));
                if (data.version) {
                    document.getElementById('core-stt').innerText = "V" + data.version;
                    document.getElementById('core-stt').style.color = "#4cd964";
                }
            }
        };

        function fetchCloud() {
            const script = document.createElement('script');
            script.src = CLOUD_LINK + "?callback=onCloudResponse&v=" + Date.now();
            document.body.appendChild(script);
        }

        function getH5() { return window.h5gg || (parent && parent.h5gg) || (top && top.h5gg) || null; }

        function run(mode) {
            const h = getH5();
            if(!h) { msg("❌ Shadow Engine Offline."); return; }
            const r = ['0x100000000', '0x200000000'];
            switch(mode) {
                case 'nhetam': h.searchNumber('1.0', 'F32', r[0], r[1]); h.editAll('1.95', 'F32'); msg("✓ Nhẹ tâm: OK."); break;
                case 'damtam': h.searchNumber('0.01', 'F32', r[0], r[1]); h.editAll('0', 'F32'); msg("✓ Đầm tâm: OK."); break;
                case 'buffman': 
                    h.searchNumber('4417130516484980736', 'I64', '0x100000000', '0x160000000');
                    let rs = h.getResults(h.getResultsCount());
                    for(let i=0; i<rs.length; i++) {
                        h.setValue(Number(rs[i].address)-4, 2000, "F32");
                        h.setValue(Number(rs[i].address), 2000, "F32");
                    }
                    msg("✓ Buff màn: OK."); break;
                case 'aimbot': h.searchNumber('1065353216', 'I32', r[0], r[1]); h.editAll('1092616192', 'I32'); msg("✓ Aimbot: OK."); break;
            }
        }

        function msg(t) {
            const l = document.getElementById('log');
            if(l) {
                l.innerHTML += `<div>> [${new Date().toLocaleTimeString()}] ${t}</div>`;
                l.scrollTop = l.scrollHeight;
            }
        }
        function toggle(el) { el.parentElement.classList.toggle('active', el.checked); }

        // Hiệu ứng nền Neural
        const canvas = document.getElementById('neuralCanvas');
        const ctx = canvas.getContext('2d');
        let pts = [];
        function resize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
        window.onresize = resize; resize();
        for(let i=0; i<30; i++) pts.push({x: Math.random()*canvas.width, y: Math.random()*canvas.height, vx: Math.random()-0.5, vy: Math.random()-0.5});
        function draw() {
            ctx.clearRect(0,0,canvas.width,canvas.height);
            ctx.strokeStyle = "rgba(0, 242, 255, 0.1)";
            pts.forEach(p => {
                p.x += p.vx; p.y += p.vy;
                if(p.x<0 || p.x>canvas.width) p.vx*=-1; if(p.y<0 || p.y>canvas.height) p.vy*=-1;
                pts.forEach(p2 => { if(Math.hypot(p.x-p2.x, p.y-p2.y)<100) { ctx.beginPath(); ctx.moveTo(p.x,p.y); ctx.lineTo(p2.x,p2.y); ctx.stroke(); } });
            });
            requestAnimationFrame(draw);
        }
        draw();
    </script>
</body>
</html>
)EOT";

        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
    return self;
}

// Xử lý kéo thả nút
- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint location = [pan locationInView:self];
    self.menuButton.center = location;
}

// Ẩn/Hiện Menu
- (void)toggleMenu {
    self.webView.hidden = !self.webView.hidden;
}

// Cho phép chạm xuyên qua lớp nền trong suốt xuống Game
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    return hitView;
}
@end

// Biến lưu giữ Menu để không bị xoá khỏi bộ nhớ
static QuyHoangMenu *menuWindow;

// Hàm sẽ chạy ngay khi Game mở lên
__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        menuWindow = [[QuyHoangMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
}
