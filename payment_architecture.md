# Phase 8 — Payment Gateway Architecture Specification

## Overview
Provider-agnostic payment gateway abstraction (`PaymentGatewayContract`) supporting multiple global payment processors.

---

## 1. Supported Payment Gateways
- **Google Play Billing**: Android native IAP.
- **Apple In-App Purchase**: iOS native IAP.
- **Stripe**: International credit card processing.
- **Razorpay**: Indian UPI, Netbanking, & cards.
- **UPI**: Direct UPI deep-link payment processing.
- **PayPal**: International wallet payments.
- **Mock Payment Gateway**: Local test environment gateway.
