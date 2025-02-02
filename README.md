# 📱 Apple TV+ Style Scrolling Effect in SwiftUI

Recreation of the **Apple TV+ horizontal scrolling effect** in SwiftUI. This subtle horizontal shift adds depth and dynamics to the interface, making it visually more engaging.

## 🚀 Features

- ✅ Smooth horizontal scrolling effect  
- ✅ Dynamic image shifting based on scroll offset  
- ✅ Clean and lightweight SwiftUI implementation  
- ✅ Inspired by Apple TV+ app design  

## 🧩 How It Works

The key is using **`GeometryReader`** to track the view’s position along the X-axis and applying a negative offset:

```swift
.offset(x: -minX * 0.6) // Creates a 3D-like scrolling effect
```

With this simple line, you achieve a slight image shift in the opposite direction of the scroll, adding a 3D-like depth to your UI. 🔥

📸 Preview

![apple_tv_scroll_animation_gif](https://github.com/user-attachments/assets/9a5e6ee7-455c-4ee6-8704-67e6d362d098)
