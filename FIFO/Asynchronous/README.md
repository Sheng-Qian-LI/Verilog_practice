## 0️⃣Introduction
<div align="center">
  <img src="https://github.com/user-attachments/assets/ef4f0ade-bcd3-4d82-b4dd-92de49253ce0" alt="image" width="400">
</div>

#### 📌寫滿定義(Full) : CLK1 wr_ptr 追上 CLK2 rd_ptr  
#### Q : 要怎麼知道是否寫滿?
#### A : 將 CLK2 rd_ptr 同部給 CLK1 wr_ptr 做判斷。 
#### 原因 : 如果 CLK2 rd_ptr 傳完後繼續讀是沒問題的，只是可能浪費FIFO深度(假寫滿)；反之，如果將 CLK1 wr_ptr 傳給 rd_ptr 可能在傳輸過程又有繼續 wr_ptr 造成實際 wr_ptr 已經寫到更後面超過 rd_ptr 的指標，導致太晚寫滿的錯誤。

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

#### 📌讀空定義(Empty) : CLK2 rd_ptr 追上 CLK1 wr_ptr  
#### Q : 要怎麼知道是否讀空?
#### A : 將 CLK1 wr_ptr 同部給 CLK2 rd_ptr 做判斷。 
#### 原因 : 如果 CLK1 wr_ptr 傳完後繼續寫是沒問題的，只是可能浪費FIFO深度(假讀空)；反之，如果將 CLK2 rd_ptr 傳給 wr_ptr 可能在傳輸過程又有繼續 rd_ptr 造成實際 rd_ptr 已經讀到更後面超過 wr_ptr 的指標，導致太晚讀空的錯誤。


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

#### Binary to Gray code equation : Gray code = (Binary >> 1) ^ Binary  

## 1️⃣Function

#### Gray code 判斷寫滿或讀空
#### 1. 前2位元不同，其餘相同代表寫滿。
#### 2. 前2位元相同，其餘相同代表讀空。


## 2️⃣Result
![image](https://github.com/user-attachments/assets/8ecbd7cb-439f-4c90-b9fb-4a51789ef2b4)

