part of '../main.dart';

class ListParental extends StatefulWidget {
  const ListParental({super.key});

  @override
  State<ListParental> createState() => _ListParentalState();
}

class _ListParentalState extends State<ListParental> {
  bool _isFetching = false;

  @override
  initState() {
    super.initState();
    _fetchParentals();
  }

  void _fetchParentals() {
    if (_isFetching || !mounted) return;

    _isFetching = true; // Set fetching flag to true

    try {
      UserHelper.executeWithUserId(context, (int userId) {
        context.read<ParentalBloc>().add(LoadParentals(userId));
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching parentals: $e'),
          ),
        );
      }
    } finally {
      _isFetching = false; // Reset fetching flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: defaultAppBar('Parental', actions: [
      //   IconButton(
      //     onPressed: () {
      //       // Modular.to.pushNamed('/group/add');
      //     },
      //     icon: const Icon(Icons.add),
      //   )
      // ]),
      body: BlocBuilder<ParentalBloc, ParentalState>(
        builder: (context, state) {
          if (state is ParentalLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ParentalsLoaded) {
            if (state.parentals.isEmpty) {
              return const Center(
                child: Text('No parentals found add one!'),
              );
            }
            return CupertinoListSection(
              header: const CupertinoTextField(
                placeholder: 'Search',
                prefix: Icon(CupertinoIcons.search),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                cursorRadius: Radius.circular(18),
              ),
              children: [
                for (final parental in state.parentals)
                  CupertinoListTile(
                    title: Text(parental.user.userName!),
                    leading: const Icon(CupertinoIcons.person),
                    onTap: () {
                      Modular.to.pushNamed(
                        '/parental/detail',
                        arguments: {
                          'parental': parental,
                        },
                      );
                      // Modular.to
                      //     .navigate('/home/parental/reminder/', arguments: {
                      //   'parental': parental,
                      // });
                    },
                  ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/scan-barcode', arguments: {
            'title': 'Scan Parental ID',
            'onScanned': (String parentalId) {
              String parentalUid = parentalId;
              if (parentalUid.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Scanned code is empty. Please try again.'),
                  ),
                );
                return;
              }

              print('Scanned parental ID: $parentalId');

              final sucess = UserHelper.executeWithUserId(context, (int id) {
                context.read<ParentalBloc>().add(ParentalAdd(id, parentalId));
              }, errorMessage: 'Error adding parental relationship.');

              if (sucess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Parental relationship added successfully.'),
                  ),
                );
                Modular.to.pop();
              }
            },
          });
        },
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        tooltip: 'Add Parental',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
