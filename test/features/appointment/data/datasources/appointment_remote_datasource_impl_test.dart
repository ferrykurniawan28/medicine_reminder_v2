// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:medicine_reminder/core/network/network_service.dart';
// import 'package:medicine_reminder/features/appointment/data/datasources/appointment_remote_datasource_impl.dart';
// import 'package:medicine_reminder/features/appointment/data/models/appointment_model.dart';

// class MockNetworkService extends Mock implements NetworkService {}

// void main() {
//   late AppointmentRemoteDataSourceImpl dataSource;
//   late MockNetworkService mockNetworkService;

//   setUp(() {
//     mockNetworkService = MockNetworkService();
//     dataSource = AppointmentRemoteDataSourceImpl(mockNetworkService);
//   });

//   group('fetchAppointments', () {
//     test('returns list of AppointmentModel on success', () async {
//       // Arrange
//       final userId = 1;
//       final mockResponse = {
//         'statusCode': 200,
//         'data': [
//           {
//             'id': 2,
//             'created_by': {
//               'id': 1,
//               'username': 'john',
//               'email': 'john@example.com'
//             },
//             'assigned_to': {
//               'id': 1,
//               'username': 'john',
//               'email': 'john@example.com'
//             },
//             'doctor': 'Dr. Smith',
//             'notes': 'Follow-up visit',
//             'dates': '2025-06-01T10:00:00Z',
//             'is_synced': 1
//           }
//         ]
//       };
//       when(mockNetworkService.get<Map<String, dynamic>>(any<String>(),
//               fromData: anyNamed('fromData')))
//           .thenAnswer((_) async => mockResponse);

//       // Act
//       final result = await dataSource.fetchAppointments(userId);

//       // Assert
//       expect(result, isA<List<AppointmentModel>>());
//       expect(result.first.doctor, 'Dr. Smith');
//     });
//   });

//   // Add more tests for fetchAppointment, addAppointment, updateAppointment, deleteAppointment, syncAppointments
// }
