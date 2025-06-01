part of '../main.dart';

class ListParental extends StatefulWidget {
  const ListParental({super.key});

  @override
  State<ListParental> createState() => _ListParentalState();
}

class _ListParentalState extends State<ListParental> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<ParentalBloc>()
        .add(const LoadParentals(1)); //TODO: Change userId
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   title: const Text('Family Members'),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () => Modular.to.pushNamed('/home/parental/add'),
      //       color: kPrimaryColor,
      //     ),
      //   ],
      // ),
      body: BlocBuilder<ParentalBloc, ParentalState>(
        builder: (context, state) {
          if (state is ParentalLoading) {
            return _buildShimmerLoading();
          } else if (state is ParentalsLoaded) {
            if (state.parentals.isEmpty) {
              return _buildEmptyState();
            }
            return _buildParentalList(state.parentals);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed('/home/parental/add'),
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        tooltip: 'Add Family Member',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_add,
            size: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No Family Members Added',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a family member to manage their medications',
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Modular.to.pushNamed('/home/parental/add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Add Family Member',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentalList(List<Parental> parentals) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search family members...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              // Add search functionality here
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: parentals.length,
            itemBuilder: (context, index) {
              final parental = parentals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    parental.user.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // subtitle: Text(
                  //   '${parental.medications.length} medications',
                  //   style: TextStyle(
                  //     color: Colors.grey[600],
                  //   ),
                  // ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                  onTap: () {
                    Modular.to.pushNamed(
                      '/home/parental/detail',
                      arguments: {'parental': parental},
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
