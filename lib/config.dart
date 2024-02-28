// ignore_for_file: prefer_const_declarations

final url = 'http://13.211.176.246:8000';
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
final getDeviceForDoctor = '&$url/api/logger/logs/Allevents/Events';

