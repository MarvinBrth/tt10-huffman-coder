# Huffman Coder

## 🔠 What is the Huffman_Coder?
The Huffman_Coder ASIC is a hardware implementation of Huffman encoding, a lossless data compression method commonly used in data transmission and storage. This design uses a static Huffman tree generated from statistical letter frequency data in the English language.
___

## 📅 Invention
Huffman coding was invented in 1952 by David A. Huffman at MIT as an optimal lossless compression algorithm.
___

## 🔍 Modern Uses
✅ 📁 File Compression → Used in ZIP, GZIP, 7z and PNG for efficient storage.  
✅ 🎵 Audio & Video → Found in MP3, FLAC, JPEG, H.264 for high-quality compression.  
✅ 📡 Data Transmission → Used in fax machines, telephony, and networking protocols.  
✅ 📚 Text Compression → Helps optimize PDF, PostScript, and text file formats.  
___

## 📊 Huffman Frequency Data  
The frequency data used for building the Huffman tree is available in this repository.  
👉 [View the CSV file](https://github.com/MarvinBrth/tt10-huffman-coder/blob/main/ascii_frequencies.csv)
Total analyzed characters (including spaces): 700,104,889 characters.
 ___

## 📌 Pin Configuration
### Input:
ui_in[7] Load signal  
ui_in[6:0]	Input	ASCII value of the character to encode  

### Output:
uo_out[7:0]	Output huffman_out[7:0]  
uio_out[1:0] Output	huffman_out[9:8]  
uio_out[3:0]	Output	Huffman code length (number of bits)  
uio_out[2] = valid_out  
___

## 🔧 Functionality
1️⃣ Apply ASCII Input:
- The ASCII character is provided on ui_in[6:0].

2️⃣ Confirm Data Entry with a Positive Edge on load:
- A rising edge on load signals the ASIC to read the input data.

3️⃣ Processing & Output:
- After approximately 5 clock cycles, the ASIC outputs the Huffman-encoded value as follows:
    - uo_out[7:0] → First 8 bits of the encoded value.
    - uio_out[1:0] → Remaining 2 bits (if the code exceeds 8 bits).

4️⃣ Set valid_out = 1:
- 1 clock cycle after output generation, the ASIC sets valid_out = 1, indicating that the data is ready.

5️⃣ Hold Output Until Acknowledged:
- The encoded data and valid_out remain stable until a new load pulse signals that the data has been read and a new ASCII character is available for processing.
___
## 2D-Preview
![GDS](https://github.com/MarvinBrth/tt10-huffman-coder/blob/main/2D_Preview.png)
___
## 3D-Preview
[Click here to view](https://gds-viewer.tinytapeout.com/?model=https://marvinbrth.github.io/tt10-huffman-coder/tinytapeout.gds.gltf)
