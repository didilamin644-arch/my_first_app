#!/bin/bash
echo "🔍 جاري فحص وإصلاح ملفات المشروع..."

# 1. إصلاح ملف pubspec.yaml
cat <<EOP > pubspec.yaml
name: my_first_app
description: "Gemini AI Vision"
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  image_picker: ^1.0.4
  cupertino_icons: ^1.0.2
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
flutter:
  uses-material-design: true
EOP

# 2. إصلاح ملف AndroidManifest.xml
cat <<EOM > android/app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.my_first_app">
    <application
        android:label="my_first_app"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
EOM

echo "✅ تم إعادة ضبط التنسيق وحل مشاكل المسافات."
flutter clean
flutter pub get
echo "🚀 المشروع الآن جاهز للرفع أو البناء!"
