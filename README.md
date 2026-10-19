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
  <summary>Click to expand the calculation of the efficiency of the Huffman code</summary>

### **Comparison: Fixed-Length vs. Huffman Encoding**
The alphabet contains **27 symbols**: lowercase `a–z` and space. A fixed-width binary code needs a whole number of bits per symbol:

$$ L_{\text{fixed}} = \lceil \log_2 27 \rceil = 5 \text{ bits/symbol} $$

💡 **8-bit ASCII uses 8 bits/symbol.** The value $\log_2 27 \approx 4.7549$ is the entropy of 27 equally likely symbols, not the width of a fixed-length binary code.

The calculations below use the counts in [ascii_frequencies.csv](ascii_frequencies.csv), restricted to these 27 symbols and normalized to **700,104,889 characters**.

---

### **1️⃣ Theoretical Minimum: Entropy**
The entropy of the single-symbol probability distribution is:

$$ H(X) = -\sum p(x)\log_2 p(x) = 4.0973 \text{ bits/symbol} $$

This is the lower bound for the average length of a binary prefix code for this distribution. Compression that also exploits relationships between characters can achieve a different rate.

---

### **2️⃣ Average Bit Length in Huffman Encoding**
Weighting each actual code length by its symbol probability gives:

$$ L_{\text{Huffman}} = \sum p(x)\,l(x) = 4.1289 \text{ bits/symbol} $$

✅ **This is the expected payload size per character for the frequency data above.** A particular text can have a different average.

---

### **3️⃣ Storage Savings**
Storage savings use the **actual average code length**, rather than entropy:

$$ \text{Savings} = 1 - \frac{L_{\text{Huffman}}}{L_{\text{reference}}} $$

| Reference format | Bits/symbol | Expected payload savings |
|---|---:|---:|
| 8-bit ASCII | 8 | **48.39%** |
| Fixed-width code for 27 symbols | 5 | **17.42%** |

📊 These predictions exclude file headers and final byte padding. Use the same reference format when comparing them with a practical test.

---

### **4️⃣ Encoding Efficiency**
The ratio of entropy to average code length measures how closely the code approaches the single-symbol entropy bound:

$$ \eta = \frac{H(X)}{L_{\text{Huffman}}} = \frac{4.0973}{4.1289} \approx 0.9923 $$

✅ **99.23% efficiency** for the source distribution above.

</details>

___

## 🧪 Practical Test: Full Bible

<details>
  <summary>Click to expand the practical test results</summary>

**IHP25a · ETR v3.2 · 75 MHz · one character every 3 clocks.**
The complete [King James Bible](https://www.gutenberg.org/ebooks/10) (66 books), normalized to lowercase `a–z` and spaces:

| Measurement | Result |
|---|---:|
| Input (8-bit ASCII) | **4,012,049 bytes** |
| Compressed file, including 8-byte header | **2,050,160 bytes** |
| Storage saved | **1,961,889 bytes (48.90%)** |
| Ideal ASIC payload time, excluding transfer, checks & packing (calculated) | **0.1605 s** |
| Capture & USB transfer, before output verification and packing (measured) | **45.70 s** |
| Encoding, USB transfer, checks & bit packing (measured) | **51.82 s** |
| Total including decoding & byte comparison (measured) | **64.60 s** |

⏱️ Ideal time: **4,012,049 × 3 / 75,000,000 = 0.16048196 s**, or **25 million characters/s** during uninterrupted input. This is calculated ASIC payload time; transfer, pauses between bursts and PC packing take additional time. The measured 45.70 s still includes buffer preparation and transport integrity checks.

✅ The entire text was captured once, then all outputs were checked. The decoded text matches the normalized input **byte for byte**.

📊 The measured **16,401,215 payload bits** (**4.0880 bits/character**) exactly match the codebook prediction for this text. The general prediction above is **48.39%** savings versus the same 8-bit ASCII baseline; the Bible reaches **48.90%** because its symbol frequencies differ. Savings include the header and padding, exclude normalization, and assume the decoder knows the fixed codebook.

</details>

___

## 📌 Pin Configuration
### **Input:**
- `ui_in[7]` → Load signal  
- `ui_in[6:0]` → ASCII character input  

### **Output:**
- `uo_out[7:0]` → Huffman-encoded value (first 8 bits)  
- `uio_out[1:0]` → Remaining 2 bits (if code > 8 bits)  
- `uio_out[6:3]` → Huffman code length
- `uio_out[2]` → Valid output signal  

___

## 🔧 Functionality
1️⃣ **Apply ASCII Input**  
   - The character is provided on `ui_in[6:0]`.  

2️⃣ **Confirm Data Entry with a Positive Edge on Load**  
   - A rising edge on `load` signals the ASIC to process the input.  

3️⃣ **Processing & Output**  
   - Counting the LOAD capture as rising edge 1, the code appears on rising edge **3**.

4️⃣ **Set valid_out = 1**  
   - On rising edge **4**, `valid_out = 1` indicates data is ready. New inputs can arrive every **3 clocks**.

5️⃣ **Hold Output Until Acknowledged**  
   - The encoded data remains stable until a new `load` pulse signals new input.  

___

## **2D-Preview**
![GDS](https://github.com/MarvinBrth/tt10-huffman-coder/blob/main/2D_Preview.png)

___

## **3D-Preview**
[Click here to view](https://gds-viewer.tinytapeout.com/?model=https://marvinbrth.github.io/tt10-huffman-coder/tinytapeout.gds.gltf)
