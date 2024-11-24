## 0️⃣Introduction

#### 參考資料 ： [點擊這裡查看文章 (Click here to view the article)](https://wuzhikai.blog.csdn.net/article/details/121152844?ydreferer=aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3d1emhpa2FpZGV0Yi9hcnRpY2xlL2RldGFpbHMvMTIzNDY3NjMwP29wc19yZXF1ZXN0X21pc2M9JTI1N0IlMjUyMnJlcXVlc3QlMjU1RmlkJTI1MjIlMjUzQSUyNTIyNzY1RTQ2RDgtOEQ4OS00MkJCLUExRUEtNjY5OTk1OUE4M0Q0JTI1MjIlMjUyQyUyNTIyc2NtJTI1MjIlMjUzQSUyNTIyMjAxNDA3MTMuMTMwMTAyMzM0LnBjJTI1NUZibG9nLiUyNTIyJTI1N0QmcmVxdWVzdF9pZD03NjVFNDZEOC04RDg5LTQyQkItQTFFQS02Njk5OTU5QTgzRDQmYml6X2lkPTAmdXRtX21lZGl1bT1kaXN0cmlidXRlLnBjX3NlYXJjaF9yZXN1bHQub25lLXRhc2stYmxvZy0yfmJsb2d+Zmlyc3RfcmFua19lY3BtX3YzMV9lY3BtLTE4LTEyMzQ2NzYzMC1udWxsLW51bGwubm9uZWNhc2UmdXRtX3Rlcm09JUU1JUJDJTgyJUU2JUFEJUE1ZmlmbyZzcG09MTAxOC4yMjI2LjMwMDEuNDQ1MA%3D%3D)

<div align="center">
  <img src="https://github.com/user-attachments/assets/ef4f0ade-bcd3-4d82-b4dd-92de49253ce0" alt="image" width="400">
</div>

#### ✏️Spec : [7:0]fifo_buffer[7:0] FIFO寬度8，深度8

#### 📌寫滿定義(Full) : CLK1 wr_ptr 追上 CLK2 rd_ptr  
#### Q : 要怎麼知道是否寫滿?
#### A : 將 CLK2 rd_ptr 同部給 CLK1 wr_ptr 做判斷。 
#### 原因 : 如果 CLK2 rd_ptr 傳完後繼續讀是沒問題的，只是可能浪費FIFO深度(假寫滿)；反之，如果將 CLK1 wr_ptr 傳給 rd_ptr 可能在傳輸過程又有繼續 wr_ptr 造成實際 wr_ptr 已經寫到更後面超過 rd_ptr 的指標，導致太晚寫滿的錯誤。

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

#### 📌讀空定義(Empty) : CLK2 rd_ptr 追上 CLK1 wr_ptr  
#### Q : 要怎麼知道是否讀空?
#### A : 將 CLK1 wr_ptr 同部給 CLK2 rd_ptr 做判斷。 
#### 原因 : 如果 CLK1 wr_ptr 傳完後繼續寫是沒問題的，只是可能浪費FIFO深度(假讀空)；反之，如果將 CLK2 rd_ptr 傳給 wr_ptr 可能在傳輸過程又有繼續 rd_ptr 造成實際 rd_ptr 已經讀到更後面超過 wr_ptr 的指標，導致太晚讀空的錯誤。

Here’s the translation of your text into English:

---

#### ✏️ Spec: [7:0] fifo_buffer[7:0] FIFO width 8, depth 8

#### 📌 Definition of Full: CLK1 write pointer (wr_ptr) catches up to CLK2 read pointer (rd_ptr)  
#### Q: How can we determine if the FIFO is full?  
#### A: Compare the CLK2 rd_ptr with the CLK1 wr_ptr.  
#### Reason: If the CLK2 rd_ptr has finished transmitting and continues to read, it is not a problem; it may just waste FIFO depth (false full). Conversely, if we compare the CLK1 wr_ptr with the rd_ptr, there might be a situation where the wr_ptr has continued to advance during the transmission process, causing the actual wr_ptr to exceed the rd_ptr. This could lead to a late indication of being full.

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

#### 📌 Definition of Empty: CLK2 rd_ptr catches up to CLK1 wr_ptr  
#### Q: How can we determine if the FIFO is empty?  
#### A: Compare the CLK1 wr_ptr with the CLK2 rd_ptr.  
#### Reason: If the CLK1 wr_ptr has finished transmitting and continues to write, it is not a problem; it may just waste FIFO depth (false empty). Conversely, if we compare the CLK2 rd_ptr with the wr_ptr, there might be a situation where the rd_ptr has continued to advance during the transmission process, causing the actual rd_ptr to exceed the wr_ptr. This could lead to a late indication of being empty.

--- 


#### 📌Gray code
<div align="center">
  
| Decimal | Binary | Gray Code |     
|---------|--------|-----------|
|    0    |  0000  |   0000    |
|    1    |  0001  |   0001    |
|    2    |  0010  |   0011    |
|    3    |  0011  |   0010    |
|    4    |  0100  |   0110    |
|    5    |  0101  |   0111    |
|    6    |  0110  |   0101    |
|    7    |  0111  |   0100    |
|    8    |  1000  |   1100    |
|    9    |  1001  |   1101    |
|   10    |  1010  |   1111    |
|   11    |  1011  |   1110    |
|   12    |  1100  |   1010    |
|   13    |  1101  |   1011    |
|   14    |  1110  |   1001    |
|   15    |  1111  |   1000    |

</div>

#### 使用Gray code原因為每次變動都只改變1 bit

---
#### The reason for using Gray code is that each change only modifies one bit at a time.
---

### ⭐⭐⭐ Binary to Gray code equation : Gray code = (Binary >> 1) ^ Binary  ⭐⭐⭐

## 1️⃣Function

#### 透過增加一個bit來判斷寫滿或讀空Gray code 
#### 1. 前2位元不同，其餘相同代表寫滿。
#### 2. 前2位元相同，其餘相同代表讀空。

---
#### By adding an extra bit to determine if the FIFO is full or empty using Gray code:
#### If the first two bits are different and the remaining bits are the same, it indicates that the FIFO is full.
#### If the first two bits are the same and the remaining bits are the same, it indicates that the FIFO is empty.
---

## 2️⃣Result
![image](https://github.com/user-attachments/assets/8ecbd7cb-439f-4c90-b9fb-4a51789ef2b4)

#### 一開始wr_en先拉起來，data_in開始寫入，寫到第8個值時 full 拉起來，代表 FIFO buffer 滿了；接著rd_en拉起，data_out輸出，讀完第8個值時 empty 拉起來，代表 FIFO buffer 空了。
#### 最後測試連續同時寫入和讀取的功能也正常。

---
#### Initially, the wr_en signal is asserted, and data_in begins to be written. When the eighth value is written, the full signal is asserted, indicating that the FIFO buffer is full. Next, the rd_en signal is asserted, and data_out outputs the data. When the eighth value is read, the empty signal is asserted, indicating that the FIFO buffer is empty.
#### Finally, testing for simultaneous continuous writing and reading functions correctly as well. Let me know if you need any further assistance!

---



