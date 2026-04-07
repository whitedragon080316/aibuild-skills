---
name: zeabur
description: Zeabur 部署管理（專案建立、服務部署、環境變數、網域綁定）
user_invocable: true
---

# Zeabur 操作

Zeabur 專案建立、服務部署、環境變數設定、網域綁定、重啟與除錯。

## 使用方式

`/zeabur` — 顯示可用操作

## 必要條件

- Zeabur 帳號（已綁信用卡）
- Zeabur CLI 已安裝：`npm i -g zeabur`

## 常用操作

### 部署專案

```bash
cd ~/你的專案
npx zeabur@latest deploy
```

### 設定環境變數

Zeabur Dashboard → 你的 Service → Variables → 新增。

**⚠️ Zeabur variable env 是覆蓋模式，要放全部 env vars，不是只放新增的。**

### 綁定網域

Zeabur Dashboard → 你的 Service → Networking → Custom Domain。

建議用自訂 domain，Zeabur 子網域的 SSL 憑證鏈有時會被 LINE 拒絕。

### 重啟服務

Zeabur Dashboard → 你的 Service → Deployments → Redeploy。

**⚠️ OOM 後要 Redeploy 不是 Restart。**

### 查看 Logs

Zeabur Dashboard → 你的 Service → Logs。

## 部署前 Checklist

1. 確認正確的 Service ID（曾多次部署到錯的 service）
2. 確認環境變數完整（覆蓋模式，要全部放）
3. 確認 server 記憶體足夠（至少 512MB），避免 OOM
4. 自訂 domain 優先於 Zeabur 子網域
5. 部署完逐項驗證功能

## ⚠️ 常見踩坑

| 問題 | 解法 |
|------|------|
| 部署到錯的 service | 部署前確認 service ID |
| 環境變數消失 | Zeabur variable 是覆蓋模式，要放全部 |
| OOM 斷線 | Redeploy（不是 Restart） |
| SSL 憑證被 LINE 拒絕 | 用自訂 domain |
| 服務遷移出問題 | 先建新測通再刪舊，NEVER 先刪後救 |
