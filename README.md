# README

【施工中】每個月算薪水算到崩潰，就交給系統來算吧 XD

## 安裝
這只是個普通的 Rails app，用普通的 Rails app 安裝方式就可以了

- Ruby 2.5.0
- Rails 5.1.4
- PostgreSQL 9.4.4

### 使用方法
- 先到 http://localhost:3000/employees/ 建員工資料和薪資資料
- 再到 http://localhost:3000/payrolls/ 產生薪資單
- 基本資料設定在 `config/application.yml`
- 以上 XD

#### 測試資料
- `rake db:seed`

#### 匯入資料

檔案格式請參考 `lib/tasks/sample.csv`：

`$ rake import:csv file=path/to/csv`

#### 匯出資料

匯出給網路銀行用的轉帳資料（請依自己需求修改）：

`$ rake export:csv year=2018 month=1 path=path/to/export paydate=yyyymmdd`

匯出當月份的全部薪資明細表：

`$ rake export:pdf year=2018 month=1 path=path/to/export`

將薪資明細表寄給同事（真的會整批寄出，不要按錯）：

`$ rake export:email year=2018 month=1`

### 注意事項
- 百廢待舉，還沒有做任何 validation，建資料時請自己注意不要建錯
- 還沒有做任何權限控管，敏感資料請小心輕放
- 每年國定假日、補班等資訊需手動產生，請參考 `config/holidays`
- 勞健保請如實申報並自己查表
- 薪資狀態變動時，要用新建而非修改（目前全是動態計算，所以改舊資料會讓報表失真）
- 除了到職月份以外，之後的調薪薪資起始日期請設在每月一日，且暫不支援同月份內多次調薪

#### PDF 相關

PDF 加密的操作需要安裝 [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)，OSX 上轉檔卡住的話，請參考[本篇解法](https://stackoverflow.com/questions/39750883/pdftk-hanging-on-macos-sierra)。由於加密需要操作實體檔案，請自行建立以下目錄：

```
tmp/pdfs/source
tmp/pdfs/encrypted
``` 

## 可以做到的事情
- CSV 匯入初始資料（員工 + 薪水）
- 一次產生當月的全部薪資單及 PDF
- 設定每月發放的固定津貼和勞健保自費額
- 計算請假扣款、特休換現等每月需要微調的項目
- 可以自訂加減項（如差旅津貼、補收健保費）
- 一例一休加班費計算
- 到職、離職時的不足月調整
- 預扣所得稅計算（不完整）
- 代扣二代健保計算（不完整）
- 執行專業所得自動拆單
- 可以計算每月實際工作日
- 依年月查詢當期發薪紀錄
- 支援實習生轉正職等不同階段薪資計算
- 自動產生匯入網銀用的發薪設定檔
	- 本版本僅支援玉山銀行格式
	- 同時支援薪資轉帳和一般台幣轉帳（皆需事先設定為約定帳戶）
	- 此功能極度個人化，有需要的人請自己 fork 回去客製
- 發薪後自動將以身份證字號加密的 PDF 寄給同事

## 還做不到的事情

- 以月薪自動取得勞保、健保自費額
- 各種資料驗證和防呆（例如月薪制人員可以填時薪 XD）
- 自動產生每年國定假日、補班資訊
- 自請假系統取得請假資訊
- 自工時系統取得時薪制人員工時資料（但是沒有工時系統）
- 將實發金額回傳會計系統（根本沒這系統好嗎） 
- 每年獎金的二代健保和所得稅（需要存健保投保金額）
- 自動產生二代健保申報資料
- 拆單與否的開關
- 支援同一月份內多次調薪（應該會 GG）
- 初期只打算在本機端執行，所以沒有任何安全性可言 XD
- 匯出報表
- 計算年資時，排除留職停薪期間
- 計算平均薪資

## Contributing
Send me a PR!

## License
以 [MIT License](http://opensource.org/licenses/MIT) 開源