part of 'models.dart';

class Group {
  final int id;
  final String name;
  final int creatorId;
  final List<UserGroup> users;

  Group({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.users,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      creatorId: json['creatorId'],
      users: (json['users'] as List)
          .map((user) => UserGroup.fromJson(user))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creatorId': creatorId,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }

  Group copyWith({
    int? id,
    String? name,
    int? creatorId,
    List<UserGroup>? users,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      users: users ?? this.users,
    );
  }
}

List<Group> dummyGroup = [
  Group(
    id: 1,
    name: 'Group 1',
    creatorId: 1,
    users: [
      UserGroup(userId: 1, userName: 'User 1', role: UserGroupRole.admin),
      UserGroup(userId: 2, userName: 'User 2', role: UserGroupRole.member),
    ],
  ),
  Group(
    id: 2,
    name: 'Group 2',
    creatorId: 2,
    users: [
      UserGroup(userId: 1, userName: 'User 1', role: UserGroupRole.admin),
      UserGroup(userId: 3, userName: 'User 3', role: UserGroupRole.member),
    ],
  ),
  Group(
    id: 3,
    name: 'Group 3',
    creatorId: 3,
    users: [
      UserGroup(userId: 1, userName: 'User 1', role: UserGroupRole.admin),
      UserGroup(userId: 4, userName: 'User 4', role: UserGroupRole.member),
    ],
  ),
];
//  In the code snippet above, we have a  Group  model class that represents a group of users. The  Group  class has the following properties: 
 
//  id : The ID of the group. 
//  name : The name of the group. 
//  creatorId : The ID of the user who created the group. 
//  users : A list of  UserGroup  objects representing the users in the group. 
 
//  The  Group  class also has the following methods: 
 
//  fromJson : A factory method that creates a  Group  object from a JSON object. 
//  toJson : A method that converts a  Group  object to a JSON object. 
//  copyWith : A method that creates a copy of a  Group  object with some properties updated. 
 
//  The  Group  class also has a list of dummy groups ( dummyGroup ) that can be used for testing. 
//  The  Group  class depends on the  UserGroup  class, which represents a user in a group. The  UserGroup  class has the following properties: 
 
//  userId : The ID of the user. 
//  userName : The name of the user. 
//  role : The role of the user in the group ( admin  or  member ). 
 
//  The  UserGroup  class also has the following methods: 
 
//  fromJson : A factory method that creates a  UserGroup  object from a JSON object.
//  toJson : A method that converts a  UserGroup  object to a JSON object.