package net.getperf.ptune

import android.Manifest
import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var permissionResult: MethodChannel.Result? = null
    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        MethodChannel(engine.dartExecutor.binaryMessenger, "ptune/notification_permissions")
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "status" -> result.success(mapOf(
                            "allowed" to getSystemService(NotificationManager::class.java).areNotificationsEnabled(),
                            "exactRequired" to (Build.VERSION.SDK_INT >= 31),
                            "exactAllowed" to (Build.VERSION.SDK_INT < 31 || getSystemService(AlarmManager::class.java).canScheduleExactAlarms())
                        ))
                        "request" -> {
                            if (Build.VERSION.SDK_INT >= 33 && checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                                if (permissionResult != null) result.error("busy", "Permission request in progress", null)
                                else {
                                    permissionResult = result
                                    requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 42)
                                }
                            } else {
                                startActivity(Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, packageName))
                                result.success(null)
                            }
                        }
                        "settings" -> {
                            startActivity(Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, packageName))
                            result.success(null)
                        }
                        "exactSettings" -> {
                            if (Build.VERSION.SDK_INT >= 31) startActivity(Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM, Uri.parse("package:$packageName")))
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) { result.error("permission_error", e.message, null) }
            }
    }
    override fun onRequestPermissionsResult(code: Int, permissions: Array<out String>, results: IntArray) {
        super.onRequestPermissionsResult(code, permissions, results)
        if (code == 42) {
            permissionResult?.success(null)
            permissionResult = null
        }
    }
}
