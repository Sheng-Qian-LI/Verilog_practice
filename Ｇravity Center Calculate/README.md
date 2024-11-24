# Gravity Center Calculate 

## 0️⃣Introducton

<div align="center">
  <img src="https://github.com/user-attachments/assets/354a8a42-2b67-4ab4-a5d7-d5b68c2abb2d" alt="image" width="400">
</div>



## 1️⃣Input/Output Interface

<div align="center">

| Signal Name |    I/O    | Width | Description                                    |
|-------------|-----------|-------|------------------------------------------------|
| `CLK`       | Input     | 1     | System clock signal, positive-edge triggered.  |
| `RESET`     | Input     | 1     | Active-low asynchronous system reset signal.   |
| `Xi`        | Input     | 8     | X-coordinate of the input point (range: 0–255).|
| `Yi`        | Input     | 8     | Y-coordinate of the input point (range: 0–255).|
| `Wi`        | Input     | 4     | Weight of the input point (range: 1–15).       |
| `READY`     | Output    | 1     | Computation complete signal (active-low).      |
| `Xc`        | Output    | 8     | X-coordinate of the centroid (range: 0–255).   |
| `Yc`        | Output    | 8     | Y-coordinate of the centroid (range: 0–255).   |

</div>

## 2️⃣Function
#### 本題目設計為 Gravity Center Calculator (簡稱 GCC)。GCC 計算的重心座標需參考輸入的座標 Xi、Yi 及其權重 Wi，輸入由 testbench 提供，當輸入的座標累積至 6 個時，重心座標的輸出應隨之更新。當輸入超過 6 個座標點時，需移除距重心最遠的點，然後計算新的重心，最後將目前最新的 6 個點的重心座標輸出。

---
#### This project is designed as a Gravity Center Calculator (GCC). The GCC calculates the coordinates of the center of gravity based on the provided coordinates Xi, Yi, and their corresponding weights Wi. The input will be supplied by a testbench, and once a total of six coordinates have been accumulated, the center of gravity coordinates will be updated accordingly.
#### If more than six coordinate points are inputted, the point that is farthest from the center of gravity will be removed. Subsequently, the new center of gravity will be calculated, and the coordinates of the latest six points will be outputted. Let me know if you need any further modifications!
---

<div align="center">
  <img src="https://github.com/user-attachments/assets/8833af88-6f8f-4b17-9b7d-8897de8b1892" alt="image" width="400">
</div>



## 3️⃣Algorithm


#### 📌重心公式(Centroid Calculation Formula)：
$$
G_x = \frac{\sum_{i=1}^n x_i \cdot w_i}{\sum_{i=1}^n w_i}, \quad
G_y = \frac{\sum_{i=1}^n y_i \cdot w_i}{\sum_{i=1}^n w_i}
$$

#### 📌四捨五入公式(Rounding formula)：
$$
  (Dividend + Divisor / 2) / Divisor
$$



## 4️⃣Result
![image](https://github.com/user-attachments/assets/b3e5e485-c954-4c42-8e51-de566ed5c1cf)

#### 👉由READY_拉下來後開始計算重心，Xi前六點輸入為(36, 99, 101, 13, 237, 198)，Wi為(10, 14, 2, 14, 10, 11)計算的重心為Xc = 109.475取四捨五入後為109。從Xc的waveform可知在第六個值為109，電路功能正確。

####   第七個點Xi = 229, Wi = 3，此時需要從前六個輸入點尋找與重心距離最遠的點，由計算可知輸入5為最遠的點，將其去除後將第七個點加入計算，可得92.5四捨五入後可得93，與waveform相符。

#### 👉Yi前六點輸入為(129, 13, 18, 118, 140, 197)，重心為Yc = 110.278取四捨五入後為110與waveform一致。。

#### 第七個點Yi = 119, Wi = 3，去除第5個點並加入第七個後計算，可得105.259四捨五入後可得105，與waveform相符。


Sure! Here’s the translation of your text into English:

---

#### 👉 The calculation of the center of gravity begins after pulling down from READY. The first six input points for $$X_i$$ are (36, 99, 101, 13, 237, 198), and the corresponding weights $$W_i$$ are (10, 14, 2, 14, 10, 11). The calculated center of gravity is $$X_c = 109.475$$, which rounds to 109. As seen in the waveform for $$X_c$$, the sixth value is 109, indicating that the circuit functions correctly.

#### The seventh point is $$X_i = 229$$ and $$W_i = 3$$. At this point, we need to find the point among the first six input points that is farthest from the center of gravity. The calculations show that input point 5 is the farthest. After removing this point and adding the seventh point, the new center of gravity is calculated to be 92.5, which rounds to 93 and matches the waveform.

#### 👉 The first six input points for $$Y_i$$ are (129, 13, 18, 118, 140, 197), with a center of gravity of $$Y_c = 110.278$$. This rounds to 110 and is consistent with the waveform.

#### The seventh point is $$Y_i = 119$$ and $$W_i = 3$$. After removing the fifth point and adding the seventh point for recalculation, the new center of gravity is found to be 105.259, which rounds to 105 and aligns with the waveform.

--- 


  

