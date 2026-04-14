# Bean Photo với Background Removal - Design Spec

**Date**: 2026-04-14
**Status**: Approved
**Author**: Claude Code

---

## 1. Overview

Thêm chức năng chụp/chọn ảnh sản phẩm cà phê trên màn hình **Add Bean**, với background removal tự động sử dụng **ML Kit Selfie Segmentation**.

---

## 2. UI/UX Design

### 2.1 Layout

**Vị trí**: Hero image đặt ở **đầu form**, full-width, cao ~200dp

**Container styling**:
- Border radius: 12dp
- Box shadow: `BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))`
- ClipBehavior: Clip.antiAlias

### 2.2 Visual States

**Empty State (placeholder)**:
- Background: `AppColors.surfaceContainerLow`
- Icon: `Icons.add_a_photo_outlined` (size 48, color: `AppColors.onSurfaceVariant`)
- Text: "Tap to add photo" (style: `GoogleFonts.manrope(color: AppColors.onSurfaceVariant)`)

**Loading State**:
- Shimmer effect over placeholder
- Circular progress indicator centered

**Filled State (có ảnh)**:
- Ảnh đã xử lý với transparent background
- Background color của container = `AppColors.surfaceContainerLow` (blend với transparent pixels)
- Gradient overlay từ dưới lên: `LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.3)])`

### 2.3 Controls

**Action buttons** (phía trên ảnh, positioned top-right):
```
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    _ActionButton(icon: Icons.camera_alt, onTap: _takePhoto),
    const SizedBox(width: 8),
    _ActionButton(icon: Icons.photo_library, onTap: _pickFromGallery),
    if (_imageUrl != null) ...[
      const SizedBox(width: 8),
      _ActionButton(icon: Icons.delete, onTap: _removeImage),
    ],
  ],
)
```

**_ActionButton styling**:
- Size: 40x40
- Background: `Colors.black.withOpacity(0.5)`
- Icon color: white
- Border radius: 20 (circular)

---

## 3. Technical Specification

### 3.1 Dependencies

```yaml
# pubspec.yaml
dependencies:
  image_picker: ^1.0.7
  google_mlkit_selfie_segmentation: ^0.6.0
  path_provider: ^2.1.2
  permission_handler: ^11.3.0
```

### 3.2 Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to photograph your coffee beans</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select photos of your coffee beans</string>
```

### 3.3 Image Processing Flow

```
1. User taps Camera/Gallery
2. ImagePicker captures/selects image
3. Load image using 'image' package (File → Image)
4. Initialize ML Kit Segmenter: SelfieSegmenter.session()
5. Process image through segmenter → get mask (ImageProxy)
6. Apply mask to original image:
   - Create new image with transparent background
   - For each pixel: if mask indicates background, set alpha=0
7. Encode processed image to PNG
8. Save to app documents: beans/{uuid}.png
9. Update Bean state with imageUrl path
```

### 3.4 Key Implementation Details

**Image resizing**: Max 1024px trước khi xử lý để tránh OOM

**Segmenter configuration**:
```dart
final segmenter = SelfieSegmenter.session(
  mode: SegmenterMode.single,
  enableRawSizeMask: true,
);
```

**Mask application** (pseudocode):
```dart
for (y, x) in image {
  final maskValue = mask[y, x];
  if (maskValue < 0.5) { // Background
    image.setPixel(y, x, Colors.transparent);
  }
}
```

### 3.5 File Storage

- Directory: `getApplicationDocumentsDirectory()/beans/`
- Filename: `{bean_uuid}.png`
- Format: PNG (preserve transparency)

---

## 4. State Management

### 4.1 AddBeanScreen State

```dart
class _AddBeanScreenState {
  // Existing fields...
  String? _imageUrl;           // Local file path
  bool _isProcessingImage;     // Loading state
  Uint8List? _processedImage;   // Cached processed image bytes
}
```

### 4.2 BeansProvider Changes

```dart
// New method
Future<String> saveBeanImage(Uint8List imageBytes, String beanId) async {
  final dir = Directory('${getApplicationDocumentsDirectory()}/beans');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  
  final file = File('${dir.path}/$beanId.png');
  await file.writeAsBytes(imageBytes);
  return file.path;
}
```

---

## 5. Error Handling

| Scenario | Handling |
|----------|----------|
| Camera permission denied | Snackbar: "Camera permission required. Tap to open settings" + openAppSettings() |
| Gallery permission denied (Android 13+) | Snackbar với link to settings |
| ML Kit fails | Fallback: hiển thị ảnh gốc (không remove bg), log error |
| No camera on device | Hide camera button |
| Image file too large | Resize trước khi xử lý |
| Storage full | Show error snackbar, don't save |

---

## 6. Files to Modify

| File | Changes |
|------|---------|
| `lib/presentation/screens/beans/add_bean_screen.dart` | Add hero image widget, image picker methods, ML Kit processing |
| `lib/presentation/providers/beans_provider.dart` | Add saveBeanImage() method |
| `pubspec.yaml` | Add dependencies |
| `android/app/src/main/AndroidManifest.xml` | Add permissions |
| `ios/Runner/Info.plist` | Add permission descriptions |

---

## 7. Testing Checklist

- [ ] Camera button opens camera
- [ ] Gallery button opens image picker
- [ ] Captured image displays correctly
- [ ] Background removal works (transparent background visible)
- [ ] Processed image saves to correct path
- [ ] Delete button removes image and resets state
- [ ] Form save works with imageUrl populated
- [ ] Error cases handled gracefully (permissions, ML failure)
- [ ] Image displays correctly on BeanDetailScreen
