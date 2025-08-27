const baseUrl = 'http://10.0.2.2:8080';
// const baseUrl = 'http://127.0.0.1:8080';
const loginUrl = '$baseUrl/login';
const registerUrl = '$baseUrl/register';
const fcmUrl = '$baseUrl/fcm/token';

const appointmentUrl = '$baseUrl/appointment';
const appointmentUserUrl = '$appointmentUrl/user';

const deviceUrl = '$baseUrl/device';
const deviceUserUrl = '$deviceUrl/user';
const deviceRegisterUrl = '$deviceUrl/register-user';

const containerUrl = '$baseUrl/container';

const deviceControlUrl = '$deviceUrl/controls';
const deviceControlCountUrl = '$deviceUrl/control/count';

const reminderUrl = '$baseUrl/reminder';
const reminderUserUrl = '$reminderUrl/user';

const parentalUrl = '$baseUrl/parental';
const parentalQRUrl = '$parentalUrl/qr';
const parentalUserUrl = '$parentalUrl/user';

const medicalRecordURL = '$baseUrl/medical-record';
const medicalAnalyticsUrl = '$medicalRecordURL/summary';
