part of '../main.dart';

class ListGroup extends StatelessWidget {
  const ListGroup({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<ParentalBloc>()
        .add(const LoadParentals(1)); //TODO: Change userId
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar('List Group', actions: [
        IconButton(
          onPressed: () {
            // Modular.to.pushNamed('/group/add');
          },
          icon: const Icon(Icons.add),
        )
      ]),
      body: ListView(
        children: [
          BlocBuilder<ParentalBloc, ParentalState>(builder: (context, state) {
            if (state is ParentalsLoaded) {
              return Column(
                children: List.generate(state.parentals.length, (index) {
                  return ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(state.parentals[index].name),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Modular.to
                          .pushNamed('/parental/${state.parentals[index].id}');
                    },
                  );
                }),
              );
            } else if (state is ParentalLoading) {
              return Shimmer.fromColors(
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
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}
