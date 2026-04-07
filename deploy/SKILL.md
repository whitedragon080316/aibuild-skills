---
name: deploy
description: 一鍵部署 aibuild-bot + aibuild-web 到 Zeabur
user_invocable: true
---

# 一鍵部署

學員說 `/deploy`，Claude Code 全自動完成部署。學員不需要打開任何網頁或後台。

## 流程總覽

1. Clone 模板到本機
2. 部署 Bot 到 Zeabur
3. 設定 Bot 環境變數
4. 部署 Web 到同一專案
5. 設定 Web 環境變數
6. 加 MongoDB
7. 綁定網域
8. 設定 LINE Webhook
9. 驗證全部服務

---

## 執行規則

- 一次只問學員一個問題
- 學員給值，Claude Code 立刻用 CLI 設好，不叫學員去任何後台
- 所有 Zeabur 操作用 `npx zeabur@latest` CLI 完成
- 所有 LINE 設定用 LINE Messaging API 完成
- 能自動判斷的就不要問

---

## Step 1：Clone 模板

直接執行，不需要問學員：

```bash
cd ~
git clone https://github.com/whitedragon080316/aibuild-bot.git
git clone https://github.com/whitedragon080316/aibuild-web.git
```

---

## Step 2：收集資訊（一次問一個）

依序問學員以下資訊，每次只問一個，拿到答案再問下一個：

1. 「你的品牌名是什麼？（例如：知脊整聊學院）」
2. 「你的名字？（講師名，會顯示在課程裡）」
3. 「課程名稱？（例如：AI 造局術）」
4. 「課程售價？（數字就好，例如 49800）」
5. 「你的 LINE Channel Access Token？（到 LINE Developers Console > 你的 Channel > Messaging API > Channel access token 複製）」
6. 「你的 LINE Channel Secret？（同頁面上方 Basic settings > Channel secret）」
7. 「你的 LINE User ID？（同頁面 Basic settings > Your user ID）」
8. 「你的 TapPay Partner Key？」
9. 「你的 TapPay Merchant ID？」
10. 「你的 TapPay App ID？」
11. 「你的 TapPay App Key？」
12. 「你的 Meta Pixel ID？（沒有的話先跳過）」

收到每個值後，先存起來，全部收完再一次設定。

---

## Step 3：部署 Bot

```bash
cd ~/aibuild-bot
npx zeabur@latest deploy
```

Claude Code 操作：
- 建立新專案，名稱用品牌名轉 kebab-case
- 地區選 Tokyo

部署完成後，用 Zeabur CLI 設定所有環境變數：

```
LINE_CHANNEL_TOKEN=（學員給的值）
LINE_CHANNEL_SECRET=（學員給的值）
ADMIN_USER_ID=（學員給的值）
BRAND_NAME=（學員給的值）
INSTRUCTOR_NAME=（學員給的值）
SYSTEM_NAME=（學員給的值）
COURSE_NAME=（學員給的值）
COURSE_PRICE=（學員給的值）
```

---

## Step 4：部署 Web

```bash
cd ~/aibuild-web
npx zeabur@latest deploy
```

選同一個專案，讓兩個 service 在同一個 project。

部署完成後設定環境變數：

```
SITE_NAME=（課程名稱）
BRAND_NAME=（品牌名）
PUBLIC_BASE_URL=（部署後取得的 URL）
LINE_CHANNEL_TOKEN=（同上）
LINE_CHANNEL_SECRET=（同上）
TAPPAY_PARTNER_KEY=（學員給的值）
TAPPAY_MERCHANT_ID=（學員給的值）
TAPPAY_APP_ID=（學員給的值）
TAPPAY_APP_KEY=（學員給的值）
TAPPAY_ENV=sandbox
META_PIXEL_ID=（學員給的值，沒有就不設）
```

---

## Step 5：加 MongoDB

用 Zeabur CLI 在同一個專案加 MongoDB service。MONGODB_URI 會自動注入。

---

## Step 6：綁定網域

用 Zeabur CLI 幫 aibuild-web 綁定 Zeabur 子網域。取得 URL 後回填 PUBLIC_BASE_URL。

---

## Step 7：設定 LINE Webhook

用 LINE Messaging API 自動設定：
- Webhook URL 設為 `https://bot服務網域/webhook`
- 開啟 Use webhook
- 關閉 Auto-reply messages
- 關閉加入好友的歡迎訊息

告訴學員：「Webhook 已設定完成。」

---

## Step 8：自動驗證

Claude Code 自動跑以下檢查，逐項報告結果：

**Bot 驗證：**
- [ ] Webhook URL verify 成功
- [ ] Bot service 狀態正常（無 OOM、無 crash）

**Web 驗證：**
- [ ] LP 頁面可正常開啟（curl 回 200）
- [ ] PUBLIC_BASE_URL 正確

**MongoDB 驗證：**
- [ ] MONGODB_URI 已注入
- [ ] MongoDB service 狀態正常

全部通過後告訴學員：「部署完成！用手機加你的 LINE Bot 好友測試看看。」

---

## 常見問題自動修復

| 症狀 | Claude Code 自動做 |
|------|-------------------|
| Webhook Verify 失敗 | 檢查 Bot service 狀態、Channel Secret 是否正確，自動修正 |
| MongoDB 連不上 | 確認在同一個 project，重新注入 MONGODB_URI |
| LP 打不開 | 檢查 PUBLIC_BASE_URL、重新綁定網域 |
| 部署後 OOM | 檢查 Zeabur plan，提醒學員升級到至少 512MB |

---

## 上線切換

學員說「我要上線」時，Claude Code 自動改：

```
TAPPAY_ENV=production
```

然後問學員：
- 「正式的 Meta Pixel ID？（如果之前用測試的）」
- 「正式網域？（如果要換自訂網域）」

拿到值後立刻用 CLI 更新，不需要學員去任何後台。
