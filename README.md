# Steel Tongue Drum Acoustic Analysis

This repository contains all materials related to the **Acoustic Analysis and Auralisation of a Steel Tongue Drum in a Tunnel**. The study explores impulse response (IR) measurement, room acoustics, and auralisation techniques using MATLAB.
[Acoustic Analysis and Auralisation of a Steel Tongue Drum in a Tunnel.pdf](https://github.com/user-attachments/files/18618455/Acoustic.Analysis.and.Auralisation.of.a.Steel.Tongue.Drum.in.a.Tunnel.pdf)
<img width="735" alt="Screenshot 2025-01-31 at 09 50 34" src="https://github.com/user-attachments/assets/d0148220-45f5-4e65-84cb-8ca39f9980d8" />


## **Audio Files**
The **Audio/** folder contains:
- The **anechoic recording** of the steel tongue drum.
- The **recorded impulse response (IR)** of the tunnel.
- The **convolved audio file**, demonstrating auralisation.

## **MATLAB Code**
MATLAB scripts were used to **process the IR**, extract acoustic parameters, and apply reverberation to dry recordings. 

### **Key MATLAB Functions**
- **Impulse Response Processing**
  - `analyseIR.m` → extracts acoustic parameters from IR recordings.
  - `APTScriptMod.m` → computes RT60, clarity, and definition metrics.
  - `freqspec.m` → generates frequency spectra.
  - `spectrogramComplete.m` → produces spectrogram visualizations.

- **Reverberation and Auralisation**
  - `applyReverb.m` → convolves dry recordings with measured IRs.
  - `plotRT60.m` → plots RT60 trends across frequency bands.

- **Room Acoustic Modeling**
  - `computeRoomModes.m` → calculates theoretical room mode frequencies.
  - `exportRoomModesToLatex.m` → exports mode calculations as a LaTeX table.

## **Final Report**
The final report **Acoustic_Analysis_and_Auralisation.pdf** contains:
- A detailed analysis of impulse responses.
- Frequency-domain and time-domain evaluation.
- Room acoustic modeling and auralisation results.

---

## **Citation**
If using this repository for research or reference, please cite:  
**Franchino, F.** *Acoustic Analysis and Auralisation of a Steel Tongue Drum in a Tunnel* (2025).  

---

## **Contact**
For any questions, reach out to **Facundo Franchino**.

---

