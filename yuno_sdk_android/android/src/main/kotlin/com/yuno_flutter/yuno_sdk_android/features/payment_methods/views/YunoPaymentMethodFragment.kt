package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import com.yuno.payments.features.payment.ui.views.DynamicPaymentMethodListView

class PaymentMethodFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val rootView = FrameLayout(requireContext())
//        val paymentMethodListView = DynamicPaymentMethodListView(
//            requireActivity(),
//            lifecycle
//        )
//        rootView.addView(paymentMethodListView)
        return rootView
    }
}