import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/Transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/transaction_card.dart';
import 'transaction_detail_screen.dart';
// import '../models/transaction_model.dart';
import 'dart:math';

class TransactionSummaryScreen extends ConsumerStatefulWidget {
  const TransactionSummaryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TransactionSummaryScreen> createState() => _TransactionSummaryScreenState();
}

class _TransactionSummaryScreenState extends ConsumerState<TransactionSummaryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionNotifierProvider.notifier).loadTransactions();
    });
  }

  Color ultraLightRed = const Color(0xFFFFF8F9); // lighter than #FFF0F2


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);
    final transactions = notifier.filteredTransactions();

    return Scaffold(

      backgroundColor: ultraLightRed,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // backgroundColor: ultraLightRed,
        title: const Text('History',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
        ),
        centerTitle: true,
        leading: IconButton(

          icon: Icon(Theme.of(context).platform == TargetPlatform.iOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: () {

          },
        ),
        actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: SafeArea(

        child: RefreshIndicator(
          onRefresh: () => ref.read(transactionNotifierProvider.notifier).loadTransactions(),
          child: LayoutBuilder(builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 36 : 16, vertical: 16),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage:
                          AssetImage('assets/images/netflixIcon.jpg'),
                        ),
                        // CircleAvatar(radius: 36, backgroundImage: NetworkImage(transactions.isNotEmpty ? transactions.first.logo : 'https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg')),
                        const SizedBox(height: 8),
                        Text('Netflix', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Production Company', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Total payment + month selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Total payment', style: TextStyle(fontWeight: FontWeight.w600)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            RichText(
                              text: TextSpan(
                                children: [
                                  // The main amount
                                  TextSpan(
                                    text: '${state.totalPayment.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // The floating $ symbol
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.top,
                                    child: Transform.translate(
                                      offset: const Offset(2, -8), // adjust for perfect positioning
                                      child: Text(
                                        '\$',
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          // color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),



                            // Text('\$${state.totalPayment.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            SizedBox(width: MediaQuery.of(context).size.width * .4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'May',
                                  items:  [
                                    DropdownMenuItem(value: 'May', child: Text('May')),
                                    DropdownMenuItem(value: 'Apr', child: Text('Apr')),
                                  ],
                                  onChanged: (v) {},
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Donut chart
                  SizedBox(
                    height: isTablet ? 300 : 220,
                    child: Center(child: _buildDonut(context, transactions.cast<TransactionModel>(), state.totalPayment)),
                  ),
                  const SizedBox(height: 20),
                  Text('Transactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 10),
                  // Tab switcher
                  _buildTabSwitcher(context),
                  const SizedBox(height: 12),
                  // Loading / Error / List
                  if (state.loading)
                    const SizedBox(height: 200, child: LoadingSpinner())
                  else if (state.error != null)
                    SizedBox(
                      height: 160,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${state.error}'),
                            const SizedBox(height: 12),
                            ElevatedButton(onPressed: () => ref.read(transactionNotifierProvider.notifier).loadTransactions(), child: const Text('Retry'))
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return TransactionCard(
                          tx: tx,
                          onTap: () async {
                            final updated = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TransactionDetailScreen(transaction: tx)));
                            // after returning, reload or update provider as needed
                            if (updated == true) {
                              setState(() {}); // UI update; provider already updated
                            }
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher(BuildContext context) {
    final state = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);
    return Row(
      children: TransactionFilter.values.map((f) {
        final active = f == state.filter;
        final label = f == TransactionFilter.all ? 'All' : f == TransactionFilter.thisMonth ? 'This Month' : 'Last Month';
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(label),
            selected: active,
            onSelected: (_) => notifier.setFilter(f),
          ),
        );
      }).toList(),
    );
  }





  Widget _buildDonut(BuildContext context, List<TransactionModel> transactions, double total) {
    // Simple sample distribution: split by absolute amount for slices
    if (transactions.isEmpty) {
      return const Text('No data');
    }

    final slices = transactions.map((t) => t.amount.abs()).toList();
    final sum = slices.fold<double>(0, (p, e) => p + e);
    final sections = <PieChartSectionData>[];

    final colors = [Colors.purple, Colors.green, Colors.lightBlue, Colors.orange, Colors.pink];
    for (var i = 0; i < slices.length; i++) {
      final value = slices[i];
      final percent = sum == 0 ? 0.0 : (value / sum) * 100.0;
      sections.add(PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: '',
        radius: 60,
        showTitle: false,
      ));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 60,
            sectionsSpace: 4,
            startDegreeOffset: -90,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text('Netflix Expenses', style: TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }
}
