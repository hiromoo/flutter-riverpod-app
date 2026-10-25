import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("local") {
            dimension = "flavor-type"
            applicationId = "com.example.skill_eval_app.local"
            resValue(type = "string", name = "app_name", value = "Skill Eval Local")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.example.skill_eval_app.staging"
            resValue(type = "string", name = "app_name", value = "Skill Eval Staging")
        }
        create("production") {
            dimension = "flavor-type"
            applicationId = "com.example.skill_eval_app"
            resValue(type = "string", name = "app_name", value = "Skill Eval App")
        }
    }

    buildFeatures.resValues = true
}