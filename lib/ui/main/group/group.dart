part of '../main.dart';

class GroupDetailPage extends StatefulWidget {
  final int groupId;
  const GroupDetailPage({super.key, required this.groupId});

  @override
  State<GroupDetailPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParentalBloc>().add(LoadParental(widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentalBloc, ParentalState>(
      builder: (context, state) {
        if (state is ParentalLoaded) {
          Group group = state.parental;
          List<UserGroup> userGroup = group.users;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: defaultAppBar(
              group.name,
              leading: IconButton(
                  onPressed: () {
                    Modular.to.pop();
                    context.read<ParentalBloc>().add(const LoadParentals(1));
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
            body: ListView(children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userGroup.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(userGroup[index].userName),
                    trailing: userGroup[index].role == UserGroupRole.admin
                        ? const Text('Admin')
                        : const Text('Member'),
                    onTap: () {
                      // Modular.to.pushNamed('/parental/${state.parentals[index].id}');
                    },
                  );
                },
              ),
            ]),
          );
        } else if (state is ParentalLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: defaultAppBar('Parental'),
            body: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
