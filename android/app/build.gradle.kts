import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseKeystoreBase64 = System.getenv("ANDROID_KEYSTORE_BASE64")
val releaseKeystorePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
val releaseKeyAlias = System.getenv("ANDROID_KEY_ALIAS")
val releaseKeyPassword = System.getenv("ANDROID_KEY_PASSWORD")
val releaseKeystoreFile = layout.buildDirectory.file("release-keystore.jks")
val releaseSigningConfigured =
    !releaseKeystoreBase64.isNullOrBlank() &&
        !releaseKeystorePassword.isNullOrBlank() &&
        !releaseKeyAlias.isNullOrBlank() &&
        !releaseKeyPassword.isNullOrBlank()

if (releaseSigningConfigured) {
    val keystoreFile = releaseKeystoreFile.get().asFile
    keystoreFile.parentFile.mkdirs()
    keystoreFile.writeBytes(Base64.getDecoder().decode(releaseKeystoreBase64))
}

gradle.taskGraph.whenReady {
    val releaseTaskRequested = allTasks.any { task ->
        task.path.contains("Release", ignoreCase = false)
    }

    if (releaseTaskRequested && !releaseSigningConfigured) {
        throw GradleException(
            "Android release signing secrets are required for release builds."
        )
    }
}

android {
    namespace = "ru.nkstr.learnkana"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "ru.nkstr.learnkana"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (releaseSigningConfigured) {
                storeFile = releaseKeystoreFile.get().asFile
                storePassword = releaseKeystorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
