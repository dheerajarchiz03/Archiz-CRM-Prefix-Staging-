class UrlContainer {
 // static const String domainUrl = 'http://143.110.187.154'; // Staging
 static const String domainUrl = 'https://archizsolutions.co.in'; // New Staging
  static const String baseUrl = '$domainUrl/flutex_admin_api/';
  static const String downloadUrl = '$domainUrl/download/file';
  static const String uploadPath = 'uploads';
  static const String ticketAttachmentUrl = '$domainUrl/download/preview_image?path=$uploadPath/ticket_attachments/';

  static RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  // Authentication
  static const String loginUrl = 'auth/login';
  static const String logoutUrl = 'auth/logout';
  static const String forgotPasswordUrl = 'auth/forgot-password';
  // Pages
  static const String overviewUrl = 'overview';
  static const String dashboardUrl = 'dashboard';
  static const String profileUrl = 'profile';
  static const String customersUrl = 'customers';
  static const String contactsUrl = 'contacts';
  static const String projectsUrl = 'projects';
  static const String invoicesUrl = 'invoices';
  static const String contractsUrl = 'contracts';
  static const String estimatesUrl = 'estimates';
  static const String proposalsUrl = 'proposals';
  static const String ticketsUrl = 'tickets';
  static const String leadsUrl = 'leads';
  static const String tasksUrl = 'tasks';
  static const String paymentsUrl = 'payments';
  static const String itemsUrl = 'items';
  static const String miscellaneousUrl = 'miscellaneous';
  static const String privacyPolicyUrl = 'policy-pages';
 static const String visitUrl = 'visite';
 static const String accountUrl = 'accounting';
  // Download URLs
  static const String leadAttachmentUrl = '$downloadUrl/lead_attachment';
  static const String salesAttachmentUrl = '$downloadUrl/sales_attachment';
}


// Accounting Api's
// GET- https://archizsolutions.co.in/flutex_admin_api/accounting/sales_table // transaction sales payment
// GET -https://archizsolutions.co.in/flutex_admin_api/accounting/sales_invoice_table  // transaction sames invoice
// GET -https://archizsolutions.co.in/flutex_admin_api/accounting/expenses_table  // transaction Expenses
// GET -https://archizsolutions.co.in/flutex_admin_api/accounting/payslips_table  // transaction pay sleep

// GET- https://archizsolutions.co.in/flutex_admin_api/accounting/accounts_table // Registers List

// POST- https://archizsolutions.co.in/flutex_admin_api/accounting/add_transfer // Add Transfer
// GET - https://archizsolutions.co.in/flutex_admin_api/accounting/transfer_table   // Get Transfer List
// POST- https://archizsolutions.co.in/flutex_admin_api/accounting/new_journal_entry // Add journal entry
// Get- https://archizsolutions.co.in/flutex_admin_api/accounting/journal_entry_table // get journal List
// GET- https://archizsolutions.co.in/flutex_admin_api/accounting/registers_table    // get Register account list for journal entry