import 'package:archiz_staging_admin/features/auth/view/forget_password.dart';
import 'package:archiz_staging_admin/features/auth/view/login_screen.dart';
import 'package:archiz_staging_admin/features/contract/view/add_contract_screen.dart';
import 'package:archiz_staging_admin/features/contract/view/contract_details_screen.dart';
import 'package:archiz_staging_admin/features/contract/view/contracts_screen.dart';
import 'package:archiz_staging_admin/features/contract/view/update_contract_screen.dart';
import 'package:archiz_staging_admin/features/customer/view/add_contact_screen.dart';
import 'package:archiz_staging_admin/features/customer/view/add_customer_screen.dart';
import 'package:archiz_staging_admin/features/customer/view/customers_screen.dart';
import 'package:archiz_staging_admin/features/customer/view/customer_details_screen.dart';
import 'package:archiz_staging_admin/features/customer/view/update_customer_screen.dart';
import 'package:archiz_staging_admin/features/estimate/view/add_estimate_screen.dart';
import 'package:archiz_staging_admin/features/estimate/view/estimate_details_screen.dart';
import 'package:archiz_staging_admin/features/estimate/view/estimate_screen.dart';
import 'package:archiz_staging_admin/features/estimate/view/update_estimate_screen.dart';
import 'package:archiz_staging_admin/features/dashboard/view/dashboard_screen.dart';
import 'package:archiz_staging_admin/features/onboarding/view/onboard_intro_screen.dart';
import 'package:archiz_staging_admin/features/invoice/view/add_invoice_screen.dart';
import 'package:archiz_staging_admin/features/invoice/view/invoice_details_screen.dart';
import 'package:archiz_staging_admin/features/invoice/view/invoice_screen.dart';
import 'package:archiz_staging_admin/features/invoice/view/update_invoice_screen.dart';
import 'package:archiz_staging_admin/features/item/view/item_details_screen.dart';
import 'package:archiz_staging_admin/features/item/view/item_screen.dart';
import 'package:archiz_staging_admin/features/lead/view/add_lead_screen.dart';
import 'package:archiz_staging_admin/features/lead/view/lead_details_screen.dart';
import 'package:archiz_staging_admin/features/lead/view/lead_screen.dart';
import 'package:archiz_staging_admin/features/lead/view/update_lead_screen.dart';
import 'package:archiz_staging_admin/features/menu/view/menu_screen.dart';
import 'package:archiz_staging_admin/features/payment/view/payment_details_screen.dart';
import 'package:archiz_staging_admin/features/payment/view/payment_screen.dart';
import 'package:archiz_staging_admin/features/privacy/view/privacy_policy_screen.dart';
import 'package:archiz_staging_admin/features/profile/view/profile_screen.dart';
import 'package:archiz_staging_admin/features/project/view/add_project_screen.dart';
import 'package:archiz_staging_admin/features/project/view/project_details_screen.dart';
import 'package:archiz_staging_admin/features/project/view/project_screen.dart';
import 'package:archiz_staging_admin/features/project/view/update_project_screen.dart';
import 'package:archiz_staging_admin/features/proposal/view/add_proposal_screen.dart';
import 'package:archiz_staging_admin/features/proposal/view/proposal_details_screen.dart';
import 'package:archiz_staging_admin/features/proposal/view/proposal_screen.dart';
import 'package:archiz_staging_admin/features/proposal/view/update_proposal_screen.dart';
import 'package:archiz_staging_admin/features/splash/view/splash_screen.dart';
import 'package:archiz_staging_admin/features/task/view/add_task_screen.dart';
import 'package:archiz_staging_admin/features/task/view/task_details_screen.dart';
import 'package:archiz_staging_admin/features/task/view/task_screen.dart';
import 'package:archiz_staging_admin/features/task/view/update_task_screen.dart';
import 'package:archiz_staging_admin/features/ticket/view/add_ticket_screen.dart';
import 'package:archiz_staging_admin/features/ticket/view/ticket_details_screen.dart';
import 'package:archiz_staging_admin/features/ticket/view/ticket_screen.dart';
import 'package:archiz_staging_admin/features/ticket/view/update_ticket_screen.dart';
import 'package:archiz_staging_admin/features/visit/view/add_visit_screen.dart';
import 'package:archiz_staging_admin/features/visit/view/add_review_visit_screen.dart';
import 'package:archiz_staging_admin/features/visit/view/visit_detail_screen.dart';
import 'package:archiz_staging_admin/features/visit/view/visit_screen_list.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String splashScreen = "/splash_screen";
  static const String onboardScreen = '/onboard_screen';
  static const String loginScreen = "/login_screen";
  static const String forgotPasswordScreen = "/forgot_password_screen";

  static const String dashboardScreen = "/dashboard_screen";
  static const String customerScreen = "/customer_screen";
  static const String customerDetailsScreen = "/customer_details_screen";
  static const String addCustomerScreen = "/add_customer_screen";
  static const String updateCustomerScreen = "/update_customer_screen";
  static const String addContactScreen = "/add_contact_screen";
  static const String projectScreen = "/project_screen";
  static const String projectDetailsScreen = "/project_details_screen";
  static const String addProjectScreen = "/add_project_screen";
  static const String updateProjectScreen = "/update_project_screen";
  static const String taskScreen = "/task_screen";
  static const String taskDetailsScreen = "/task_details_screen";
  static const String addTaskScreen = "/add_task_screen";
  static const String updateTaskScreen = "/update_task_screen";
  static const String invoiceScreen = "/invoice_screen";
  static const String invoiceDetailsScreen = "/invoice_details_screen";
  static const String addInvoiceScreen = "/add_invoice_screen";
  static const String updateInvoiceScreen = "/update_invoice_screen";
  static const String contractScreen = "/contract_screen";
  static const String contractDetailsScreen = "/contract_details_screen";
  static const String addContractScreen = "/add_contract_screen";
  static const String updateContractScreen = "/update_contract_screen";
  static const String ticketScreen = "/ticket_screen";
  static const String ticketDetailsScreen = "/ticket_details_screen";
  static const String addTicketScreen = "/add_ticket_screen";
  static const String updateTicketScreen = "/update_ticket_screen";
  static const String leadScreen = "/lead_screen";
  static const String leadDetailsScreen = "/lead_details_screen";
  static const String addLeadScreen = "/add_lead_screen";
  static const String updateLeadScreen = "/update_lead_screen";
  static const String estimateScreen = "/estimate_screen";
  static const String estimateDetailsScreen = "/estimate_details_screen";
  static const String addEstimateScreen = "/add_estimate_screen";
  static const String updateEstimateScreen = "/update_estimate_screen";
  static const String proposalScreen = "/proposal_screen";
  static const String proposalDetailsScreen = "/proposal_details_screen";
  static const String addProposalScreen = "/add_proposal_screen";
  static const String updateProposalScreen = "/update_proposal_screen";
  static const String paymentScreen = "/payment_screen";
  static const String paymentDetailsScreen = "/payment_details_screen";
  // static const String itemScreen = "/item_screen";
  static const String itemDetailsScreen = "/item_details_screen";
  static const String settingsScreen = "/settings_screen";
  static const String profileScreen = "/profile_screen";
  static const String privacyScreen = "/privacy_screen";
  // Visit
  static const String itemScreen = "/visit_screen_list";
  static const String visitDetailsScreen = "/visit_details_screen";
  static const String addVisitScreen = "/add_visit_screen";
  static const String addReviewVisitScreen = "/add_review_visit_screen";


  List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: onboardScreen, page: () => const OnBoardIntroScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(
        name: forgotPasswordScreen, page: () => const ForgetPasswordScreen()),
    GetPage(name: dashboardScreen, page: () => const DashboardScreen()),
    GetPage(name: customerScreen, page: () => const CustomersScreen()),
    GetPage(
        name: customerDetailsScreen,
        page: () => CustomerDetailsScreen(id: Get.arguments)),
    GetPage(name: addCustomerScreen, page: () => const AddCustomerScreen()),
    GetPage(
        name: addContactScreen,
        page: () => AddContactScreen(id: Get.arguments)),
    GetPage(
        name: updateCustomerScreen,
        page: () => UpdateCustomerScreen(id: Get.arguments)),
    GetPage(name: projectScreen, page: () => const ProjectsScreen()),
    GetPage(
        name: projectDetailsScreen,
        page: () => ProjectDetailsScreen(id: Get.arguments)),
    GetPage(name: addProjectScreen, page: () => const AddProjectScreen()),
    GetPage(
        name: updateProjectScreen,
        page: () => UpdateProjectScreen(id: Get.arguments)),
    GetPage(name: taskScreen, page: () => const TaskScreen()),
    GetPage(
        name: taskDetailsScreen,
        page: () => TaskDetailsScreen(id: Get.arguments)),
    GetPage(name: addTaskScreen, page: () => const AddTaskScreen()),
    GetPage(
        name: updateTaskScreen,
        page: () => UpdateTaskScreen(id: Get.arguments)),
    GetPage(name: invoiceScreen, page: () => const InvoicesScreen()),
    GetPage(
        name: invoiceDetailsScreen,
        page: () => InvoiceDetailsScreen(id: Get.arguments)),
    GetPage(name: addInvoiceScreen, page: () => const AddInvoiceScreen()),
    GetPage(
        name: updateInvoiceScreen,
        page: () => UpdateInvoiceScreen(id: Get.arguments)),
    GetPage(name: contractScreen, page: () => const ContractsScreen()),
    GetPage(
        name: contractDetailsScreen,
        page: () => ContractDetailsScreen(id: Get.arguments)),
    GetPage(name: addContractScreen, page: () => const AddContractScreen()),
    GetPage(
        name: updateContractScreen,
        page: () => UpdateContractScreen(id: Get.arguments)),
    GetPage(name: ticketScreen, page: () => const TicketsScreen()),
    GetPage(
        name: ticketDetailsScreen,
        page: () => TicketDetailsScreen(id: Get.arguments)),
    GetPage(name: addTicketScreen, page: () => const AddTicketScreen()),
    GetPage(
        name: updateTicketScreen,
        page: () => UpdateTicketScreen(id: Get.arguments)),
    GetPage(name: leadScreen, page: () => const LeadScreen()),
    GetPage(
        name: leadDetailsScreen,
        page: () => LeadDetailsScreen(id: Get.arguments)),
    GetPage(name: addLeadScreen, page: () => const AddLeadScreen()),
    GetPage(
        name: updateLeadScreen,
        page: () => UpdateLeadScreen(id: Get.arguments)),
    GetPage(name: estimateScreen, page: () => const EstimateScreen()),
    GetPage(
        name: estimateDetailsScreen,
        page: () => EstimateDetailsScreen(id: Get.arguments)),
    GetPage(name: addEstimateScreen, page: () => const AddEstimateScreen()),
    GetPage(
        name: updateEstimateScreen,
        page: () => UpdateEstimateScreen(id: Get.arguments)),
    GetPage(name: proposalScreen, page: () => const ProposalScreen()),
    GetPage(
        name: proposalDetailsScreen,
        page: () => ProposalDetailsScreen(id: Get.arguments)),
    GetPage(name: addProposalScreen, page: () => const AddProposalScreen()),
    GetPage(
        name: updateProposalScreen,
        page: () => UpdateProposalScreen(id: Get.arguments)),
    GetPage(name: paymentScreen, page: () => const PaymentScreen()),
    GetPage(
        name: paymentDetailsScreen,
        page: () => PaymentDetailsScreen(id: Get.arguments)),
    // GetPage(name: itemScreen, page: () => const ItemScreen()),
    GetPage(
        name: itemDetailsScreen,
        page: () => ItemDetailsScreen(id: Get.arguments)),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: settingsScreen, page: () => const MenuScreen()),
    GetPage(name: privacyScreen, page: () => const PrivacyPolicyScreen()),

    GetPage(name: itemScreen, page: () => const VisitScreen()),
    GetPage(name: addVisitScreen, page: () => const AddVisitScreen()),
    GetPage(name: addReviewVisitScreen, page: () => const AddReviewVisitScreen()),
    GetPage(name: visitDetailsScreen, page: () => VisitDetailsScreen(id: Get.arguments)),

  ];
}
