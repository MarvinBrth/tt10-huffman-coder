![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg)

# Huffman Coder

## 🔠 What is the Huffman_Coder?
The Huffman_Coder ASIC implements Huffman encoding, a lossless compression method that optimizes storage and transmission by assigning **shorter codes to frequent symbols** and **longer codes to rare ones**. This implementation uses a **static Huffman tree based on English letter frequencies**.

___

## 🔍 Modern Applications
✅ 📁 File Compression → ZIP, GZIP, 7z, PNG  
✅ 🎵 Audio & Video → MP3, FLAC, JPEG, H.264  
✅ 📡 Data Transmission → Fax, telephony, network protocols  
✅ 📚 Text Compression → PDF, PostScript, text file formats  

___

## 💾 Huffman Frequency Data  
The frequency data used to build the Huffman tree is available in this file.  
👉 [View the CSV file](https://github.com/MarvinBrth/tt10-huffman-coder/blob/main/ascii_frequencies.csv)  
Total analyzed characters (including spaces): **700,104,889** characters.  
___

## **🌳 Huffman Tree**
[![Huffman Tree](https://img.shields.io/badge/Huffman_Tree-Click_to_view-blue)](https://github.com/MarvinBrth/tt10-huffman-coder/blob/main/Huffman_Tree.png)

---

## **📊 Huffman Encoding Table**
<details>
  <summary> Click to expand Huffman encoding table</summary>

| Symbol | Probability (%) | Huffman Code |
|--------|---------------|-------------|
| space  | 17.36        | 111         |
| e      | 10.32        | 001         |
| t      | 7.20         | 1100        |
| a      | 7.16         | 1011        |
| i      | 6.32         | 1001        |
| o      | 6.31         | 1000        |
| n      | 6.15         | 0111        |
| r      | 5.45         | 0101        |
| s      | 5.44         | 0100        |
| h      | 4.05         | 0000        |
| l      | 3.47         | 11010       |
| d      | 3.14         | 10100       |
| c      | 2.59         | 01100       |
| u      | 2.26         | 00010       |
| m      | 2.10         | 110111      |
| f      | 1.85         | 110110      |
| p      | 1.66         | 101010      |
| g      | 1.56         | 011011      |
| y      | 1.36         | 011010      |
| w      | 1.31         | 000111      |
| b      | 1.13         | 000110      |
| v      | 0.87         | 1010110     |
| k      | 0.53         | 10101111    |
| x      | 0.16         | 1010111011  |
| z      | 0.09         | 1010111010  |
| j      | 0.09         | 1010111001  |
| q      | 0.07         | 1010111000  |

</details>

---
## **🧮 Calculation of the efficiency**

<details>
  <summary>Click to expand The calculation of the efficiency of the Huffman code</summary>

### **Comparison: Fixed-Length vs. Huffman Encoding**
A source with **<span style="font-family: 'Times New Roman', serif;">N</span>** equally likely symbols requires at least:

<span>$$ L_{\text{max}} = \log_2 N $$</span>

💡 **Example:**
- A source with **27 symbols**, all equally likely, would require:

<span>$$ L_{\text{max}} = \log_2 27 = 4.75 \text{ bits} $$</span>

👉 **This means that each symbol must use at least 4.75 bits, even if some appear far more frequently than others.**  

With **Huffman encoding**, the **average bit length per symbol** is lower if the source entropy is smaller than fixed-length encoding.

---

## **Huffman Encoding Efficiency** 📊

The efficiency of Huffman encoding is measured by comparing its **average code length** to the **theoretical lower bound**, given by entropy.

### **1️⃣ Theoretical Minimum: Entropy \( H(X) \)**
The **entropy of a source** represents the **absolute minimum number of bits needed per symbol** in an ideal lossless encoding:

<span>$$ H(X) = - \sum p(x) \log_2 p(x) $$</span>

For this source:

<span>$$ H(X) = 4.0975 \text{ bits} $$</span>

👉 **No lossless encoding can use fewer than 4.0975 bits per symbol.** 

---

### **2️⃣ Average Bit Length in Huffman Encoding**
The **average code length** \( L \) is calculated by weighting each symbol’s code length by its probability:

<span>$$ L_{\text{Huffman}} = \sum p(x) \cdot l(x) $$</span> 

By applying this formula, **this Huffman code** achieves an **average code length of**:

<span>$$ L_{\text{Huffman}} = 4.1291 \text{ bits} $$</span>

✅ **This is significantly lower than the 4.75 bits required by a fixed-length encoding!**  

---

### **3️⃣ Savings Compared to Fixed-Length Encoding**
To measure storage savings:

<span>$$ \text{Savings} = 1 - \frac{H(X)}{L_{\text{max}}} $$</span>

Substituting values:

<span>$$ \text{Savings} = 1 - \frac{4.0975}{4.75} = 13.72\% $$</span>

✅ **This Huffman code reduces storage by 13.72% compared to fixed-length encoding!** 🎯  

---

### **4️⃣ Encoding Efficiency**
To measure how close Huffman encoding is to the theoretical minimum, we calculate efficiency:

<span>$$ \eta = \frac{H(X)}{L} $$</span>

Substituting values:

<span>$$ \eta = \frac{4.0975}{4.1291} = 0.9924 $$</span>

🔹 **Interpretation of efficiency <span style="font-family: 'Times New Roman', serif;">η</span>:**
- **If <span style="font-family: 'Times New Roman', serif;">η</span> ≈ 1** → **Highly efficient encoding ✅**  
- **If <span style="font-family: 'Times New Roman', serif;">η</span> > 1** → **Impossible ❌** (No encoding can be better than entropy)  

👉 **This Huffman code achieves <span style="font-family: 'Times New Roman', serif;">η</span> = 0.9924, meaning it is very close to optimal efficiency!** 🎯  

</details>


___ 

## 📌 Pin Configuration
### **Input:**
- `ui_in[7]` → Load signal  
- `ui_in[6:0]` → ASCII character input  

### **Output:**
- `uo_out[7:0]` → Huffman-encoded value (first 8 bits)  
- `uio_out[1:0]` → Remaining 2 bits (if code > 8 bits)  
- `uio_out[3:0]` → Huffman code length  
- `uio_out[2]` → Valid output signal  

___

## 🔧 Functionality
1️⃣ **Apply ASCII Input**  
   - The character is provided on `ui_in[6:0]`.  

2️⃣ **Confirm Data Entry with a Positive Edge on Load**  
   - A rising edge on `load` signals the ASIC to process the input.  

3️⃣ **Processing & Output**  
   - After ~5 clock cycles, the ASIC outputs the Huffman-encoded value.  

4️⃣ **Set valid_out = 1**  
   - One clock cycle later, `valid_out = 1` indicates data is ready.  

5️⃣ **Hold Output Until Acknowledged**  
   - The encoded data remains stable until a new `load` pulse signals new input.  

___

## **2D-Preview**
![GDS](https://github.com/MarvinBrth/tt10-huffman-coder/blob/main/2D_Preview.png)

___

## **3D-Preview**
[Click here to view](https://gds-viewer.tinytapeout.com/?model=https://marvinbrth.github.io/tt10-huffman-coder/tinytapeout.gds.gltf)
