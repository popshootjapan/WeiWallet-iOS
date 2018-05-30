# wei-ios

## APIs  

### PUT /api/sign
Description: ユーザー作成.  
Request Header:  
- `os`: `ios` or `android`
- `version`: `1.0.0` クライアントAppの現在のバージョン  

Request Body:  
- `address`: イーサリアムアドレス
- `sign`: 文字列 `Welcome to Wei wallet!` に対して署名したメッセージ
- `token`: `DCDevice` クラスで取得できるDeviceCheckトークンをbase64エンコーディングした文字列 (`iOS >= 11`. 10以下は空文字`""`)  

```
{
  "address": "0x3ac622bdccda8f5c7f40c7add1ed84a766011d9d",
  "sign": "0x0076b43083eed557e2c72ff3720381c263f4613fa0927601ca4ff8709c5e72f4062d688716b6b2f39613bd352884ff7b54ee1e94c0b77ef1efa8cb69f04224071b",
  "token": "wlkCDA2Hy/CfrMqVAShs1BAR/0sAiuRIUm5jQg0a..."
}
```

Response:  
- `token`: JWTトークン

```
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZGRyZXNzIjoiMHgzYWM2MjJiZGNjZGE4ZjVjN2Y0MGM3YWRkMWVkODRhNzY2MDExZDlkIn0.UzBQCaR4x9Pt-DOA_NgRzZPX9LIuxH_nXgQtGkalLHY"
}
```