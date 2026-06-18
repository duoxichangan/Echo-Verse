# flutter_local_notifications — 保护 Gson 反序列化所需的泛型/类型信息不被 R8 删除
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.google.gson.** { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver
-keep class * extends com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver
-keepattributes Signature, InnerClasses, EnclosingMethod

# Gson 通用保护（防止反射/泛型被 strip）
-keepattributes *Annotation*
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
