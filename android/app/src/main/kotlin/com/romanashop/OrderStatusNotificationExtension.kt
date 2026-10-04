package com.romanashop

import android.graphics.Color
import android.util.Log
import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.IDisplayableMutableNotification
import com.onesignal.notifications.INotificationServiceExtension

/**
 * OneSignal notification extension that styles order-status notifications
 * and pins them on top (ongoing) so they remain visible even when the app
 * is closed, matching the order-status UI in "آخر طلباتي".
 *
 * Backend additionalData contract:
 *   type      : "order_status"
 *   orderId   : <id>
 *   status    : "pending" | "approved" | "done" | "cancel"
 *   statusText: optional Arabic label
 *
 * Tip: send the same notification with `collapse_id = orderId` from the
 * backend so each new status update REPLACES the previous one for the
 * same order (single sticky notification per order).
 */
class OrderStatusNotificationExtension : INotificationServiceExtension {

    companion object { private const val TAG = "OrderStatusExt" }

    override fun onNotificationReceived(event: INotificationReceivedEvent) {
        val notification: IDisplayableMutableNotification = event.notification
        val data = notification.additionalData
        Log.d(TAG, "onNotificationReceived id=${notification.notificationId} additionalData=$data")
        if (data == null) return

        val type = data.optString("type", "")
        if (type != "order_status" && type != "order") {
            Log.d(TAG, "skip: type='$type' is not order_status")
            return
        }

        val status = data.optString("status", "").lowercase()
        val statusText = data.optString("statusText", "")
        val orderId = data.optString("orderId", "")
        val accent = colorFor(status)
        val step = stepFor(status) // 0..4, or -1 for canceled/rejected
        val isCanceled = status == "cancel" || status == "canceled" || status == "rejected"
        val isTerminal = step == 4 || isCanceled

        Log.d(TAG, "applying status='$status' statusText='$statusText' orderId='$orderId' step=$step terminal=$isTerminal color=${Integer.toHexString(accent)}")

        notification.setExtender { builder ->
            builder.setColor(accent)
            builder.setColorized(true)
            // Make the status badge part of the title so it's clearly visible.
            // Example title: "● مقبول • طلبك #2188"
            val originalTitle = notification.title ?: ""
            val badge = buildString {
                append("● ")
                if (statusText.isNotBlank()) append(statusText) else append(status)
                if (originalTitle.isNotBlank()) {
                    append(" • ").append(originalTitle)
                }
                if (orderId.isNotBlank()) append(" #").append(orderId)
            }
            builder.setContentTitle(badge)
            // Also surface the Arabic status label as the sub-text (small header line).
            val sub = buildString {
                if (statusText.isNotBlank()) append(statusText)
                if (orderId.isNotBlank()) {
                    if (isNotEmpty()) append(" • ")
                    append("#").append(orderId)
                }
            }
            if (sub.isNotEmpty()) builder.setSubText(sub)

            // Real Android progress bar (0..4) — same step model as LastOrderView.
            // For canceled/rejected we hide the progress bar.
            if (!isCanceled && step >= 0) {
                builder.setProgress(4, step.coerceAtMost(4), false)
            }

            // Build a compact "stepper" line using Unicode dots/dashes that
            // mirrors the LastOrderView stepper:
            //   في الانتظار → تمت الموافقة → تعيين السائق → في الطريق → تم التسليم
            // Active/done steps use ⬤, future steps use ○. Example (step=2):
            //   ⬤━━⬤━━⬤━━○━━○
            val stepperBar = if (isCanceled) "✖  ملغي" else buildStepperBar(step)
            val stepperLabels = stepperLabelsLine(step, isCanceled)

            // Big text style: show body + stepper bar + labels.
            val body = notification.body ?: ""
            val bigText = buildString {
                if (body.isNotBlank()) append(body).append('\n').append('\n')
                append(stepperBar).append('\n').append(stepperLabels)
            }
            builder.setStyle(
                androidx.core.app.NotificationCompat.BigTextStyle()
                    .setBigContentTitle(badge)
                    .setSummaryText(if (isCanceled) "ملغي" else _stepLabels[step.coerceIn(0, 4)])
                    .bigText(bigText)
            )

            // Keep the notification pinned at the top of the tray while
            // the order is still in progress.
            builder.setOngoing(!isTerminal)
            builder.setAutoCancel(isTerminal)
            // Higher priority -> heads-up + stays at top.
            builder.priority = androidx.core.app.NotificationCompat.PRIORITY_MAX
            builder.setCategory(androidx.core.app.NotificationCompat.CATEGORY_STATUS)
            builder.setOnlyAlertOnce(true) // don't re-buzz on every status update
            builder
        }
    }

    // ─── Stepper model (mirrors LastOrderView) ───────────────────────────────
    private val _stepLabels = listOf(
        "في الانتظار",   // 0
        "تمت الموافقة",  // 1
        "تعيين السائق",  // 2
        "في الطريق",     // 3
        "تم التسليم"     // 4
    )

    /** Maps a backend status string to a 0..4 step, or -1 if it doesn't apply. */
    private fun stepFor(status: String): Int = when (status) {
        "pending", "wait", "waiting", "new"                 -> 0
        "approved", "approve", "accepted", "confirmed"      -> 1
        "assigned", "driver_assigned", "preparing", "ready" -> 2
        "on_way", "onway", "shipping", "shipped",
        "in_road", "delivering", "out_for_delivery"         -> 3
        "done", "completed", "delivered", "finished"        -> 4
        else                                                -> -1
    }

    /** Builds a horizontal dot/line bar like ⬤━━⬤━━○━━○━━○ for the given step. */
    private fun buildStepperBar(step: Int): String {
        val s = step.coerceIn(0, 4)
        val dots = (0..4).map { if (it <= s) "⬤" else "○" }
        return dots.joinToString("━━")
    }

    /** Single-line short labels under each dot. Marks the active step with [ ]. */
    private fun stepperLabelsLine(step: Int, isCanceled: Boolean): String {
        if (isCanceled) return "تم إلغاء الطلب"
        val s = step.coerceIn(0, 4)
        val short = listOf("انتظار", "موافقة", "سائق", "بالطريق", "تسليم")
        return short.mapIndexed { i, lbl ->
            when {
                i == s        -> "[$lbl]"
                i < s         -> "✓$lbl"
                else          -> lbl
            }
        }.joinToString(" › ")
    }

    private fun colorFor(status: String): Int = when (status) {
        "done", "completed"            -> Color.parseColor("#2E7D32") // green
        "approved", "approve",
        "accepted"                     -> Color.parseColor("#1B5E20") // dark green
        "cancel", "canceled",
        "rejected"                     -> Color.parseColor("#D32F2F") // red
        "pending", "wait", "waiting"   -> Color.parseColor("#EF6C00") // orange
        else                           -> Color.parseColor("#DB2820") // brand
    }
}
