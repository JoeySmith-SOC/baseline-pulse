plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

fun readLocalProperty(key: String): String? {
    val properties = java.util.Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (!localPropertiesFile.exists()) {
        return null
    }
    localPropertiesFile.inputStream().use { properties.load(it) }
    return properties.getProperty(key)
}

android {
    namespace = "com.baselinepulse.baseline_pulse"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.baselinepulse.baseline_pulse"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        val mapsKeyFromGradle = providers.gradleProperty("MAPS_API_KEY").orNull
        val mapsKeyFromEnv = providers.environmentVariable("MAPS_API_KEY").orNull
        val mapsKeyFromLocal = readLocalProperty("MAPS_API_KEY")
        manifestPlaceholders["MAPS_API_KEY"] =
            mapsKeyFromGradle ?: mapsKeyFromEnv ?: mapsKeyFromLocal ?: "REPLACE_WITH_MAPS_API_KEY"
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
