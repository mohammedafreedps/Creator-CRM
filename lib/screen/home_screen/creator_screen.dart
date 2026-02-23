import 'package:creator_tracker/models/creator.dart';
import 'package:creator_tracker/repository/creator_repository.dart';
import 'package:creator_tracker/screen/home_screen/cubit/creator_cubit/creator_cubit.dart';
import 'package:creator_tracker/screen/home_screen/cubit/creator_cubit/creator_state.dart';
import 'package:creator_tracker/service/creator_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CreatorScreen extends StatelessWidget {
  const CreatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiService = CreatorApiService(
          baseUrl: 'https://script.google.com/macros/s/AKfycbyaI2K-vL08-Ku5DKHlp3P1DTqefRPuciU6g23v3jokKTYiHaaZS55JURWshyy21bsT/exec',
        );
        final repository = CreatorRepository(apiService);
        return CreatorCubit(repository)..fetchCreators();
      },
      child: const CreatorView(),
    );
  }
}

class CreatorView extends StatelessWidget {
  const CreatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CreatorCubit>().refreshCreators();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<CreatorCubit, CreatorState>(
        listener: (context, state) {
          if (state is CreatorOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CreatorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<CreatorCubit>().fetchCreators();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CreatorLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CreatorError && state.creators.isEmpty) {
            return _buildErrorView(context, state.message);
          }

          final creators = _getCreators(state);

          if (creators.isEmpty) {
            return _buildEmptyView();
          }

          return _buildCreatorList(context, creators, state);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCreatorDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Creator'),
      ),
    );
  }

  List<Creator> _getCreators(CreatorState state) {
    if (state is CreatorLoaded) return state.creators;
    if (state is CreatorOperationSuccess) return state.creators;
    if (state is CreatorError) return state.creators;
    if (state is CreatorCreating) return state.creators;
    if (state is CreatorUpdating) return state.creators;
    if (state is CreatorDeleting) return state.creators;
    return [];
  }

  Widget _buildCreatorList(BuildContext context, List<Creator> creators, CreatorState state) {
    final isOperating = state is CreatorCreating ||
        state is CreatorUpdating ||
        state is CreatorDeleting;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => context.read<CreatorCubit>().refreshCreators(),
          child: ListView.builder(
            itemCount: creators.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final creator = creators[index];
              return _buildCreatorCard(context, creator);
            },
          ),
        ),
        if (isOperating)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildCreatorCard(BuildContext context, Creator creator) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            creator.creatorName.isNotEmpty
                ? creator.creatorName[0].toUpperCase()
                : '?',
          ),
        ),
        title: Text(
          creator.creatorName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${creator.platform} • ${creator.niche}'),
            if (creator.followerCount.isNotEmpty)
              Text(
                'Followers: ${creator.followerCount}',
                style: const TextStyle(fontSize: 12),
              ),
            if (creator.outreachStatus.isNotEmpty)
              Chip(
                label: Text(
                  creator.outreachStatus,
                  style: const TextStyle(fontSize: 11),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditCreatorDialog(context, creator),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context, creator),
            ),
          ],
        ),
        onTap: () => _showCreatorDetails(context, creator),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CreatorCubit>().fetchCreators();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No creators found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first creator',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showAddCreatorDialog(BuildContext context) {
    final nameController = TextEditingController();
    final platformController = TextEditingController();
    final nicheController = TextEditingController();
    final followersController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Creator'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Creator Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: platformController,
                decoration: const InputDecoration(
                  labelText: 'Platform',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nicheController,
                decoration: const InputDecoration(
                  labelText: 'Niche',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: followersController,
                decoration: const InputDecoration(
                  labelText: 'Follower Count',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Creator name is required')),
                );
                return;
              }

              final newCreator = Creator(
                creatorName: nameController.text.trim(),
                platform: platformController.text.trim(),
                niche: nicheController.text.trim(),
                followerCount: followersController.text.trim(),
              );

              context.read<CreatorCubit>().createCreator(newCreator);
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCreatorDialog(BuildContext context, Creator creator) {
    final nameController = TextEditingController(text: creator.creatorName);
    final platformController = TextEditingController(text: creator.platform);
    final nicheController = TextEditingController(text: creator.niche);
    final statusController = TextEditingController(text: creator.outreachStatus);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Creator'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Creator Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: platformController,
                decoration: const InputDecoration(
                  labelText: 'Platform',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nicheController,
                decoration: const InputDecoration(
                  labelText: 'Niche',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                  labelText: 'Outreach Status',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedCreator = creator.copyWith(
                creatorName: nameController.text.trim(),
                platform: platformController.text.trim(),
                niche: nicheController.text.trim(),
                outreachStatus: statusController.text.trim(),
              );

              context.read<CreatorCubit>().updateCreator(updatedCreator);
              Navigator.pop(dialogContext);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Creator creator) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Creator'),
        content: Text('Are you sure you want to delete "${creator.creatorName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CreatorCubit>().deleteCreator(creator);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreatorDetails(BuildContext context, Creator creator) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(creator.creatorName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Platform', creator.platform),
              _detailRow('Niche', creator.niche),
              _detailRow('Followers', creator.followerCount),
              _detailRow('Status', creator.outreachStatus),
              _detailRow('Phone', creator.phoneNumber.toString()),
              _detailRow('Address', creator.address),
              if (creator.notes.isNotEmpty) ...[
                const Divider(),
                const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(creator.notes),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Search Creators'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by name, platform, or niche',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) {
            context.read<CreatorCubit>().filterCreators(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CreatorCubit>().filterCreators('');
              Navigator.pop(dialogContext);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}