package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views


import android.view.View

import android.os.Bundle
import android.os.PersistableBundle
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.activity.ComponentActivity
import io.flutter.plugin.common.MethodChannel
import android.widget.FrameLayout
import android.widget.ScrollView
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import com.yuno.payments.features.payment.startCheckout
import com.yuno.payments.features.payment.ui.views.DynamicPaymentMethodListView
import com.yuno.payments.features.payment.updateCheckoutSession
import com.yuno_flutter.yuno_sdk_android.R

class PaymentMethodFragment : Fragment() {

    private var methodChannel: MethodChannel? = null
    private var dynamicView: DynamicPaymentMethodListView? = null
    private lateinit var scrollView: ScrollView

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        dynamicView = DynamicPaymentMethodListView(
            context = requireContext(),
            lifecycle = viewLifecycleOwner.lifecycle
        ).apply {
            setOnSelectedEvent { selected ->
                methodChannel?.invokeMethod("onPaymentMethodSelected", selected.toString())
            }
        }
        return dynamicView
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        scrollView = view.findViewById(R.id.payment_method_container)

        updateViews()
    }


    private fun updateViews() {

        if (dynamicView != null) {
            scrollView.removeView(dynamicView)
            scrollView.removeAllViews()
        }

        dynamicView = DynamicPaymentMethodListView(
            context = requireContext(), // Use requireContext() in fragments
            lifecycle = viewLifecycleOwner.lifecycle // Use fragment's lifecycle
        ).apply {
            setOnSelectedEvent { selected ->
                methodChannel?.invokeMethod("onPaymentMethodSelected", selected.toString())
            }
        }

        // Add the dynamic view to the scrollView
        scrollView.addView(dynamicView)
        scrollView.visibility = View.VISIBLE

        // Request layout updates after adding the view
        scrollView.viewTreeObserver.addOnGlobalLayoutListener {
            scrollView.requestLayout()
        }
    }

    // Set the MethodChannel to communicate with Flutter
    fun setMethodChannel(channel: MethodChannel) {
        methodChannel = channel
    }
}

class PaymentMethodActivity : FragmentActivity() {

    private var methodChannel: MethodChannel? = null
    private var dynamicView: DynamicPaymentMethodListView? = null
    private lateinit var scrollView: ScrollView

    override fun onCreate(savedInstanceState: Bundle?) {
        setContentView(R.layout.yuno_payment_method_list_view)
        scrollView = findViewById(R.id.payment_method_container)
        updateViews()
        super.onCreate(savedInstanceState)

    }
    private fun updateViews(){
        if (dynamicView != null) {
            scrollView.removeView(dynamicView)
            scrollView.removeAllViews()
        }

        val paymentMethodListView =DynamicPaymentMethodListView(
            this,
            lifecycle
        ).apply {
            setOnSelectedEvent { selected ->
                methodChannel?.invokeMethod("onPaymentMethodSelected", selected.toString())
            }
        }
        scrollView.addView(
            paymentMethodListView
        )
        scrollView.visibility = View.VISIBLE
        scrollView.viewTreeObserver.addOnGlobalLayoutListener { scrollView.requestLayout() }
    }


    // Set the MethodChannel to communicate with Flutter
    fun setMethodChannel(channel: MethodChannel) {
        methodChannel = channel
    }
}
