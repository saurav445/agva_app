// ignore_for_file: prefer_const_declarations
// AWS PUBLIC IP
// 3.25.213.83:8000
//Local IP 192.168.2.1:8000

final url = 'http://192.168.2.1:8000';
final registerUser = '$url/api/logger/auth/register';
final loginUser = '$url/api/logger/auth/login';
final getDevicesByHospital = '$url/devices/get-devices-by-hospital';
final getDeviceForUser = '$url/api/logger/logs/Allevents/get-devices-for-users';
final getProjects = '$url/api/logger/projects';
final getProductionData = '$url/production/get-byid';
final getDeviceEventbyID = '$url/api/logger/logs/deviceEvents';
final getDeviceTrendsbyID = '$url/api/logger/logs/deviceTrends';
final getDeviceAlarmsbyID = '$url/api/logger/logs/deviceAlerts';
final getDeviceCalibyID = '$url/api/logger/logs/calibration';
final getDeviceCrashLogsbyID = '$url/api/logger/logs/deviceLogs';
final addtofocus = '$url/devices/update-addtofocus';
final getFocusDevices = '$url/api/logger/logs/Allevents/get-focused-devices';
final getStatus = '$url/devices/get-addtofocus';
final getProfile = '$url/api/logger/users';
final verifyOtp = '$url/api/logger/verify-sms-otp';
final sendOtp = '$url/api/logger/send-otp-sms';
final hospitalList = '$url/hospital/hospital-list';
final getDeviceForDoctor = '$url/api/logger/logs/Allevents/Events';
final getActiveUsers = '$url/api/logger/active-users-list';
final getInactiveUsers = '$url/api/logger/inactive-users-list';
final getPendingUsers = '$url/api/logger/pending-users-list';
final updateUserstatus = '$url/api/logger/user-account-status';
final addPatientData = '$url/patient/save-uhid-details';
final patientFileupload = '$url/patient/upload-patient-file';
final patientList = '$url/patient/get-patient-list';
final updatePatientDetails = '$url/patient/update-patient';
final addDiagnoseDetails = '$url/patient/add-medical-diagnose';
final getAllPatientList = '$url/patient/get-allUhid';
final dosageList = '$url/patient/get-diagnose';
final requestDeviceinfo = '$url/api/logger/send-device-req';
final assignDevice = '$url/api/logger/assign-device-to-assistant';
final getAssignedList = '$url/api/logger/get-assistant-list';
final revokeAssign = '$url/api/logger/logs/delete-access-from-assistant';
final getAssignedAssistandList ='$url/api/logger/logs/get-device-access-ast-list';
final gethospitallist = '$url/hospital/get-access-hospital-list';



// &&  device['deviceInfo']?[0]['Hospital_Name'] == 'KGMU Lucknow' 