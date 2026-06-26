# Order Rush — Claude Code Build Prompt

## บทบาทของคุณ
คุณคือ Game Developer ที่กำลังสร้าง Prototype เกม **Order Rush** ตาม Game Design Document ด้านล่าง
งานของคุณคือสร้างเกมที่เล่นได้จริงในเบราว์เซอร์ (Mobile Portrait Mode) โดยใช้ **Phaser 3**

---

## Game Design Document

### แนวเกม
Time-Management & Action-Puzzle (คล้าย Overcooked)
ผู้เล่น = พนักงานคลังสินค้า รับออเดอร์ → หยิบของ → แพ็ก → ส่ง

### สินค้า 5 ชนิด
| รหัส | ชื่อ | สี | รูปทรง |
|------|------|-----|--------|
| A | เสื้อยืด (Shirt) | #FF4444 (แดง) | สี่เหลี่ยมผืนผ้า |
| B | หมวกแก๊ป (Cap) | #4444FF (น้ำเงิน) | ครึ่งวงกลม |
| C | แก้วน้ำ (Mug) | #FFCC00 (เหลือง) | กระบอกเล็ก |
| D | หนังสือ (Book) | #44BB44 (เขียว) | สี่เหลี่ยมจัตุรัส |
| E | ตุ๊กตาหมี (Bear) | #CCAA88 (น้ำตาล) | วงกลม (ใหญ่สุด) |

### ออเดอร์ 10 แบบ (ไล่ระดับความยาก)
```
Easy (1-3):   [A×1], [C×1], [D×1]
Medium (4-6): [A×1,B×1], [E×1,C×1], [D×3]
Hard (7-10):  [B×2,C×2], [A×1,B×1,D×1], [E×2], [A×1,B×1,C×1,D×1,E×1]
```

### โครงสร้าง 3 นาที
- นาที 1 (Warm-up): ออเดอร์ Easy, max 2 คิวพร้อมกัน
- นาที 2 (Mid-Rush): ออเดอร์ Easy+Medium, max 3 คิวพร้อมกัน
- นาที 3 (Final Rush): ออเดอร์ทุกแบบ, หลอดเวลาไวขึ้น

### ระบบคะแนน
- ส่งถูก: +100
- Speed Bonus: +50 (หลอดเขียว), +20 (หลอดเหลือง), +0 (หลอดแดง)
- ผิด/หมดเวลา: -50
- เกณฑ์ดาว: 800=⭐, 1400=⭐⭐, 1800+=⭐⭐⭐

### UI Layout (Portrait 390×844px)
```
┌─────────────────────┐  ← Zone 1: Pressure (top 30%)
│  ⏱ 02:47    💎 350  │
│  [Order 1][Order 2] │  ← บิลออเดอร์ + Patience Bar
├─────────────────────┤  ← Zone 2: Action (middle 40%)
│                     │
│      📦 [BOX]       │  ← กล่องแพ็กของ + ของที่ใส่แล้ว
│                     │
│   [ปิด & ส่ง! 🚀]   │  ← ปุ่มส่ง (เรืองแสงเมื่อของครบ)
├─────────────────────┤  ← Zone 3: Inventory (bottom 30%)
│  [👕][🧢][☕]       │
│     [📗][🐻]        │  ← ปุ่มสินค้า Tap to Pack
└─────────────────────┘
```

### ระบบ Tap to Pack
- ผู้เล่นแตะสินค้าในโซนล่าง → สินค้า pop-up เด้งเข้ากล่อง
- เมื่อของในกล่องตรงกับออเดอร์ที่เลือก → ปุ่มส่งเรืองแสง
- กดปุ่มส่ง → animation กล่องเลื่อนออก + เปิดกล่องใหม่

### Audio/Visual Feedback
- หยิบของ: เสียง "ติ๊ด" + ตัวเลขลอยขึ้น
- ปิดกล่อง: เสียง "แคร่ก" + shake animation
- ส่งสำเร็จ: เสียงเหรียญ + sparkle effect
- หมดเวลาออเดอร์: เสียง buzzer + shake + -50 ลอยแดง

---

## Tech Stack ที่ต้องใช้
- **Phaser 3** (load จาก CDN: https://cdn.jsdelivr.net/npm/phaser@3.60.0/dist/phaser.min.js)
- ไฟล์เดียว: `index.html` (inline CSS + JS ทั้งหมด)
- ไม่ต้องใช้ backend, ไม่ต้องใช้ npm install
- วาด Graphics ด้วย Phaser Graphics API (ไม่ต้องใช้ไฟล์รูปภาพ)

---

## สิ่งที่ต้องสร้าง (Task List)

### Phase 1 — Core Game Loop
- [ ] ตั้ง Phaser Scene: GameScene, UIScene (overlay)
- [ ] วาดสินค้า A-E ด้วย Graphics (สีและรูปทรงตามสเปค)
- [ ] ระบบออเดอร์: สุ่มออเดอร์ตามเฟส + แสดงบนหน้าจอ
- [ ] Patience Bar: ลดลงตามเวลา เปลี่ยนสี green→yellow→red
- [ ] Tap to Pack: กดสินค้า → เพิ่มเข้า currentBox[]
- [ ] ปุ่มส่ง: เช็คว่า currentBox ตรงกับออเดอร์ที่เลือก
- [ ] ระบบคะแนน + Speed Bonus

### Phase 2 — Polish & Feedback
- [ ] Timer 3 นาที + ปรับความยากตามเฟส
- [ ] Visual feedback (pop, shake, sparkle)
- [ ] Sound effects ด้วย Phaser Sound (Web Audio API)
- [ ] หน้าจอ Game Over + ดาว + คะแนนสรุป
- [ ] ปุ่ม Play Again

### Phase 3 — UX ขั้นสุดท้าย
- [ ] Responsive ให้พอดีกับ mobile portrait
- [ ] กล่องใหม่ slide in animation
- [ ] ไฮไลต์ออเดอร์ที่กำลังแพ็ก

---

## ข้อห้าม / Constraints
1. ต้องเล่นได้ใน browser เดียว ไม่มี server
2. อย่าใช้ไฟล์รูปภาพ ให้วาด shape ทั้งหมด
3. อย่า install package ใดๆ ใช้ CDN เท่านั้น
4. โค้ดทั้งหมดต้องอยู่ใน `index.html` ไฟล์เดียว
5. ต้อง comment ภาษาไทย/อังกฤษอธิบาย logic หลักทุก function

---

## เริ่มต้น
สร้างไฟล์ `index.html` และเริ่ม Phase 1 ก่อน
เมื่อ Phase 1 ครบ บอกฉันก่อนแล้วค่อยไป Phase 2
