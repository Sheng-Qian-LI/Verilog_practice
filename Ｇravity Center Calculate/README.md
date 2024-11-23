# Gravity Center Calculate 

## 0️⃣Introducton

## 1️⃣Algorithm


#### 📌重心公式：
$$
G_x = \frac{\sum_{i=1}^n x_i \cdot w_i}{\sum_{i=1}^n w_i}, \quad
G_y = \frac{\sum_{i=1}^n y_i \cdot w_i}{\sum_{i=1}^n w_i}
$$

#### 📌四捨五入公式：
$$
  (Dividend + Divisor / 2) / Diviso
$$



## 2️⃣Result
![image](https://github.com/user-attachments/assets/b3e5e485-c954-4c42-8e51-de566ed5c1cf)

#### 👉由READY_拉下來後開始計算重心，Xi前六點輸入為(36, 99, 101, 13, 237, 198)，Wi為(10, 14, 2, 14, 10, 11)計算的重心為Xc = 109.475取四捨五入後為109。從Xc的waveform可知在第六個值為109，電路功能正確。

####   第七個點Xi = 229, Wi = 3，此時需要從前六個輸入點尋找與重心距離最遠的點，由計算可知輸入5為最遠的點，將其去除後將第七個點加入計算，可得92.5四捨五入後可得93，與wavefor相符。

#### 👉Yi前六點輸入為(129, 13, 18, 118, 140, 197)，重心為Yc = 110.278取四捨五入後為110與waveform一致。。

#### 第七個點Yi = 119, Wi = 3，去除第5個點並加入第七個後計算，可得105.259四捨五入後可得105，與wavefor相符。
  
### ⭐ Disussion ⭐
##### 14

