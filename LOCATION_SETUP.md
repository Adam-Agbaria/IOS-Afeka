# Location Permissions Setup

## Required for GPS Functionality

Since iOS requires explicit permission descriptions for location access, you need to add these to your Xcode project:

### Steps to Add Location Permissions in Xcode:

1. **Open your Xcode project**
2. **Select the "Afeka" target** in the project navigator (left panel)
3. **Click on the "Info" tab** in the main editor area
4. **Scroll down to "Custom iOS Target Properties"**
5. **Add these two entries by clicking the "+" button:**

#### Entry 1:
- **Key**: `Privacy - Location When In Use Usage Description`
- **Type**: String
- **Value**: `This app needs location access to determine your side (East/West) for the card game based on your GPS coordinates.`

#### Entry 2:
- **Key**: `Privacy - Location Always and When In Use Usage Description`
- **Type**: String  
- **Value**: `This app needs location access to determine your side (East/West) for the card game based on your GPS coordinates.`

### Alternative Method:
You can also type the raw keys if the friendly names don't appear:
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`

### Result:
After adding these, when you tap "Detect Location", iOS will show a permission dialog with your custom message explaining why the app needs location access.

---

**Note**: Without these permissions, the location detection will fail silently or show permission denied errors. 