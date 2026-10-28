package com.example.jobzshala

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "jobzshala/interview",
        )
        eventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "jobzshala/interview_events",
        )

        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                emit("sessionStarted", mapOf("status" to "ready"))
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "join" -> {
                    val meetingCode = call.argument<String>("meetingCode") ?: "JZ-8P4Q"
                    val name = call.argument<String>("name") ?: "Candidate"
                    val micEnabled = call.argument<Boolean>("micEnabled") ?: true
                    val cameraEnabled = call.argument<Boolean>("cameraEnabled") ?: true

                    emit(
                        "sessionStarted",
                        mapOf(
                            "meetingCode" to meetingCode,
                            "name" to name,
                            "micEnabled" to micEnabled,
                            "cameraEnabled" to cameraEnabled,
                        ),
                    )

                    Handler(Looper.getMainLooper()).postDelayed({
                        emit("attendeeJoined", mapOf("name" to "Interviewer"))
                    }, 1200)
                    result.success(true)
                }

                "leave" -> {
                    emit("sessionStopped", mapOf("reason" to "user_left"))
                    result.success(true)
                }

                "toggleMute" -> {
                    val muted = call.argument<Boolean>("muted") ?: false
                    emit("muteStateChanged", mapOf("muted" to muted))
                    result.success(true)
                }

                "toggleCamera" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    emit("videoTileAdded", mapOf("cameraEnabled" to enabled))
                    result.success(true)
                }

                "switchCamera" -> {
                    emit("cameraSwitched", mapOf("facing" to "front"))
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun emit(eventName: String, payload: Map<String, Any?>) {
        val eventData = mapOf(
            "event" to eventName,
            "payload" to payload,
        )
        eventSink?.success(eventData)
    }
}
