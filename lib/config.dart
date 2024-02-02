// ignore_for_file: prefer_const_declarations

final url = 'http://52.64.235.38:8000';
// final url = 'http://localhost:8000';
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

