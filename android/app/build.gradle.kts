plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Do not add the google-services plugin here if you plan to apply it later; many choose to apply manually.
    // If you prefer to declare it here and it works for your setup, you can uncomment the next line:
    // id("com.google.gms.google-services")
}

android {
    namespace = "com.example.time4play"
    compileSdk = flutter.compileSdkVersion
    ndkVersion =  "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Unique Application ID; ensure it matches your Firebase registration.
        applicationId = "com.example.time4play"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion 
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Set up your signing configuration if needed.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Apply the Google Services plugin using the legacy approach:
apply(plugin = "com.google.gms.google-services")
