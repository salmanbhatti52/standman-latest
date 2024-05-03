const appID = "ba085491-2136-4c51-ac44-07b4d43e9247";

String baseUrl = "https://admin.standman.ca/api/";

String baseUrlImage = 'https://admin.standman.ca/public/';

String customerSignupApiUrl = "${baseUrl}signup";

String customerSignInApiUrl = "${baseUrl}signin";

String ForgotPasswordApiUrl = "${baseUrl}forgot_password";

String ModifyPasswordApiUrl = "${baseUrl}modify_my_password";

String employeeSignupApiUrl = "${baseUrl}signup";

String employeeSignInApiUrl = "${baseUrl}signin";

String deleteAccountApiUrl = "${baseUrl}delete_account";

String usersProfileApiUrl = "${baseUrl}get_profile";

String updateCustomerProfileApiUrl = "${baseUrl}update_profile";

String changePasswordFromProfileApiUrl = "${baseUrl}update_password";

String getAllChatApiUrl = "${baseUrl}get_chat_list";

String userChatApiUrl = "${baseUrl}user_chat";
String completeJobEmployeeAPI = "${baseUrl}complete_job_employee";
String completeJobCustomerAPI = "${baseUrl}complete_job_customer";
String cancelJobAPI = "${baseUrl}cancel_job";
String jobDetailsAPI = "${baseUrl}job_details";

String getUserChatApiUrl = "${baseUrl}user_chat";

String sendMessageCustomerApiUrl = "${baseUrl}user_chat";

String sendMessageEmployeeApiUrl = "${baseUrl}user_chat";

String updateMessageApiUrl = "${baseUrl}user_chat";

String jobsCreateModelApiUrl = "${baseUrl}create_job";

String jobsPriceModelApiUrl = "${baseUrl}get_job_creation_charges";

String getJobsEmployeesModelApiUrl = "${baseUrl}get_jobs_employee";

String getPreviousJobsModelApiUrl = "${baseUrl}get_jobs_previous_customer";

String updateEmployeeProfileApiUrl = "${baseUrl}update_profile";

String systemSettingsApiUrl = "${baseUrl}system_settings/";

String searchJobsCustomersApiUrl = "${baseUrl}search_jobs_customers";

String searchJobsEmployeesApiUrl = "${baseUrl}search_jobs_employees";

String getPreviousJobsEmployeeModelApiUrl =
    "${baseUrl}get_jobs_previous_employee";

String getOngoingJobsEmployeeModelApiUrl =
    "${baseUrl}get_jobs_ongoing_employee";

String CustomerMyJobModelApiUrl = "${baseUrl}get_jobs_customer";

String getOngoingJobsModelApiUrl = "${baseUrl}get_jobs_ongoing_customer";

String notificationsModelApiUrl = "${baseUrl}get_notifications";

String system_settingsModelApiUrl = "${baseUrl}get_system_settings";

String notificationPermissionModelApiUrl =
    "${baseUrl}update_switch_notifications";

String messagesPermissionModelApiUrl = "${baseUrl}update_switch_messages";

String jobsExtraAmountModelApiUrl = "${baseUrl}jobs_extra_amount";

String jobsCustomersCompleteModelApiUrl = "${baseUrl}jobs_customers_complete";

String customerWalletTxnModelApiUrl = "${baseUrl}get_transactions_customer";

String employeeWalletTxnModelApiUrl = "${baseUrl}get_transactions_employee";

String addJobRatingModelApiUrl = "${baseUrl}add_jobs_ratings";

String allJobRatingModelApiUrl = "${baseUrl}get_jobs_ratings";

String unreadedMessagesModelApiUrl = "${baseUrl}unreaded_messages";

String getAdminApiUrl = "${baseUrl}get_admin_list";

String userChatLiveApiUrl = "${baseUrl}user_chat_live";

String sendMessageLiveApiUrl = "${baseUrl}user_chat_live";

String getMessageLiveApiUrl = "${baseUrl}user_chat_live";

String jobCreationPaymentApiUrl = "${baseUrl}pay_created_job_price";

String updateJobRadiusApiUrl = "${baseUrl}change_job_radius";

String employeeArrived = "${baseUrl}employee_arrived";

String customerEditableJobs = "${baseUrl}get_jobs_editable_customer";

String checkJobsExtraTime = "${baseUrl}jobs_complete_without_extra_time";
