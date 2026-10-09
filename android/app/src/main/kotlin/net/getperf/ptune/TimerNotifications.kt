package net.getperf.ptune

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

object TimerNotifications {
    private const val channelId = "timer_events_v1"
    private const val alarmId = 4201
    fun manager(context: Context) = context.getSystemService(NotificationManager::class.java)
    private fun prefs(context: Context) = context.getSharedPreferences("timer_notifications", Context.MODE_PRIVATE)
    fun createChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= 26) {
            val channel = NotificationChannel(channelId, "作業開始・終了", NotificationManager.IMPORTANCE_HIGH)
            channel.enableVibration(true)
            manager(context).createNotificationChannel(channel)
        }
    }
    fun enabled(context: Context): Boolean {
        createChannel(context)
        return manager(context).areNotificationsEnabled() &&
            (Build.VERSION.SDK_INT < 26 || manager(context).getNotificationChannel(channelId)?.importance != NotificationManager.IMPORTANCE_NONE)
    }
    private fun pending(context: Context, id: String = "", title: String = "", body: String = "") =
        PendingIntent.getBroadcast(context, alarmId,
            Intent(context, TimerAlarmReceiver::class.java).putExtra("sessionId", id).putExtra("title", title).putExtra("body", body),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

    fun cancel(context: Context) {
        context.getSystemService(AlarmManager::class.java).cancel(pending(context))
        prefs(context).edit().remove("active").apply()
    }
    fun schedule(context: Context, id: String, at: Long, title: String, body: String) {
        cancel(context)
        if (!enabled(context)) return
        val alarms = context.getSystemService(AlarmManager::class.java)
        if (Build.VERSION.SDK_INT >= 31 && !alarms.canScheduleExactAlarms()) {
            throw SecurityException("終了予約にはアラームとリマインダーの許可が必要です")
        }
        if (prefs(context).getString("delivered", null) == id) return
        prefs(context).edit().putString("active", id).apply()
        try {
            alarms.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, pending(context, id, title, body))
        } catch (e: Exception) {
            prefs(context).edit().remove("active").apply()
            throw e
        }
    }
    fun complete(context: Context, id: String, title: String, body: String) {
        cancel(context)
        deliverEnd(context, id, title, body)
    }
    fun receive(context: Context, id: String, title: String, body: String) {
        if (prefs(context).getString("active", null) != id) return
        prefs(context).edit().remove("active").apply()
        deliverEnd(context, id, title, body)
    }
    private fun deliverEnd(context: Context, id: String, title: String, body: String) {
        if (!enabled(context) || prefs(context).getString("delivered", null) == id) return
        prefs(context).edit().putString("delivered", id).apply()
        show(context, title, body, alarmId)
    }
    fun show(context: Context, title: String, body: String, id: Int = 4202) {
        if (!enabled(context)) return
        val open = PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(context, channelId) else Notification.Builder(context)
        manager(context).notify(id, builder.setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title).setContentText(body).setStyle(Notification.BigTextStyle().bigText(body))
            .setContentIntent(open).setAutoCancel(true).setCategory(Notification.CATEGORY_REMINDER)
            .setVisibility(Notification.VISIBILITY_PRIVATE).setDefaults(Notification.DEFAULT_ALL).build())
    }
}

class TimerAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        TimerNotifications.receive(context, intent.getStringExtra("sessionId") ?: return,
            intent.getStringExtra("title") ?: "🔴 作業終了", intent.getStringExtra("body") ?: "")
    }
}
