import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("environment")

    productFlavors {
        create("local") {
            dimension = "environment"
            applicationId = "com.example.readingshelf.local"
            resValue(type = "string", name = "app_name", value = "Reading Shelf Local")
        }
        create("staging") {
            dimension = "environment"
            applicationId = "com.example.readingshelf.staging"
            resValue(type = "string", name = "app_name", value = "Reading Shelf Staging")
        }
        create("production") {
            dimension = "environment"
            applicationId = "com.example.readingshelf"
            resValue(type = "string", name = "app_name", value = "Reading Shelf")
        }
    }

    buildFeatures.resValues = true
}