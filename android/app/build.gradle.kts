plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")   // plugin de Flutter
    id("com.google.gms.google-services")     // plugin de Firebase
}

android {

    // 👉 ESTE es tu package / namespace (DEBE ser igual al de Firebase)
    namespace = "com.example.venta_de_artesanias"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.venta_de_artesanias"   // MISMO que Firebase
        minSdk = flutter.minSdkVersion
        targetSdk = 34

        // Opcional:
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Por ahora firma con el debug
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}

flutter {
    source = "../.."
}
