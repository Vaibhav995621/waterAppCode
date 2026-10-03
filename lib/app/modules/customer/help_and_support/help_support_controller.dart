import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';

class HelpSupportController extends GetxController {
  static const String supportEmail = "h2oexpress01@gmail.com";
  static const String supportPhone = "8851146100";
  static const String formattedPhone = "+91 8851146100";

  final RxInt expandedFaqIndex = (-1).obs;

  final List<Map<String, String>> faqs = [
    {
      "question": "How do I place a water bottle order?",
      "answer":
          "You can place an order by navigating to 'Book Now' on the bottom menu. Select your preferred water bottle brand, quantity, delivery date, time slot, and delivery address to proceed to checkout.",
    },
    {
      "question": "How do subscription plans work?",
      "answer":
          "Subscription plans allow you to save more per bottle with regular scheduled deliveries. Choose from 7 Days, 15 Days, or monthly plans in the Subscription section to enjoy discounted rates.",
    },
    {
      "question": "What are your delivery timings?",
      "answer":
          "We operate and deliver 7 days a week from 6:00 AM to 10:00 PM across multiple scheduled time slots. You can pick your convenient slot during checkout.",
    },
    {
      "question": "How do I use my Wallet balance?",
      "answer":
          "You can top up your wallet under the Wallet tab using UPI, Cards, or Net Banking. When paying for orders, select 'Wallet' as the payment method for 1-tap instant checkouts.",
    },
    {
      "question": "How can I track my delivery status?",
      "answer":
          "Go to 'My Orders' in your profile or home screen. You will see real-time order updates such as Pending, Out for Delivery, and Delivered.",
    },
    {
      "question": "Can I cancel or reschedule an order?",
      "answer":
          "For scheduled orders, you can manage your delivery calendar in 'Schedule Order'. For instant assistance with an ongoing order, reach out to our support team via call or WhatsApp.",
    },
  ];

  void toggleFaq(int index) {
    if (expandedFaqIndex.value == index) {
      expandedFaqIndex.value = -1;
    } else {
      expandedFaqIndex.value = index;
    }
  }

  /// Make direct phone call
  Future<void> callSupport() async {
    final Uri uri = Uri.parse('tel:$supportPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      AppSnackbar.error("Could not launch dialer: $e");
    }
  }

  /// Open WhatsApp chat
  Future<void> openWhatsApp() async {
    final String message = Uri.encodeComponent(
      "Hi H2O Express Support Team,\n\nI need assistance with my account/order.\nName: ${AppSession.name}\nMobile: ${AppSession.mobileNo}",
    );
    final Uri uri = Uri.parse("https://wa.me/91$supportPhone?text=$message");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        AppSnackbar.error("WhatsApp is not installed on this device");
      }
    } catch (e) {
      AppSnackbar.error("Could not open WhatsApp: $e");
    }
  }

  /// Send email to support
  Future<void> sendEmail() async {
    final String subject = Uri.encodeComponent("Support Request - H2O Express");
    final String body = Uri.encodeComponent(
      "Hi H2O Express Team,\n\n"
      "Customer Name: ${AppSession.name}\n"
      "Mobile Number: ${AppSession.mobileNo}\n\n"
      "Please describe your issue or query below:\n",
    );
    final Uri uri = Uri.parse("mailto:$supportEmail?subject=$subject&body=$body");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        copyToClipboard(supportEmail, "Email address");
      }
    } catch (e) {
      copyToClipboard(supportEmail, "Email address");
    }
  }

  /// Copy text to clipboard
  void copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackbar.success("$label copied to clipboard");
  }
}
